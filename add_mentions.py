#!/usr/bin/env python3
import glob
from acdh_tei_pyutils.tei import TeiReader
import lxml.etree as ET
from tqdm import tqdm

files = sorted(glob.glob("./data/editions/*.xml"))


mentions = {}

sender = set()
receiver = set()
send_place = set()
for edition in tqdm(files, total=len(files)):
    doc = TeiReader(edition)
    persons = doc.any_xpath('.//tei:rs[type=""person"]')
    persons_id = [person.attrib["ref"] for person in persons if person.attrib["ref"] not in persons]
    for person in persons_id:
        if person in mentions:
            mentions[person].append(edition)
        else:
             mentions[person] = [edition]

print("writing sender, receiver, send place infos as tei:state into index files")
doc = TeiReader("./data/indices/listperson.xml")
print(mentions)
#doc.tree_to_file("./data/indices/listplace.xml")
