#!/usr/bin/env bash
./shellscripts/fetch_data.sh
./shellscripts/process_data.sh
./pyscripts/make_ts_index.py
ant

