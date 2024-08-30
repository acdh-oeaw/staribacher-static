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
                        <a href="#" data-bs-target="#aot-options" type="button" data-bs-toggle="modal" title="Anpassung der Anzeige"><i class="fas fa-screwdriver-wrench" /></a>
                     </li>
                     <li class="nav-item">
                        <a href="{$teiSource}" title="XML-TEI Quelle anzeigen" target="_blank"><i class="fa-solid fa-file-code" /></a>
                     </li>
                     <li class="nav-item"><div id="fader"><i class="fa-spin fa-solid fa-spinner"></i></div>
                        <a href="#" title="PDF herunterladen" onClick="generatePDF()" id="downloadLink"><i class="fa-solid fa-download" /></a>
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
               <dl class="kommentaranhang">
                  <xsl:apply-templates select="descendant::tei:note[@type = 'textConst' or @type = 'commentary']" mode="kommentaranhang"/>
               </dl>
            </div>
         </xsl:if>
      </div>
       <div class="modal fade" id="aot-options" tabindex="-1" aria-labelledby="optionsModalLabel" aria-hidden="true">
         <xsl:call-template name="anotations" />
      </div>
      <div class="modal fade" id="zitat" tabindex="-1" aria-labelledby="zitatModalLabel" aria-hidden="true">  
         <xsl:call-template name="zitate" />
      </div>
   </xsl:template>
</xsl:stylesheet>