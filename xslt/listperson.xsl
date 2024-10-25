<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>
    
    
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="partials/tabulator_dl_buttons.xsl"/>
    <xsl:import href="partials/tabulator_js.xsl"/>
    <xsl:import href="./partials/person.xsl"/>

    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select=".//tei:titleStmt/tei:title[1]/text()"/>
        </xsl:variable>
        <html  class="h-100">
            
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
            </head>
            
            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>

                <main class="flex-grow-1">
                    <div class="container">
                        <h1>
                            <xsl:value-of select="$doc_title"/>
                        </h1>
                        <table class="table" id="myTable">
                            <thead>
                                <tr>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-responsive="0" tabulator-minWidth="150">Nachname</th>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-responsive="10" tabulator-minWidth="100">>Vorname</th>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-responsive="20">Tätigkeit</th>
                                    <th scope="col" tabulator-responsive="99" tabulator-visible="false">id</th>
                                </tr>
                            </thead>
                            <xsl:for-each select=".//tei:person[@xml:id]">
                                <xsl:variable name="full_path">
                                    <xsl:value-of select="current()/@xml:id" />
                                </xsl:variable>
                                <tr>
                                    <td>
                                            <xsl:value-of select=".//tei:surname/text()"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select=".//tei:forename/text()"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select="tokenize(./tei:occupation, '/')[last()]"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select="$full_path"/>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </table>
                        <xsl:call-template name="tabulator_dl_buttons"/>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
                <xsl:call-template name="tabulator_js"/>
            </body>
        </html>


        <xsl:for-each select=".//tei:person[@xml:id]">
            <xsl:variable name="id">
                <xsl:value-of select="data(@xml:id)"/>
            </xsl:variable>
            <xsl:variable name="filename" select="concat(@xml:id, '.html')"/>
            <xsl:variable name="name" select="normalize-space(string-join(tei:persName[1]//text(), ' '))"/>
            <xsl:result-document href="{$filename}">
                <html  class="h-100">
                    <head>
                        <xsl:call-template name="html_head">
                            <xsl:with-param name="html_title" select="$name"></xsl:with-param>
                        </xsl:call-template>
                    </head>
                    <body class="d-flex flex-column h-100">
                        <xsl:call-template name="nav_bar"/>
                        <main class="flex-grow-1">
                            <div class="container">
                                <h1>
                                    <xsl:value-of select="$name"/>
                                </h1>
                                <xsl:call-template name="person_detail"/>  
                            </div>
                        </main>
                        <xsl:call-template name="html_footer"/>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>