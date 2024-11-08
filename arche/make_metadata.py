#!/usr/bin/env python
import glob
import os
import shutil
from datetime import datetime
from AcdhArcheAssets.uri_norm_rules import get_normalized_uri
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import normalize_string, make_entity_label, nsmap, get_xmlid
from rdflib import Graph, Namespace, URIRef, RDF, Literal, XSD
from tqdm import tqdm
from datetime import datetime

hodie = datetime.today().strftime('%Y-%m-%d')
nsmap = {"tei": "http://www.tei-c.org/ns/1.0"}

g = Graph().parse("arche/arche_constants.ttl")
ACDH = Namespace("https://vocabs.acdh.oeaw.ac.at/schema#")
ACDHI = Namespace("https://id.acdh.oeaw.ac.at/") 
G_REPO_OBJECTS = Graph().parse("arche/repo_objects_constants.ttl")
ID = Namespace("https://id.acdh.oeaw.ac.at/staribacher")
TO_INGEST = "to_ingest"
break_count = 0
shutil.rmtree(TO_INGEST, ignore_errors=True)
os.makedirs(TO_INGEST, exist_ok=True)
shutil.copy("html/images/title-img.png", "to_ingest/title-img.png")

kreisky_contributors = [ACDHI['ggazzari'], ACDHI['ggraf'], ACDHI['msteiner'], ACDHI['ttretzmueller'], ACDHI['mtrinkaus']]
acdh_contributors = [ACDHI['pandorfer'], ACDHI['cfhaak'], ACDHI['mrauschsupola']]          

def make_pic_resources(doc, collection, digitisers, uri):
    pictures = doc.any_xpath(".//tei:pb/@facs")
    subcollection = URIRef(f"{collection}/facsimiles")
    g.add((subcollection, RDF.type, ACDH["Collection"]))
    [g.add((subcollection, ACDH["hasDigitisingAgent"], digitiser)) for digitiser in digitisers]
    g.add((subcollection, ACDH["isPartOf"], URIRef(collection)))
    g.add((subcollection, ACDH["hasTitle"], Literal("Faksimiles", lang="de")))
    g.add((subcollection, ACDH["hasTitle"], Literal("Facsimiles", lang="en")))
    g.add((subcollection, ACDH["hasArrangement"], Literal(f"Die Sammlung enthält {len(pictures)} Bilddateien.", lang="de")))
    g.add((subcollection, ACDH["hasArrangement"], Literal(f"The collection contains {len(pictures)} picture files.", lang="en")))
    next_item = False
    for pic in pictures[::-1]:
        resourcename = pic.split("/")[-5].strip()
        basename = resourcename.split('.')[-2]
        resource = URIRef(f"{collection}/facsimiles/{resourcename}")
        g.add((resource, RDF.type, ACDH["Resource"]))
        if next_item:
            g.add((resource, ACDH["hasNextItem"], next_item))
        next_item = URIRef(f"{collection}/facsimiles/{resourcename}")
        g.add((resource, ACDH["hasTitle"], Literal(basename, lang="und")))
        g.add((resource, ACDH["hasFilename"], Literal(resourcename)))
        [g.add((resource, ACDH["hasDigitisingAgent"], digitiser)) for digitiser in digitisers]
        g.add((resource, ACDH["isPartOf"], subcollection))
        g.add((resource, ACDH["isSourceOf"], uri))
        g.add((resource, ACDH['hasCategory'], URIRef("https://vocabs.acdh.oeaw.ac.at/archecategory/image")))
    # g.add((subcollection, ACDH["hasNextItem"], resource))
    return len(pictures)

def get_creators(doc):
    creators = doc.any_xpath(".//tei:respStmt")
    c_dict = {'Gustav Graf': ACDHI['ggraf'], 'Matthias Trinkaus': ACDHI['mtrinkaus'], 'Thomas Tretzmüller': ACDHI['ttretzmueller'], 'Maria Steiner': ACDHI['msteiner']}
    resps = {'digitisers': [], 'tei_creators': [], 'others': []}
    for creator in creators:
        if creator.xpath('./tei:resp[contains(text(),"TEI")]', namespaces=nsmap):
            r = 'tei_creators'
        elif creator.xpath('./tei:resp[contains(text(),"OCR")]', namespaces=nsmap):
            r = 'digitisers'
        else:
            r = 'others'
        contributors = creator.xpath('./tei:persName/text()', namespaces=nsmap)
        for contributor in contributors:
            resps[r].append(c_dict[contributor.strip()])
    return resps

files = glob.glob("data/indices/*.xml")

[g.add((URIRef(ID), ACDH['hasContributor'], contributor)) for contributor in kreisky_contributors + acdh_contributors]
for x in tqdm(files, total=len(files)):
    if "siglen" in x:
        continue
    else:
        fname = os.path.split(x)[-1]
        shutil.copyfile(x, os.path.join(TO_INGEST, fname))
        doc = TeiReader(x)
        uri = URIRef(f"{ID}/indices/{fname}")
        g.add((uri, RDF.type, ACDH["Resource"]))
        g.add((uri, ACDH["isPartOf"], URIRef(f"{ID}/indices")))
        g.add((uri, ACDH["hasIdentifier"], URIRef(f"{ID}/{fname}")))
        g.add((uri, ACDH["hasFilename"], Literal(fname)))
        g.add((uri, ACDH["hasCategory"], URIRef("https://vocabs.acdh.oeaw.ac.at/archecategory/text/tei")))
        try:
            has_title = normalize_string(
                doc.any_xpath(".//tei:titleStmt[1]/tei:title[@level='a']/text()")[0]
            )
        except IndexError:
            has_title = normalize_string(
                doc.any_xpath(".//tei:titleStmt[1]/tei:title[1]/text()")[0]
            )
        g.add((uri, ACDH["hasTitle"], Literal(has_title, lang="de")))
        g.add((uri, ACDH["hasTitle"], Literal(has_title, lang="en")))
        creators = get_creators(doc)

files = glob.glob("data/editions/*.xml")
files = files
volumes = []
band_coverage = {}
band_volumes = {}
with open("date_issues.txt", "w") as fp:
    for x in tqdm(files, total=len(files)):
        #if break_count > 3 :
        #    break
        #else:
        #    break_count += 1
        fname = os.path.split(x)[-1]
        shutil.copyfile(x, os.path.join(TO_INGEST, fname))
        doc = TeiReader(x)
        creators = get_creators(doc)
        # col = f"{ID}/editions/{fname.split('.')[-2]}"
        shelfmark =  doc.any_xpath('.//tei:idno[@type="signature"]/text()')[0].lower().split("_")
        volume = shelfmark[0].strip("band")
        if volume not in ['01', '02']:
            continue
        entry = ''.join(shelfmark[1:])
        volume_col = URIRef(f"{ID}/{volume}")
        if volume not in volumes:
            volumes.append(volume)
            band_coverage[volume] = []
            band_volumes[volume] = []
            g.add((volume_col, RDF.type, ACDH["Collection"]))
            g.add((volume_col, ACDH["hasTitle"], Literal(f"Band {volume}", lang="de")))
            g.add((volume_col, ACDH["hasTitle"], Literal(f"Volume {volume}", lang="en")))
            g.add((volume_col, ACDH["hasDescription"], Literal(f"Band {volume}", lang="de")))
            g.add((volume_col, ACDH["hasDescription"], Literal(f"Volume {volume}", lang="en")))
            g.add((volume_col, ACDH["isPartOf"], URIRef(ID)))
        if entry not in band_volumes[volume]:
            band_volumes[volume].append(entry)
        collection = URIRef(f"{ID}/{volume}/{entry}")
        g.add((collection, RDF.type, ACDH["Collection"]))
        uri = URIRef(f"{ID}/{volume}/{entry}/{fname}")
        g.add((collection, ACDH["isPartOf"], volume_col))
        n_pics = make_pic_resources(doc, f"{ID}/{volume}/{entry}", creators['digitisers'], uri)
        try:
            pid = doc.any_xpath(".//tei:idno[@type='handle']/text()")[0]
        except IndexError:
            pid = "XXXX"
        if pid.startswith("http"):
            g.add((uri, ACDH["hasPid"], Literal(pid)))
        g.add((uri, RDF.type, ACDH["Resource"]))
        url = f"https://staribacher.acdh.oeaw.ac.at/{fname.replace('.xml', '.html')}"
        g.add((uri, ACDH["hasUrl"], Literal(url, datatype=XSD.anyURI)))
        g.add((uri, ACDH["isPartOf"], collection))
        g.add((uri, ACDH["hasIdentifier"], URIRef(f"{ID}/{volume}/{entry}/{fname}")))
        g.add((uri, ACDH["hasFilename"], Literal(fname)))
        g.add((uri, ACDH["hasCategory"], URIRef("https://vocabs.acdh.oeaw.ac.at/archecategory/text/tei")))
        g.add((uri, ACDH["hasAuthor"], URIRef("https://d-nb.info/gnd/125942052")))
        try:
            has_title = normalize_string(
                doc.any_xpath(".//tei:titleStmt[1]/tei:title[@level='a']/text()")[0]
            )
        except IndexError:
            has_title = normalize_string(
                doc.any_xpath(".//tei:titleStmt[1]/tei:title[1]/text()")[0]
            )
        g.add((uri, ACDH["hasTitle"], Literal(has_title, lang="und")))
        print(f'<{uri}> acdh:hasTitle "{has_title}"@en , "{has_title}"@de .')
        g.add((uri, ACDH["hasTitle"], Literal(has_title, lang="en")))
        # Collections
        coverage = doc.any_xpath(".//tei:creation/tei:date/@*")
        coverage.sort()
        coverageStart = Literal(coverage[0], datatype=XSD.date)
        coverageEnd = Literal(coverage[-1], datatype=XSD.date)
        band_coverage[volume] += coverage
        g.add((collection, ACDH["hasTitle"], Literal(f"{coverage[0]}", lang="und")))
        print(f'<{collection}> acdh:hasTitle "{has_title}"@de , "{has_title}"@en .')
        g.add((collection, ACDH["hasArrangement"], Literal("Die Sammlung enthält eine XML-TEI-Edition vom Tagebucheintrag und eine Untersammlung mit den Faksimiles.", lang="de")))
        g.add((collection, ACDH["hasArrangement"], Literal("The collections contains a XML-TEI edition of the diary entry and a subcollection with the facsimiles.", lang="en")))
        for subject in [collection, uri]:
            g.add((subject, ACDH["hasCoverageStartDate"], coverageStart))
            g.add((subject, ACDH["hasCoverageEndDate"], coverageEnd))
            g.add((subject, ACDH["hasNonLinkedIdentifier"], Literal('_'.join(shelfmark))))
        for digitiser in creators['digitisers']:
            g.add((uri, ACDH["hasDigitisingAgent"], digitiser))
            g.add((collection, ACDH["hasContributor"], digitiser))
        for creator in creators['tei_creators']:
            g.add((uri, ACDH["hasCreator"], creator))
            g.add((collection, ACDH["hasContributor"], creator))

        # PDFS
        # pdf_fname = fname.replace(".xml", ".pdf")
        # shutil.copyfile(os.path.join("html", pdf_fname), os.path.join(TO_INGEST, pdf_fname))
        # pdf_uri = URIRef(f"{ID}/{pdf_fname}")
        # g.add((pdf_uri, RDF.type, ACDH["Resource"]))
        # g.add((pdf_uri, ACDH["isPartOf"], URIRef(f"{ID}/editions")))
        # g.add(
        #    (
        #        pdf_uri,
        #        ACDH["hasCategory"],
        #        URIRef("https://vocabs.acdh.oeaw.ac.at/archecategory/text"),
        #    )
        # )
        # g.add((pdf_uri, ACDH["hasTitle"], Literal(f"{has_title} (PDF Version)", lang="de")))

        try:
            start_date = doc.any_xpath(".//tei:titleStmt[1]/tei:title[@type='iso-date']")[
                0
            ].text
            g.add(
                (
                    uri,
                    ACDH["hasCreatedStartDateOriginal"],
                    Literal(start_date, datatype=XSD.date),
                )
            )
            g.add(
                (
                    uri,
                    ACDH["hasCreatedEndDateOriginal"],
                    Literal(start_date, datatype=XSD.date),
                )
            )
        except IndexError:
            pass

        created_start_date = doc.any_xpath(".//tei:revisionDesc/tei:change/@when")[0]
        created_end_date = doc.any_xpath(".//tei:revisionDesc/tei:change/@when")[-1]
        try:
            if datetime.fromisoformat(created_start_date).date() >= datetime.fromisoformat(created_end_date).date():
                fp.write(f"{fname}: created_start_date: {created_start_date} > created_end_date: {created_end_date}\n")
                g.add(
                    (
                        uri,
                        ACDH["hasCreatedStartDate"],
                        Literal(created_start_date, datatype=XSD.date),
                    )
                )
                g.add(
                    (
                        uri,
                        ACDH["hasCreatedEndDate"],
                        Literal(hodie, datatype=XSD.date),
                    )
                )
            else:
                g.add(
                    (
                        uri,
                        ACDH["hasCreatedStartDate"],
                        Literal(created_start_date, datatype=XSD.date),
                    )
                )
                g.add(
                    (
                        uri,
                        ACDH["hasCreatedEndDate"],
                        Literal(created_end_date, datatype=XSD.date),
                    )
                )
        except Exception as e:
            fp.write(f"{fname}: {e}\n")

        # ENTITIES
        for y in doc.any_xpath(".//tei:back//tei:person[./tei:idno[@type='GND']]"):
            person_uri = URIRef(
                get_normalized_uri(
                    y.xpath("./tei:idno[@type='GND']/text()", namespaces=nsmap)[0]
                )
            )
            has_title = make_entity_label(
                y.xpath("./*[1]", namespaces=nsmap)[0], default_lang="de"
            )
            g.add((uri, ACDH["hasActor"], person_uri))
            g.add((collection, ACDH["hasActor"], person_uri))
            g.add((person_uri, RDF.type, ACDH["Person"]))
            g.add((person_uri, ACDH["hasTitle"], Literal(has_title[0], lang=has_title[1])))
            xml_id = get_xmlid(y)
            g.add(
                (
                    person_uri,
                    ACDH["hasUrl"],
                    Literal(f"https://staribacher.acdh.oeaw.ac.at/{xml_id}.html"),
                )
            )

        for y in doc.any_xpath(".//tei:back//tei:place[./tei:idno[@type='GEONAMES']]"):
            place_uri = URIRef(
                get_normalized_uri(
                    y.xpath("./tei:idno[@type='GEONAMES']/text()", namespaces=nsmap)[0]
                )
            )
            has_title = make_entity_label(
                y.xpath("./*[1]", namespaces=nsmap)[0], default_lang="und"
            )
            g.add((uri, ACDH["hasSpatialCoverage"], place_uri))
            g.add((place_uri, RDF.type, ACDH["Place"]))
            g.add((place_uri, ACDH["hasTitle"], Literal(has_title[0], lang=has_title[1])))
            xml_id = get_xmlid(y)
            g.add((place_uri, ACDH["hasUrl"], Literal(f"https://staribacher.acdh.oeaw.ac.at/{xml_id}.html")))

        for y in doc.any_xpath(".//tei:back//tei:org[./tei:idno[@type='GND']]"):
            org_uri = URIRef(
                get_normalized_uri(
                    y.xpath("./tei:idno[@type='GND']/text()", namespaces=nsmap)[0]
                )
            )
            has_title = make_entity_label(
                y.xpath("./*[1]", namespaces=nsmap)[0], default_lang="und"
            )
            g.add((uri, ACDH["hasActor"], org_uri))
            g.add((collection, ACDH["hasActor"], org_uri))
            g.add((org_uri, RDF.type, ACDH["Organisation"]))
            g.add((org_uri, ACDH["hasTitle"], Literal(has_title[0], lang=has_title[1])))
            xml_id = get_xmlid(y)
            g.add(
                (
                    org_uri,
                    ACDH["hasUrl"],
                    Literal(f"https://staribacher.acdh.oeaw.ac.at/{xml_id}.html"),
                )
            )
volumes.sort()
[band_coverage[vol].sort() for vol in volumes]
[band_volumes[vol].sort() for vol in volumes]
#nextvol = False
for vol in volumes[::-1]:
    volume = URIRef(f"{ID}/{vol}")
#    if nextvol:
#        print(f"<{volume}> acdh:hasNextItem <{nextvol}> .")
#        g.add((volume, ACDH["hasNextItem"], nextvol))
    g.add((volume, ACDH["hasArrangement"], Literal(f"Die Sammlung enthält {len(band_volumes[vol])} Untersammlungen „JJJJ-MM-TT“, die den Tagebucheinträgen entsprechen, jede mit einer XML-TEI-codierten digitalen Ausgabe des Eintrags und einer Untersammlung „Faksimiles“ mit Faksimiles der Seiten.", lang="de")))
    g.add((volume, ACDH["hasArrangement"], Literal(f"The collection contains {len(band_volumes[vol])} subcollections 'YYYY-MM-DD' corresponding to the diary entries, each of them with a XML-TEI encoded digital edition of the entry and a subcollection 'Facsimiles' with facsimiles of the pages.", lang="en")))
#    nextvol = URIRef(f"{ID}/{vol}")
    g.add((volume, ACDH["hasCoverageStartDate"], Literal(band_coverage[vol][0], datatype=XSD.date)))
    g.add((volume, ACDH["hasCoverageEndDate"], Literal(band_coverage[vol][-1], datatype=XSD.date)))
#    nextitem = False
#    for sign in band_volumes[vol][::-1]:
#        item =  URIRef(f"{ID}/{vol}/{sign}")
#        if nextitem:
#            g.add((item, ACDH["hasNextItem"], nextitem))
#            print(f"<{item}> acdh:hasNextItem <{nextitem}> .")
#        nextitem = URIRef(f"{ID}/{vol}/{sign}")


COLS = [ACDH["TopCollection"], ACDH["Collection"], ACDH["Resource"]]
COL_URIS = set()
for x in COLS:
    for s in g.subjects(None, x):
        COL_URIS.add(s)
for x in COL_URIS:
    for p, o in G_REPO_OBJECTS.predicate_objects():
        g.add((x, p, o))

g.parse("arche/title_image.ttl")
g.serialize(os.path.join(TO_INGEST, "arche.ttl"))
