# Staribacher Tagebuch

## install

* clone the repo
* change into the directory `cd staribacher-static`
* create virtual environment `python -m venv venv`, activate it `source venv/bin/activate` and install needed python packages `pip install -r requirements.txt`
* install saxon `./shellscripts/dl_saxon.sh`


## development

* fetch the data `./shellscripts/fetch_data.sh`
* enrich/process the data `./shellscripts/process_data.sh`

* data is fetched from https://github.com/fun-with-editions/staribacher-data
* build with [DSE-Static-Cookiecutter](https://github.com/acdh-oeaw/dse-static-cookiecutter)
