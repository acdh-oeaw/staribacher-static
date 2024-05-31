#!/usr/bin/env python3
import csv
import glob
import os
import json
from acdh_tei_pyutils.tei import TeiReader
from tqdm import tqdm

file_list = sorted(glob.glob("./data/editions/*.xml"))
data_dir = os.path.join("html", "js-data")
os.makedirs(data_dir, exist_ok=True)
out_file = os.path.join(data_dir, "calendarData.js")

no_dates = []
data = []
broken = []
for file_name in tqdm(file_list, total=len(file_list)):
    doc = TeiReader(file_name)
    head, tail = os.path.split(file_name)
    id = tail.replace(".xml", "")

    # correspAction/date
    try:
        sent_date_node = doc.any_xpath("//tei:correspAction/tei:date")[0]
    except IndexError:
        broken.append(f"missing '//tei:correspAction/tei:date' in file: {file_name}")
        continue
    is_valid_date = False
    if "when-iso" in sent_date_node.attrib:
        ca_date_when = sent_date_node.attrib["when-iso"]
        is_valid_date = True
    elif "when" in sent_date_node.attrib:
        ca_date_when = sent_date_node.attrib["when"]
        is_valid_date = True
    else:
        no_dates.append(tail)

    if is_valid_date:
        item = {
            "id": id + ".html",
            "name": doc.any_xpath("//tei:title[@type='main']/text()")[0],
            "date": ca_date_when,
        }
        data.append(item)

    # body/date
    body_dates = doc.any_xpath("//tei:body//tei:date[@type='letter']")
    for body_date_node in body_dates:
        if "when-iso" in body_date_node.attrib:
            body_date_when = body_date_node.attrib["when-iso"]
        elif "when" in body_date_node.attrib:
            body_date_when = body_date_node.attrib["when"]
        else:
            print(f"{id}: invalid date node in body", body_date_node.attrib)
            continue
        if (
            is_valid_date and body_date_when == ca_date_when
        ):  # ignore in-body authoring date
            continue

        body_date_item = {
            "name": "Brief erschlossen",
            "date": body_date_when,
            "id": False,
            "ref_by_id": id,
            "ref_by_date": ca_date_when if is_valid_date else None,
        }
        data.append(body_date_item)


print(f"{len(data)} Datumsangaben aus {len(file_list)} Dateien extrahiert")

print(f"writing calendar data to {out_file}")
with open(out_file, "w", encoding="utf8") as f:
    my_js_variable = f"var calendarData = {json.dumps(data, ensure_ascii=False)}"
    f.write(my_js_variable)

no_dates_file = "./html/no_dates.csv"
print(f"writing files without date to {no_dates_file}")

with open(no_dates_file, "w", newline="") as csvfile:
    my_writer = csv.writer(csvfile, delimiter=",")
    my_writer.writerow(["file_name"])
    for fail_name in no_dates:
        my_writer.writerow([fail_name])
for x in broken:
    print(x)
