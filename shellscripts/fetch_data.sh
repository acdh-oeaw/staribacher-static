#!/usr/bin/env bash
echo "fetching transkriptions from data_repo"
curl -LO https://github.com/acdh-oeaw/staribacher-data/archive/refs/heads/main.zip
unzip ./main
rm -rf data
mv ./staribacher-data-main/data .
rm -rf ./main.zip ./staribacher-data-main

./shellscripts/dl_imprint.sh