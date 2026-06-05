# Staribacher Tagebuch

Application repo for the digital edition of ["Staribacher Tagebücher"](https://staribacher.acdh.oeaw.ac.at)

## install

The project uses [uv](https://docs.astral.sh/uv/), as Python package and project manager and [ant](https://ant.apache.org/) to build the HTML files

* Clone the repo
* Change into the directory `cd staribacher-static`

## development

* Fetch the data `./shellscripts/fetch_data.sh`
* Enrich/process the data `./shellscripts/process_data.sh`
* Build fulltext-search index with `uv run pyscripts/make_ts_index.py`
* Build the app with `ant`

## run the app

* Start some server in `html` directoy e.g.

```bash
uv run -m http.server
```

* Open <http://127.0.0.1:8000/>

----

* Data is fetched from <https://github.com/acdh-oeaw/staribacher-data>
* Build with [DSE-Static-Cookiecutter](https://github.com/acdh-oeaw/dse-static-cookiecutter)

## Licenses

This project is released under the [MIT License](LICENSE)

### SAXON-HE

The projects also includes Saxon-HE, which is licensed separately under the Mozilla Public License, Version 2.0 (MPL 2.0). See the dedicated [LICENSE.txt](saxon/notices/LICENSE.txt)
