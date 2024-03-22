#!/usr/bin/env python3
# %%
import glob
import os
from datetime import datetime
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import extract_fulltext
from tqdm import tqdm
from typesense.api_call import ObjectNotFound
# It needs the OS variable TYPESENSE_API_KEY to be set
# Additional vars: TYPESENSE_HOST, TYPESENSE_PORT, TYPESENSE_PROTOCOL
from acdh_cfts_pyutils import TYPESENSE_CLIENT as client
# from acdh_cfts_pyutils import CFTS_COLLECTION

files = glob.glob("./data/editions/*.xml")
dateformat = "%Y-%m-%d"
# %%
current_schema = {
    "name": "STB",
    "fields": [
        {"name": "id", "type": "string"},
        {"name": "rec_id", "type": "string"},
        {"name": "title", "type": "string"},
        {"name": "full_text", "type": "string"},
        {"name": "notbefore", "type": "int32", "facet": True, "optional": True},
        {"name": "notafter", "type": "int32", "facet": True, "optional": True},
        {"name": "year", "type": "string", "facet": True, "optional": True},
        {"name": "persons", "type": "string[]", "facet": True, "optional": True},
    ],
}


# %%
try:
    client.collections["STB"].delete()
except ObjectNotFound:
    pass

# %%
# client.collections["STB"].delete()

# %%
client.collections.create(current_schema)


# ent_type="person", ent_node="person", ent_name="persName", index_file=persons_idx, modifier='@type="label"'
# %% person ??person  persName
def get_entities(ent_type, ent_node, ent_name, index_file, modifier):
    entities = []
    e_path = f'.//tei:rs[@type="{ent_type}"]/@ref'
    for p in body:
        ent = p.xpath(e_path, namespaces={"tei": "http://www.tei-c.org/ns/1.0"})
        ref = [ref.replace("#", "") for e in ent if len(ent) > 0 for ref in e.split()]
        for r in ref:
            p_path = f'.//tei:{ent_node}[@xml:id="{r}"]//tei:{ent_name}[{modifier}][1]'
            en = index_file.any_xpath(p_path)
            if en:
                entity = " ".join(" ".join(en[0].xpath(".//text()")).split())
                if len(entity) != 0:
                    entities.append(entity)
                else:
                    with open("log-entities.txt", "a") as f:
                        f.write(f"{r} in {record['id']}\n")
    return [ent for ent in sorted(set(entities))]


# %%

records = []
cfts_records = []
persons_idx = TeiReader(xml="./data/indices/listperson.xml")
for x in tqdm(files, total=len(files)):
    doc = TeiReader(xml=x)
    facs = doc.any_xpath(".//tei:body/tei:div/tei:pb/@facs")
    pages = 0
    for v in facs:
        p_group = f".//tei:body/tei:div/tei:p[preceding-sibling::tei:pb[1]/@facs='{v}']|"\
            f".//tei:body/tei:div/tei:lg[preceding-sibling::tei:pb[1]/@facs='{v}']"
        body = doc.any_xpath(p_group)
        pages += 1
        cfts_record = {
            "project": "STB",
        }
        record = {}
        record["id"] = os.path.split(x)[-1].replace(".xml", f".html?tab={str(pages)}")
        cfts_record["id"] = record["id"]
        cfts_record["resolver"] = f"/{record['id']}"
        record["rec_id"] = os.path.split(x)[-1]
        cfts_record["rec_id"] = record["rec_id"]
        r_title = " ".join(
            " ".join(
                doc.any_xpath('.//tei:titleStmt/tei:title[@level="a"]/text()')
            ).split()
        )
        record["title"] = f"{r_title} Page {str(pages)}"
        cfts_record["title"] = record["title"]
        try:
            if doc.any_xpath("//tei:creation/tei:date/@from"):
                nb_str = date_str = doc.any_xpath("//tei:creation/tei:date/@from")[0]
                na_str = doc.any_xpath("//tei:creation/tei:date/@to")[0]
            else:
                nb_str = na_str = date_str = doc.any_xpath("//tei:creation/tei:date/@when")[0]
        except IndexError:
            date_str = doc.any_xpath("//tei:creation/tei:date/text()")[0]
            data_str = date_str.split("--")[0]
            if len(date_str) > 3:
                na_str = nb = date_str
            else:

                date_str = na_str = nb_str = "1970-12-31"
        nb_tst = int(datetime.strptime(nb_str, "%Y-%m-%d").timestamp())
        na_tst = int(datetime.strptime(na_str, "%Y-%m-%d").timestamp())
        try:
            record["year"] = cfts_record["year"] = date_str
            record["notbefore"] = cfts_record["notbefore"] = nb_tst
            record["notafter"] = cfts_record["notafter"] = na_tst
        except ValueError:
            pass
        if len(body) > 0:
            # get unique persons per page
            record["persons"] = get_entities(
                ent_type="person", ent_node="person", ent_name="persName",
                index_file=persons_idx, modifier='@type="label"'
            )
            cfts_record["persons"] = record["persons"]
            # # print(type(body))
            record["full_text"] = ' '.join([extract_fulltext(p) for p in doc.any_xpath(".//tei:p")])
            # record["full_text"] = extract_fulltext(doc.any_xpath(".//tei:body")[0])
            if len(record["full_text"]) > 0:
                records.append(record)
                cfts_record["full_text"] = record["full_text"]
                cfts_records.append(cfts_record)

# %%
make_index = client.collections["STB"].documents.import_(records)

# %%
# print(make_index)
print("done with indexing STB")

# %%
# make_index = CFTS_COLLECTION.documents.import_(cfts_records, {"action": "upsert"})

make_index = client.collections["STB"].documents.import_(cfts_records, {"action": "upsert"})
# %%
# print(make_index)
print("done with cfts-index STB")
errors = [msg for msg in make_index if (msg != '"{\\"success\\":true}"' and msg != '""')]
[print(err) if errors else print("No errors") for err in errors]

# %%
