# Staribacher Tagebuch

application repo for the digital edition of ["Staribacher Tagebücher"](https://staribacher.acdh.oeaw.ac.at)

## install

* clone the repo
* change into the directory `cd staribacher-static`
* create virtual environment `python -m venv venv`, activate it `source venv/bin/activate` and install needed python packages `pip install -r requirements.txt`
* install saxon `./shellscripts/dl_saxon.sh`


## development

* fetch the data `./shellscripts/fetch_data.sh`
* enrich/process the data `./shellscripts/process_data.sh`
* build the app with `ant`

## run the app

* start some server in `html` directoy e.g.
```bash
python -m http.server
```
* open http://127.0.0.1:8000/



----

* data is fetched from https://github.com/fun-with-editions/staribacher-data
* build with [DSE-Static-Cookiecutter](https://github.com/acdh-oeaw/dse-static-cookiecutter)
