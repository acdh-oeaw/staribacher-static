<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    version="2.0" exclude-result-prefixes="xsl tei xs local">
    
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes" />
    <xsl:import href="./partials/shared.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/osd-container.xsl"/>
    <xsl:import href="./partials/aot-options.xsl"/>
    <xsl:variable name="prev">
        <xsl:value-of
            select="replace(tokenize(data(tei:TEI/@prev), '/')[last()], '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="next">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@next), '/')[last()], '.xml', '.html')"
        />
    </xsl:variable>
    <xsl:variable name="teiSource">
        <xsl:value-of select="data(tei:TEI/@xml:id)"/>
        <xsl:text>.xml</xsl:text>
    </xsl:variable>
    <xsl:variable name="doc_title">
        <xsl:value-of select=".//tei:titleStmt/tei:title[@type='main']/text()"/>
    </xsl:variable>
    <xsl:variable name="link">
        <xsl:value-of select="replace($teiSource, '.xml', '.html')"/>
    </xsl:variable>
    <xsl:param name="mybreak"><![CDATA[<br/>]]></xsl:param>
    <xsl:param name="mytab"><![CDATA[&emsp;]]></xsl:param>
    <xsl:param name="myplaceholder"><![CDATA[&zwnj;]]></xsl:param>   
    <xsl:template match="/">    
        <html class="page" lang="de">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
                </xsl:call-template>
            </head>
            <body class="d-flex flex-column">
                <div class="hfeed site flex-grow-1" id="page">
                    <xsl:call-template name="nav_bar"/>
                    <div class="row" id="edition_metadata">
                        <div class="col-md-2 col-lg-2 col-sm-12">
                                <xsl:if test="ends-with($prev,'.html')">
                                    <h1>
                                        <a>
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="$prev"/>
                                            </xsl:attribute>
                                            <i class="bi bi-chevron-left" title="zurück"/>
                                        </a>
                                    </h1>
                                </xsl:if>
                            </div>
                        <div class="col-md-8 col-lg-8 col-sm-12 docinfo">
                            <xsl:variable name="doc_type"
                                select="//tei:sourceDesc/tei:msDesc/tei:physDesc/tei:objectDesc/@form[1]"/>
                            <h1 align="center">
                                <xsl:value-of select="$doc_title"/>
                            </h1>
                            <h3 align="center">
                                <a href="{$teiSource}">
                                    <i class="bi bi-download" title="TEI/XML"/>
                                </a>
                            </h3>
                        </div>
                        <div class="col-md-2 col-lg-2 col-sm-12" style="text-align:right">
                                <xsl:if test="ends-with($next, '.html')">
                                    <h1>
                                        <a>
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="$next"/>
                                            </xsl:attribute>
                                            <i class="bi bi-chevron-right" title="weiter"/>
                                        </a>
                                    </h1>
                                </xsl:if>
                            </div>
                    </div>
                        
                    <div class="edition_container ">
                        <div class="offcanvas offcanvas-start" tabindex="-1"
                            id="offcanvasNavigation" aria-labelledby="offcanvasNavigationLabel"
                            data-bs-scroll="true" data-bs-backdrop="false">
                            <div class="offcanvas-header" />
                            <div class="offcanvas-body" />
                        </div>
                        <div class="offcanvas offcanvas-end" tabindex="0" id="offcanvasOptions"
                            aria-labelledby="offcanvasOptionsLabel" data-bs-scroll="true"
                            data-bs-backdrop="false">
                        </div>
                        <div id="editor-widget">
                                <xsl:call-template name="annotation-options"></xsl:call-template>
                                </div>
                        <div class="wp-transcript">
                            <div id="container-resize" class="row transcript active">
                                <div id="img-resize" class="col-md-6 col-lg-6 col-sm-12 facsimiles">
                                    <div id="viewer">
                                        <div id="container_facs_1" class="osd-container"/>
                                    </div>
                                </div>
                                 <div id="text-resize" lang="de"
                                    class="col-md-6 col-lg-6 col-sm-12 text yes-index">
                                   <xsl:apply-templates/>
                                    <p style="margin-bottom:5cm;margin-top:5cm"><xsl:value-of select="$mybreak" disable-output-escaping="yes"/></p>
                                </div> 
                            </div>
                        </div>
                    </div>
                </div>
                <xsl:call-template name="html_footer"/>
             
                <script src="https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.1.0/openseadragon.min.js"/>
                <script type="text/javascript" src="js/osd_scroll.js"></script>
                <script src="https://unpkg.com/de-micro-editor@0.3.4/dist/de-editor.min.js"></script>
                <script type="text/javascript" src="js/run.js"></script>
            </body>
        </html>
    </xsl:template>
<xsl:template match="tei:teiHeader" />
<xsl:template match="tei:add">
    <span class="add" style="display:none;">
     <xsl:value-of select="." />
     </span>
</xsl:template>
<xsl:template match="tei:sic">
    <span class="sic">
     <xsl:value-of select="." />
     </span>
</xsl:template>
<xsl:template match="tei:corr">
    <span class="cor" style="display:none;">
     <xsl:value-of select="." />
     </span>
</xsl:template>
<xsl:template match="tei:pb">
    <xsl:choose>
        <xsl:when test="preceding-sibling::tei:lb or preceding-sibling::tei:p or ancestor::tei:back">
            <xsl:value-of select="$mybreak" disable-output-escaping="yes"/>
            <span class="hline"><xsl:value-of select="$mybreak" disable-output-escaping="yes"/></span>
            
        </xsl:when>
    </xsl:choose>
    <span class="pb" source="{@facs}">
        <xsl:value-of select="./@n" />
    </span>
    <xsl:value-of select="$mybreak" disable-output-escaping="yes"/>
</xsl:template>
<xsl:template match="tei:lb">
    <xsl:if test="@break='no'">
        <xsl:text>-</xsl:text>
    </xsl:if>
     <xsl:value-of select="$mybreak" disable-output-escaping="yes"/>
     <!-- <xsl:choose>
        <xsl:when test="not(following::tei:pb) and not(following::tei:lb) and not(following::tei:head) and not(following::tei:p)">
            <xsl:for-each select="1 to 45"><xsl:value-of select="$mybreak" disable-output-escaping="yes"/></xsl:for-each>
        </xsl:when>
    </xsl:choose> -->
     </xsl:template>
<xsl:template match="tei:p">
    <xsl:variable name="pid">
        <xsl:value-of select="./@xml:id"/>
    </xsl:variable>
    <xsl:choose>
    <xsl:when test="count(preceding-sibling::*) &lt; 1"> <!-- test="preceding::*[1]/self::tei:div"> -->
        <p id="{$pid}" class="yes-index date">
            <xsl:apply-templates/>
        </p>
    </xsl:when>
    <xsl:otherwise>
        <p id="{$pid}" class="yes-index">
            <xsl:apply-templates/>
        </p>
    </xsl:otherwise>
    </xsl:choose>
    <!-- <xsl:choose>
        <xsl:when test="not(following::tei:pb) and not(following::tei:lb) and not(following::tei:head) and not(following::tei:p)">
            <xsl:for-each select="1 to 45"><xsl:value-of select="$mybreak" disable-output-escaping="yes"/></xsl:for-each>
        </xsl:when>
    </xsl:choose> -->
</xsl:template>
    <xsl:template match="tei:head">
    <!-- There is no transcription here, making an id for the TS search unnecessary, as there are not full_text paragraphs to index -->
        <p class="yes-index">
            <xsl:apply-templates/> 
        </p>
        <xsl:choose>
        <xsl:when test="not(following::tei:pb) and not(following::tei:lb) and not(following::tei:head) and not(following::tei:p)">
            <!-- <xsl:for-each select="1 to 45"> -->
		<xsl:value-of select="$mybreak" disable-output-escaping="yes"/>
	    <!-- </xsl:for-each> -->
        </xsl:when>
    </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:rs">
        <xsl:variable name="ppid">
            <xsl:value-of select="./@ref"/>
        </xsl:variable>
        <span id="{$ppid}" class="person">
		<xsl:apply-templates/></span>
    </xsl:template> 
<xsl:template match="tei:a[contains(@class, 'navigation_')]">
        <a class="{@class}" id="{@xml:id}">
            <xsl:apply-templates/>
        </a> 
</xsl:template>
</xsl:stylesheet>
