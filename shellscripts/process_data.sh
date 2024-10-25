#!/usr/bin/env bash
echo "add xml:ids"
add-attributes -g "./data/editions/*.xml" -b "https://staribacher.acdh.oeaw.ac.at"
add-attributes -g "./data/meta/*.xml" -b "https://staribacher.acdh.oeaw.ac.at"
add-attributes -g "./data/indices/*.xml" -b "https://staribacher.acdh.oeaw.ac.at"

echo "denormalize indices"
denormalize-indices -f "./data/editions/*.xml" -i "./data/indices/*.xml" -m ".//*[@ref]/@ref | .//*/@source" -x ".//tei:titleStmt/tei:title[@type='main']/text()"

echo "remove notegrps from index entries in editions"
./pyscripts/rm_notegrps.py

echo "populate html/js-data/calendarData.js"
./pyscripts/make_calendar_data.py
