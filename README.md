# Staribacher Tagebuch

Application repo for the digital edition of ["Staribacher Tagebücher"](https://staribacher.acdh.oeaw.ac.at)

## install

* Clone the repo
* Change into the directory `cd staribacher-static`
* Create virtual environment `python -m venv venv`, activate it `source venv/bin/activate` and install needed python packages `pip install -r requirements.txt`
* Install saxon `./shellscripts/dl_saxon.sh`


## development

* Fetch the data `./shellscripts/fetch_data.sh`
* Enrich/process the data `./shellscripts/process_data.sh`
* Build fulltext-search index with `python pyscripts/make_ts_index.py`
* Build the app with `ant`

## run the app

* Start some server in `html` directoy e.g.
```bash
python -m http.server
```
* Open http://127.0.0.1:8000/



----

* Data is fetched from https://github.com/fun-with-editions/staribacher-data
* Build with [DSE-Static-Cookiecutter](https://github.com/acdh-oeaw/dse-static-cookiecutter)
