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
                    <p>APA:</p>
                    <blockquote style="text-indent: -36px; padding-left: 36px;">
                         <xsl:text>Staribacher, J. (2024). </xsl:text>
                        <span style="font-style:italic;">
                            <xsl:value-of select="$doc_title" />
                        </span>

                            <xsl:value-of select="'. Josef Staribacher – Tagebücher'" />
                        <xsl:value-of select="'. Digitale Edition (R. Gazzari, G. Graf, M. Mesner, M. Steiner, T. Tretzmüller und M. Trinkaus (Hrsg.). '" />
                        <a href="$quotationURL">
                            <xsl:value-of select="$quotationURL" />
                        </a>            
                    </blockquote>
                    <p/>                    
                    <p>Für gekürzte Zitate reicht die Angabe der Briefnummer aus, die eindeutig und persistent ist:
                        »<span style="font-style:italic;" ><xsl:value-of select="replace(tokenize(base-uri(), '/')[last()], '.xml', '')"/></span>«.
                    </p>
                    <p>Wikitext:</p>
                    <blockquote>
                        <code  style="font-family:monospace;">{{cite web<br/>
                            <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;|url=https://fun-with-editions.github.io/staribacher-static/<xsl:value-of select="$link"/><br/>
                            <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;|title=<xsl:value-of select="$doc_title"/><br/>
                            <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;|last=Staribacher<br/>
                            <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;|first=Josef<br/>
                            <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;|website=Josef Staribacher – Tagebücher<br/>
                            <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;|editor= Remigio Gazzari, Gustav Graf, Maria Mesner, Maria Steiner, Thomas Tretzmüller und Matthias Trinkaus<br/>
                            <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;|sprache=de<br/>
                            <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;|year = 2024<br/>
                            <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;|orig-date=<xsl:value-of select="//tei:creation/tei:date/@when" /><br/>
                            <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;|acces-date=<xsl:value-of select="format-date(current-date(), '[Y4]-[M02]-[D02]')"/><br/>
                            }}
                        </code>
                    </blockquote>
                    <p>BibTeX:</p>
                    <blockquote>
                    <code  style="font-family:monospace;">
                        @misc{<xsl:value-of select="data(tei:TEI/@xml:id)"/>,<br/>
                            <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;author          =   {Josef Staribacher},<br/>
                            <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;title           =   {<xsl:value-of select="$doc_title"/>},<br/>
                            <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;howpublished    =   {Josef Staribacher – Tagebücher},<br/>
                            <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;year            =   {2024},<br/>
                            <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;url             =   {https://fun-with-editions.github.io/staribacher-static/<xsl:value-of select="$link"/>},<br/>
                            <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;urldate         =   {<xsl:value-of select="format-date(current-date(), '[Y4]-[M02]-[D02]')"/>},<br/>
                            <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;editor          =   {Remigio Gazzari AND Gustav Graf AND Maria Mesner AND Maria Steiner AND Thomas Tretzmüller AND Matthias Trinkaus},<br/>
                            <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;origdate        =   {<xsl:value-of select="//tei:creation/tei:date/@when" />}<br/>
                        }
                    </code>
                    </blockquote>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Schließen</button>
                </div>
            </div>
        </div>
    </xsl:template>
</xsl:stylesheet>
