<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0" exclude-result-prefixes="xsl tei xs">

    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>



    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Kalender'"/>
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
        <html lang="de" class="h-100">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
                <script src="https://unpkg.com/js-year-calendar@latest/dist/js-year-calendar.min.js" />
                <script src="https://unpkg.com/js-year-calendar@latest/locales/js-year-calendar.de.js" />
                <link rel="stylesheet" type="text/css" href="https://unpkg.com/js-year-calendar@latest/dist/js-year-calendar.min.css" />
                <script src="js-data/calendarData.js"></script>
            </head>
            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <main class="flex-grow-1">
                    <div class="container calendar_title">
                        <h1><xsl:value-of select="$doc_title"/></h1>
                            <div class="containingloader">
                                <div class="row">
                                    <div class="col-sm-2 yearscol">
                                        <div class="row">
                                            <div class="col-sm-12">
                                                <p style="text-align:center;font-weight:bold;margin-bottom:0;">Jahr</p>
                                            </div>
                                        </div>
                                        <div class="row justify-content-md-center" id="years-table">
                                        </div>
                                        <div class="row">
                                            <div class="col-sm-12">
                                                <p style="text-align:center;font-weight:bold;margin-top:1rem;margin-bottom:0;" data-i18n="calendar__legendtitle"></p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-10">
                                        <div id="calendar"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                </main>
                <script type="text/javascript" src="./js/calendar.js" charset="UTF-8"/>
                <div id="loadModal"/>
                <xsl:call-template name="html_footer"/>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>