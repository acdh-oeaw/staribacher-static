<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs xsl tei" version="2.0">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>
            <h1>Widget annotation options.</h1>
            <p>Contact person: daniel.stoxreiter@oeaw.ac.at</p>
            <p>Applied with call-templates in html:body.</p>
            <p>Custom template to create interactive options for text annoations.</p>
        </desc>    
    </doc>
    
    <xsl:template name="anotations">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">Anpassung der Anzeige</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Schließen"/>
                </div>
                <div class="modal-body">
                    <ul class="modal-ul">
                        <li class="modal-li">
                            <full-size opt="fls" />
                        </li>
                        <li class="modal-li">
                            <image-switch opt="es" />
                        </li>
                        <li class="modal-li">
                            <font-size opt="fs" />
                        </li>
                        <li class="modal-li">
                            <font-family opt="ff" />
                        </li>
                        <!-- <li class="dropdown-item" style="border-top: 5px dashed lightgrey !important;">
                            <annotation-slider opt="ef"></annotation-slider>
                        </li> -->
                        <li style="border-top: 2px dashed lightgrey !important;" class="modal-li">
                            <annotation-slider opt="entities-features"></annotation-slider>
                        </li>
                        <li class="modal-li">
                            <annotation-slider opt="prs"></annotation-slider>
                        </li>
                        <li class="modal-li">
                            <annotation-slider opt="crt"></annotation-slider>
                        </li>
                        <li class="modal-li">
                            <annotation-slider opt="add"></annotation-slider>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </xsl:template>

    <xsl:template name="zitate">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">Zitat</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Schließen"/>
                </div>
                <div class="modal-body">
                    <xsl:text>APA:</xsl:text>
                    <blockquote class="citation">
                         <xsl:text>Staribacher, J. (2024). </xsl:text>
                            <xsl:value-of select="concat($doc_title, '. ')" />
                            <i class="code">Josef Staribacher – Tagebücher. Digitale Edition</i>
                        <xsl:value-of select="'. Kreisky-Archiv (Hrsg.). '" />
                        <a href="{quotationURL}">
                             <span id="currentURL" class="code"/>
                        </a>            
                    </blockquote>
                    <p/>                    
                    <xsl:text>MLA:</xsl:text>
                    <blockquote class="citation">
                         <xsl:text>Staribacher, Josef. </xsl:text>
                            <xsl:value-of select="concat('„', $doc_title, '.“ ')" />
                            <i class="code">Josef Staribacher – Tagebücher. Digitale Edition</i>
                        <xsl:value-of select="', herausgegeben von Kreisky-Archiv, 2024. '" />
                        <a href="{quotationURL}">
                             <span id="currentURL" class="code"/>
                        </a>            
                    </blockquote>
                    <p/>
                    
		    <!--<p>Für gekürzte Zitate reicht die Angabe der Briefnummer aus, die eindeutig und persistent ist:
                        »<span style="font-style:italic;" ><xsl:value-of select="replace(tokenize(base-uri(), '/')[last()], '.xml', '')"/></span>«.
                    </p> -->
 
                    <xsl:text>Wikitext:</xsl:text>
                    <blockquote class="code">
                       {{cite web<br/><p class="indent1 code">
                            |title=<xsl:value-of select="$doc_title"/><br></br>
                            |last=Staribacher<br/>
                            |first=Josef<br/>
                            |website=Josef Staribacher – Tagebücher<br/>
                            |editor=Kreisky-Archiv<br/>
                            |language=de<br/>
                            |year = 2024<br/>
                            |orig-date=<xsl:value-of select="//tei:creation/tei:date/@when" /><br/>
                            |url=<span id='currentURL' class="code" /><br/>
                            |acces-date=<xsl:value-of select="format-date(current-date(), '[Y4]-[M02]-[D02]')"/>}}</p>
                    </blockquote>
                    
		    <xsl:text>BibTeX:</xsl:text> 
                    <blockquote class="code">
                        @misc{<xsl:value-of select="data(tei:TEI/@xml:id)"/>,
                            <p class="indent1 code">
                            author          =   {Josef Staribacher},<br/>
                            title           =   {<xsl:value-of select="$doc_title"/>},<br/>
                            howpublished    =   {Josef Staribacher – Tagebücher},<br/>
                            year            =   {2024},<br/>
                            url             =   {<span id='currentURL' class="code" />},<br/>
                            urldate         =   {<xsl:value-of select="format-date(current-date(), '[Y4]-[M02]-[D02]')"/>},<br/>
                            editor          =   {Kreisky-Archiv},
                            origdate        =   {<xsl:value-of select="//tei:creation/tei:date/@when" />}}</p>
                    </blockquote>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Schließen</button>
                </div>
            </div>
        </div>
    <script type="text/javascript" src="js/currenturl.js"></script>
    </xsl:template>
</xsl:stylesheet>
