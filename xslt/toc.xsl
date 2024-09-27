<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    version="2.0" exclude-result-prefixes="xsl tei xs local">
    
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>
    
    
    <xsl:import href="partials/html_navbar.xsl"/>
    <xsl:import href="partials/html_head.xsl"/>
    <xsl:import href="partials/html_footer.xsl"/>
    <xsl:import href="partials/tabulator_dl_buttons.xsl"/>
    <xsl:import href="partials/tabulator_js.xsl"/>

    <xsl:template name="getDate">
        <xsl:variable name="dateAttr" select=".//tei:creation/tei:date/@*"/>
        <xsl:choose>
            <xsl:when test="count($dateAttr) = 1"> <!-- only "when" attribute -->
                <xsl:value-of select="$dateAttr"/>
            </xsl:when>
            <xsl:otherwise> <!-- "from" and "to" attributes -->
                <xsl:value-of select="concat($dateAttr[1], ' bis ', $dateAttr[2])"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Tagebucheinträge'"/>
    
        <html class="h-100">
    
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
            </head>
            
            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <main class="flex-grow-1">
                    <div class="container">
                        <h1><xsl:value-of select="$doc_title"/></h1>
                        <table class="table hide" id="myTable" >
                            <thead>
                                <tr>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-responsive="0" tabulator-minWidth="200">Titel</th>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-responsive="10" tabulator-minWidth="100">Datum</th>
                                    <th scope="col" tabulator-responsive="99" tabulator-visible="false">id</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each
                                    select="collection('../data/editions?select=*.xml')//tei:TEI">
                                    <xsl:sort>
                                        <xsl:value-of select="current()/@xml:id"/>
                                    </xsl:sort>
                                    <xsl:variable name="full_path">
                                        <xsl:value-of select="replace(current()/@xml:id, '.xml', '')"/>
                                    </xsl:variable>
                                    <tr>
                                        <td>
                                            <xsl:value-of select=".//tei:titleStmt/tei:title[1]/text()"/>
                                        </td>
                                        <td>
                                            <xsl:call-template name="getDate"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="$full_path"/>
                                        </td>
                                    </tr>
                                </xsl:for-each>
                            </tbody>
                        </table>
                        <xsl:call-template name="tabulator_dl_buttons"/>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
                <xsl:call-template name="tabulator_js"/>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
