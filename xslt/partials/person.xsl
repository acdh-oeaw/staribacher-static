<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    
    <xsl:template match="tei:person" name="person_detail">
        <xsl:param name="showNumberOfMentions" as="xs:integer" select="50000" />
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <div class="card-body">
            <xsl:if test="./tei:birth/tei:date">
                    <small>Geburtsdatum:</small> <xsl:value-of select="./tei:birth/tei:date"/><br/>
            
            </xsl:if>
            <xsl:if test="./tei:birth/tei:death">
                    <small>Todesdatum:</small> <xsl:value-of select="./tei:death/tei:date"/><br/>
                
            </xsl:if>
            <xsl:if test="./tei:occupation/text()">
                <small>Tätigkeit:</small> <xsl:value-of select="tokenize(./tei:occupation, '/')[last()]"/><br/>

            </xsl:if>
            <xsl:if test="./tei:idno[@type='GND']/text()">
                <small>GND ID:</small> <a href="{./tei:idno[@type='GND']}" target="_blank"><xsl:value-of select="tokenize(./tei:idno[@type='GND'], '/')[last()]"/></a><br/>

            </xsl:if>
            <xsl:if test="./tei:idno[@type='WIKIDATA']/text()">
                <small>Wikidata ID:</small>
                <a href="{./tei:idno[@type='WIKIDATA']}" target="_blank">
                    <xsl:value-of select="tokenize(./tei:idno[@type='WIKIDATA'], '/')[last()]"/>
                </a><br/>

            </xsl:if>
            <br/>
            <hr />
            <div id="mentions">
                <legend>erwähnt in</legend>
                <ul>
                    <xsl:for-each select="./tei:noteGrp/tei:note">
                        <li>
                            <a href="{replace(./@target, '.xml', '.html')}">
                                <xsl:value-of select="./text()"/>
                            </a>
                        </li>
                    </xsl:for-each>
                </ul>
            </div>
        </div>
    </xsl:template>
</xsl:stylesheet>
