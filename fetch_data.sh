# bin/bash
echo "fetching transkriptions from data_repo"
curl -LO https://github.com/fun-with-editions/staribacher-data/archive/refs/heads/main.zip
unzip ./main
mv ./staribacher-data-main/data .

rm -rf ./main.zip ./staribacher-data-main
