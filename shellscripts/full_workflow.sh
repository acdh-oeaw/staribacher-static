#!/bin/bash
./shellscripts/fetch_data.sh
./shellscripts/process_data.sh
./pyscripts/make_ts_index.py
./pyscripts/update_favicons.py
ant

