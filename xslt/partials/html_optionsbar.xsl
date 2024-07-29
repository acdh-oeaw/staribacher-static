<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
   xmlns="http://www.w3.org/1999/xhtml"
   xmlns:tei="http://www.tei-c.org/ns/1.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   exclude-result-prefixes="#all"
   version="2.0">
   <xsl:template match="/" name="html_optionsbar">
      <div class="card-footer" style="clear: both;">
         <nav class="navbar navbar-expand-lg" style="box-shadow: none;">
            <div class="container-fluid" style="display: flex; justify-content: center; align-items: center;">
               <div id="navbarSupportedContent">
                  <ul class="navbar-nav mb-2 mb-lg-0" id="secondary-menu">
                     <li class="nav-item">
                        <a href="#" data-bs-target="#einstellungen" type="button" data-bs-toggle="modal">
                           <i class="fas fa-solid fa-screwdriver-wrench"/>
                           EINSTELLUNGEN
                        </a>
                     </li>
                     <li class="nav-item">
                        <a href="#" data-bs-target="#zitat" type="button" data-bs-toggle="modal"> <i class="fas fa-quote-right"/> ZITIEREN</a>
                     </li>
                     <li class="nav-item">
                        <a href="#" data-bs-target="#downloadModal" type="button" data-bs-toggle="modal"><i class="fas fa-solid fa-download"/> DOWNLOAD </a>
                     </li>
                  </ul>
               </div>
            </div>
         </nav>
         <xsl:if test="descendant::tei:note[@type = 'textConst' or @type = 'commentary']">
            <div class="card-body-anhang">
               <dl class="kommentarhang">
                  <xsl:apply-templates select="descendant::tei:note[@type = 'textConst' or @type = 'commentary']" mode="kommentaranhang"/>
               </dl>
            </div>
         </xsl:if>
      </div>
      <div id="einstellungen" class="modal fade">
         <xsl:call-template name="annotation-options" />
      </div>
      <div class="modal fade" id="einstellungen" tabindex="-1">
         <a href="{$teiSource}" title="TEI/XML Quelle anzeigen" />
      </div>
      <div class="modal fade" id="zitat" tabindex="-1" aria-labelledby="zitatModalLabel" aria-hidden="true">  
         <div class="modal-dialog">
            <div class="modal-content">
               <div class="modal-header">
                  <h5 class="modal-title" id="exampleModalLabel">Zitat</h5>
                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Schließen"/>
               </div>
               <div class="modal-body">
                  <p>Eine zitierfähige Angabe dieser Seite lautet:</p>
                  <blockquote><xsl:value-of select="$quotationString"/></blockquote>
                  <p/>
                  <p>Für gekürzte Zitate reicht die Angabe der Briefnummer aus, die eindeutig und persistent ist:
                     »<b><xsl:value-of select="replace(tokenize(base-uri(), '/')[last()], '.xml', '')"/></b>«.
                  </p>
                  <p>Für Belege in der Wikipedia kann diese Vorlage benutzt werden:</p>
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
                        /> }}
                     </code>
                  </blockquote>
               </div>
               <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Schließen</button>
               </div>
            </div>
         </div>
      </div>
   </xsl:template>
</xsl:stylesheet>