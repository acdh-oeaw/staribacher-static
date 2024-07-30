<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
   xmlns="http://www.w3.org/1999/xhtml"
   xmlns:tei="http://www.tei-c.org/ns/1.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   exclude-result-prefixes="#all"
   version="2.0">
   <xsl:variable name="quotationURL">
      <xsl:value-of
         select="concat('https://fun-with-editions.github.io/staribacher-static/', replace(tokenize(base-uri(), '/')[last()], '.xml', '.html'))"
      />
   </xsl:variable>
   <xsl:variable name="currentDate">
      <xsl:value-of select="format-date(current-date(), '[D1].[M1].[Y4]')"/>
   </xsl:variable>
   <xsl:variable name="plainText">
      <xsl:value-of select="concat('Josef Staribacher – Tagebücher. Digitale Edition. Hg. Remigio Gazzari, Gustav Graf, Maria Mesner, Maria Steiner, Thomas Tretzmüller und Matthias Trinkaus, ',
         $quotationURL,
         ' (Abfrage ',
         $currentDate,
         ')'
         )" />
   </xsl:variable>
   <xsl:template match="/" name="html_optionsbar">
      <div class="card-footer" style="clear: both;">
         <nav class="navbar navbar-expand-lg" style="box-shadow: none;">
            <div class="container-fluid" style="display: flex; justify-content: center; align-items: center;">
               <div id="navbarSupportedContent">
                  <ul class="navbar-nav mb-2 mb-lg-0" id="secondary-menu">
                     <xsl:if test="ends-with($prev,'.html')">
                        <li class="nav-item">
                           <a>
                              <xsl:attribute name="href">
                                 <xsl:value-of select="$prev"/>
                              </xsl:attribute>
                              <i class="fa-solid fa-caret-left" title="Vorheriger Eintrag"/>
                           </a>
                        </li>
                     </xsl:if>
                     <li class="nav-item">
                        <xsl:call-template name="annotation-options" />
                     </li>
                     <li class="nav-item">
                     <a href="{$teiSource}" title="XML-TEI Quelle anzeigen" target="_blank">
                     <i class="fa-solid fa-file-code" />
                        </a>
                     </li>
                     <li class="nav-item">
                        <a href="#" data-bs-target="#zitat" type="button" data-bs-toggle="modal" title="Zitieren"><i class="fa-solid fa-quote-left" /></a>
                     </li>
                     <li class="nav-item">
                         <a href="#" data-bs-target="#zitatkopieren" type="button" onclick="copyTextToClipboard('{$plainText}')"  title="Zitat kopieren"><i class="fa-solid fa-copy" /></a>
                     </li>
                     <xsl:if test="ends-with($next, '.html')">
                        <li>
                           <a>
                              <xsl:attribute name="href">
                                 <xsl:value-of select="$next"/>
                              </xsl:attribute>
                              <i class="fa-solid fa-caret-right" title="Nächster Eintrag"/>
                           </a>
                        </li>
                     </xsl:if>
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
      <div class="modal fade" id="zitat" tabindex="-1" aria-labelledby="zitatModalLabel" aria-hidden="true">  
         <div class="modal-dialog">
            <div class="modal-content">
               <div class="modal-header">
                  <h5 class="modal-title" id="exampleModalLabel">Zitat</h5>
                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Schließen"/>
               </div>
               <div class="modal-body">
                  <p>Eine zitierfähige Angabe dieser Seite lautet:</p>
                  <blockquote>
                     <xsl:value-of select="concat('„', $doc_title, '“. In: ')" />
                     <span style="font-style:italic;">
                        <xsl:value-of select="'Josef Staribacher – Tagebücher'" />
                     </span>
                     <xsl:value-of select="'. Digitale Edition. Hg. Remigio Gazzari, Gustav Graf, Maria Mesner, Maria Steiner, Thomas Tretzmüller und Matthias Trinkaus, '" />
                     <a href="$quotationURL">
                        <xsl:value-of select="$quotationURL" />
                     </a>
                     <xsl:value-of select="concat(' (Abfrage ', $currentDate, ')')"/>                  
                  </blockquote>
                  <p/>                    
                  <p>Für gekürzte Zitate reicht die Angabe der Briefnummer aus, die eindeutig und persistent ist:
                     »<b><xsl:value-of select="replace(tokenize(base-uri(), '/')[last()], '.xml', '')"/></b>«.
                  </p>
                  <p>Für Belege in der Wikipedia kann diese Vorlage benutzt werden:</p>
                  <blockquote>
                     <code>{{Internetquelle
                        |url=https://fun-with-editions.github.io/staribacher-static/<xsl:value-of
                        select="$link"/> |titel=<xsl:value-of
                        select="$doc_title"/> |werk=Josef Staribacher – Tagebücher | hrsg= Remigio Gazzari, Gustav Graf, Maria Mesner, Maria Steiner, Thomas Tretzmüller und Matthias Trinkaus|sprache=de
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