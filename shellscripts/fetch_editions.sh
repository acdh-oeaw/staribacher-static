#!/bin/bash
# # def vars
temp_path="./tmp_tmp/"
zip_file="${temp_path}main.zip"
fetched_data_path="${temp_path}staribacher-data-main/data"
# # prepare folder structure
rm -rf $temp_path
mkdir $temp_path
# # fetch data from repo, unzip, and move to destination
wget https://github.com/fun-with-editions/staribacher-data/archive/refs/heads/main.zip -O $zip_file
unzip $zip_file -d $temp_path
cp -r $fetched_data_path ./
# # remove temp folder
rm -rf $temp_path