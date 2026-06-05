#!/usr/bin/env bash
echo "add xml:ids"
uv run add-attributes -g "./data/editions/*.xml" -b "https://staribacher.acdh.oeaw.ac.at"
uv run add-attributes -g "./data/meta/*.xml" -b "https://staribacher.acdh.oeaw.ac.at"
uv run add-attributes -g "./data/indices/*.xml" -b "https://staribacher.acdh.oeaw.ac.at"

echo "denormalize indices"
uv run denormalize-indices -f "./data/editions/*.xml" -i "./data/indices/*.xml" -m ".//*[@ref]/@ref | .//*/@source" -x ".//tei:titleStmt/tei:title[@type='main']/text()"

echo "remove notegrps from index entries in editions"
uv run ./pyscripts/rm_notegrps.py

echo "populate html/js-data/calendarData.js"
uv run ./pyscripts/make_calendar_data.py
