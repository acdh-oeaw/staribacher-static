<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
    <xsl:template match="/" name="nav_bar">
            <nav class="navbar navbar-expand-lg bg-body-tertiary nav-main">
                <div class="container-fluid">
                    <a href="index.html" class="navbar-brand custom-logo-link" rel="home" itemprop="url">
                        <img src="{$project_logo}" class="img-fluid logo" title="{$project_title}" alt="{$project_title}" itemprop="logo" />
                    </a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarSupportedContent">
                        <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">Projekt</a>
                                <ul class="dropdown-menu">
                                    <li>
                                        <a class="dropdown-item" href="about.html">Über das Projekt</a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="contact.html">Kontakt</a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="imprint.html">Impressum</a>
                                    </li>
                                </ul>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="toc.html">Tagebucheinträge</a>
                            </li>
                             <li class="nav-item">
                                <a title="Personen" class="nav-link" href="listperson.html">Personen</a>
                            </li>
			    <li class="nav-item">
                                <a title="Kalender" class="nav-link" href="calendar.html">Kalender</a>
                            </li>
                            <li class="nav-item">
                                <a title="Textsuche" class="nav-link" href="search.html">Suche</a>
                            </li>
                        </ul>
                        <ul class="navbar-nav me-2 mb-2 mb-lg-0">
                            <form class="d-flex" role="search" method="GET" action="search.html">
                                <input class="form-control me-2" type="search" placeholder="Suche" aria-label="Suche" name="STB[query]"></input>
                                <button class="btn navbar-btn" type="submit">Suche</button>
                            </form>
                        </ul>
                    </div>
                </div>
            </nav>
    </xsl:template>
</xsl:stylesheet>
