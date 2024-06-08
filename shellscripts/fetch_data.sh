# bin/bash
echo "fetching transkriptions from data_repo"
curl -LO https://github.com/fun-with-editions/staribacher-data/archive/refs/heads/main.zip
unzip ./main
rm -rf data
mv ./staribacher-data-main/data .
rm -rf ./main.zip ./staribacher-data-main

./shellscripts/dl_imprint.sh