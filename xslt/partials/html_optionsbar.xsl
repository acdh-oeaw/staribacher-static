<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
   xmlns="http://www.w3.org/1999/xhtml"
   xmlns:tei="http://www.tei-c.org/ns/1.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   exclude-result-prefixes="#all"
   version="2.0">
   <xsl:template match="/" name="html_optionsbar">
      <div class="optionsbar mt-auto py-3">
         <div class="wrapper" id="wrapper-optionsbar-full">
            <div class="container" id="optionsbar-full-content" tabindex="-1">
               <div class="row">
                  <div id="einstellungen" class="col-lg-1 col-md-auto col-sm-2 col-xs-6 ml-auto text-center">
                     <xsl:call-template name="annotation-options"></xsl:call-template>
                     Einstallungen
                  </div>
                  <div class="col-lg-1 col-md-auto col-sm-2 col-xs-6 ml-auto text-center" id="einstellungen" tabindex="-1">
                     <a href="{$teiSource}" title="TEI/XML Quelle anzeigen">
                        <i class="fas fa-download" />
                        XML-TEI
                     </a>
                  </div>
                  <div class="modal fade col-lg-1 col-md-auto col-sm-2 col-xs-6 ml-auto text-center" id="zitat" tabindex="-1" aria-labelledby="zitatModalLabel" aria-hidden="true">  
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="exampleModalLabel">Zitat</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Schließen"/>
                            </div>
                            <div class="modal-body">
                                <p>Eine zitierfähige Angabe dieser Seite lautet:</p>
                                <blockquote>
                                    <xsl:value-of select="$quotationString"/>
                                </blockquote>
                                <p/>
                                <p>Für gekürzte Zitate reicht die Angabe der Briefnummer aus, die
                                    eindeutig und persistent ist: »<b><xsl:value-of
                                            select="replace(tokenize(base-uri(), '/')[last()], '.xml', '')"
                                        /></b>«.</p>
                                <p>Für Belege in der Wikipedia kann diese Vorlage benutzt
                                    werden:</p>
                                <blockquote>
                                    <code>{{Internetquelle
                                            |url=https://schnitzler-briefe.acdh.oeaw.ac.at/<xsl:value-of
                                            select="$link"/> |titel=<xsl:value-of
                                            select="$doc_title"/> |werk=Arthur Schnitzler:
                                        Briefwechsel mit Autorinnen und Autoren |hrsg=Martin Anton
                                        Müller, Gerd-Hermann Susen, Laura Untner |sprache=de
                                            |datum=<xsl:value-of
                                            select="//tei:titleStmt/tei:title[@type = 'iso-date']/@when-iso"
                                        /> |abruf=<xsl:value-of
                                            select="format-date(current-date(), '[Y4]-[M02]-[D02]')"
                                        /> }} </code>
                                </blockquote>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary"
                                    data-bs-dismiss="modal">Schließen</button>
                            </div>
                        </div>
                    </div>
                </div>
               </div>
            </div>
         </div>
        </div>
    </xsl:template>
</xsl:stylesheet>