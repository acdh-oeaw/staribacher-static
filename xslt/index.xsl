<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    version="2.0" exclude-result-prefixes="xsl tei xs local">
    
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>
    

    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>

    <xsl:template match="/">
        <xsl:variable name="doc_title">Josef Staribacher</xsl:variable>
        <xsl:variable name="doc_subtitle">Tagebücher</xsl:variable>
        <html class="h-100">
    
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="concat($doc_title, ': ', $doc_subtitle)" />
                </xsl:call-template>
            </head>            
            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <div class="flex-grow-1 justify-content-center">
                    <div class="row flex-grow-1 align-items-center justify-content-center g-5 container">
                        <div class="col-10 col-md-8 col-sm-8 col-xl-4 col-lg-6 nopadding">
                            <img src="images/title-img.png" class="d-block mx-lg-auto" alt="Staribacher" style="max-width='100%';"  loading="lazy"></img>
                        </div>
                        <div class="col-lg-6">
                            <h1 class="display-5 fw-bold"><xsl:value-of select="$doc_title"/></h1>
                            <h2 class="display-7 fw-bold"><xsl:value-of select="$doc_subtitle"/></h2>
                            <p class="lead">Dies sind die digitalisierten Tagebücher von Josef Staribacher, österreichischer Handelsminister von 1970 bis 1983.
                                <lb/>Sie umfassen rund 20.000 Seiten und spiegeln Staribachers 13-jährige Ministertätigkeit unter Bundeskanzler Bruno Kreisky in den Kabinetten Kreisky I bis IV wider.</p>
                            <div class="d-grid gap-2 d-md-flex justify-content-md-start">
                                <a href="staribacher__19700423.html" class="btn btn-primary btn-lg px-4 me-md-2">Erster Tagebucheintrag</a>
                                <a href="calendar.html" class="btn btn-outline-secondary btn-lg px-4 mainpage">Kalendarische Übersicht</a>
                            </div>
                        </div>
                    </div>
                </div>
                <xsl:call-template name="html_footer"/>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="tei:div//tei:head">
        <h2 id="{generate-id()}"><xsl:apply-templates/></h2>
    </xsl:template>
    
    <xsl:template match="tei:p">
        <p id="{generate-id()}"><xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="tei:list">
        <ul id="{generate-id()}"><xsl:apply-templates/></ul>
    </xsl:template>
    
    <xsl:template match="tei:item">
        <li id="{generate-id()}"><xsl:apply-templates/></li>
    </xsl:template>
    <xsl:template match="tei:ref">
        <xsl:choose>
            <xsl:when test="starts-with(data(@target), 'http')">
                <a>
                    <xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
                    <xsl:value-of select="."/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
