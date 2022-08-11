<?xml version="1.0" encoding="UTF-8"?>

<!-- Gesamtpersonenregister-XSL für \\edoc\ed000227 Religionsfriedens-Edition -->

<xsl:stylesheet 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:mets="http://www.loc.gov/METS/"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:exist="http://exist.sourceforge.net/NS/exist"
    xmlns:gndo="https://d-nb.info/standards/elementset/gnd#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    exclude-result-prefixes="tei exist mets xlink gndo rdf" 
    version="3.0">
    
    <xsl:include href="../rules/styles/param.xsl"/>
    <xsl:include href="../rules/styles/tei-phraselevel.xsl"/>
<!--    <xsl:output encoding="UTF-8" indent="yes" method="html" doctype-public="-//W3C//DTD HTML 4.01//EN" doctype-system="http://www.w3.org/TR/html4/strict.dtd"/>-->
    <xsl:output encoding="UTF-8" indent="yes" method="html" doctype-system="about:legacy-compat"/><!-- bei HTML5 -->
    
    <xsl:param name="ref"/>
    <xsl:param name="footerXML">../listPerson.xml</xsl:param>
    <xsl:param name="footerXSL">../personenregister.xsl</xsl:param>
    
    <xsl:key name="place-ref" match="tei:rs[@type='place']" use="@ref"/>
    <!-- erstellt Mai 2016 von Marcus Baumgarten auf Grundlage einer XSL-Transformation von Jennifer Bunselmeier, bearbeitet von Silke Kalmer Juli 2018 -->
    
    <xsl:template match="/">
        <html>
            <head>
                <title>Personenregister</title>
                <!--<link rel="stylesheet" type="text/css" href="../layout/styles.css"/>-->
                <link rel="stylesheet" type="text/css" media="screen"  href="../../layout/navigator.css"></link>
                <script src="../../javascript/jquery/jquery-3.3.1.min.js"></script>
                <script src="../../javascript/jquery/functions.js"></script>              
               <!-- <script src="../../javascript/navigator.js"><noscript>please activate javascript to enable functions</noscript></script>-->
            </head>
            <body>
                <!-- Bearbeitungsstand -->
                <div id="wip">
                    <p><xsl:text>&#x27A8; Hinweis: Das Personenregister ist in Bearbeitung und daher nur eingeschränkt zitierfähig.</xsl:text></p>
                    <p><xsl:text>Bis Ende 2019 sind Änderungen und Korrekturen möglich.</xsl:text></p>
                    <p><xsl:text>Danach werden etwaige Korrekturen und Ergänzungen in einem Änderungsregister gelistet.</xsl:text></p>
                </div> <!-- end WorkInProgress -->
                
                <!--  Dokumentkopf -->
                <div id="doc_header">
                    <div class="register_head">Personenregister</div>
                    <hr id="doc_header_line"/>                    
                </div>
                <div class="register">
                   <xsl:apply-templates select="//tei:listPerson/tei:person">
                      <xsl:sort select="normalize-space(tei:persName/tei:surname[1])
                         || normalize-space(tei:persName/tei:forename[1])
                         || normalize-space(tei:persName/tei:roleName[1])" />
                   </xsl:apply-templates>
                    <!--<xsl:for-each select="//tei:listPerson/tei:person">
                        <xsl:sort select="tei:persName/tei:surname[1]" />
                        <xsl:apply-templates select="."/>
                    </xsl:for-each>-->
                </div>
                <div> 
                    <xsl:call-template name="footer">
                        <xsl:with-param name="footerXML">
                            <xsl:value-of select="$footerXML"/>
                        </xsl:with-param>
                        <xsl:with-param name="footerXSL">
                            <xsl:value-of select="$footerXSL"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </div>
                <div id="info_place">
                    <xsl:for-each select="//tei:rs[generate-id() = generate-id(key('place-ref', @ref)[1])]">
                        <xsl:variable name="id" select="substring(@ref, 2)"/>
                        <xsl:apply-templates select="document('../register/listPlace.xml')//tei:place[@xml:id=$id]" mode="foot"/>
                    </xsl:for-each>
                </div>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="tei:person">
        
        <h5>
            <xsl:call-template name="head"/>           
        </h5>        
        <hr />   
        <table class="register_table">
            <tr>
                <td class="beschriftung">Name:</td>
                <td class="eintrag"><xsl:call-template name="persName"/></td>
            </tr>
            
            <xsl:if test="tei:persName/tei:roleName">
                <tr>
                    <td class="beschriftung">RoleName:</td><!-- statt "RoleName" "Titel" o.Ä.? -->
                    <td class="eintrag"><xsl:call-template name="roleName"/></td>
                </tr>
            </xsl:if>
            
            
            <xsl:if test="tei:persName/@ref">
                <tr>
                    <td class="beschriftung">Referenz:</td>
                    <td class="eintrag"><xsl:call-template name="reference"/></td>
                </tr>
            </xsl:if>
            <xsl:if test="tei:note/text()">
                <tr>
                    <td class="beschriftung">Hinweis:</td>
                    <td class="eintrag"><xsl:call-template name="note"/></td>
                </tr>
            </xsl:if>
            <!--            <tr>
                <td class="beschriftung">@xml:id:</td>
                <td class="eintrag"><xsl:call-template name="xml_id"/></td>
            </tr>--><!-- xml:id entfernen -->
            <tr>
                <td class="beschriftung"></td>
                <td class="eintrag"></td>
            </tr>
            
            <!-- Auslesen der Daten aus gnd.xml SK 03.01.2019 -->
            
            <xsl:if test="starts-with(tei:persName/@ref, 'http://d-nb.info/gnd')">
                <tr>
                    <td></td>
                    <td><span class="italic">Folgende Daten sind aus der <a href="https://www.dnb.de/DE/Professionell/Standardisierung/GND/gnd_node.html" target="_blank">GND</a> generiert:</span></td>
                </tr>
                <xsl:variable name="gndlink">
                    <xsl:value-of select="tei:persName/@ref" />
                </xsl:variable>
               <xsl:variable name="gnd" select="doc('gnd.xml')//rdf:Description[@rdf:about = $gndlink]"/>
               
                <xsl:if test="$gnd/gndo:dateOfBirth">
                    <tr>
                        <td class="beschriftung">Geburtsdatum:</td>
                        <td class="eintrag"><xsl:call-template name="birth"></xsl:call-template></td>
                    </tr>
                </xsl:if> 
                
                <xsl:if test="$gnd/gndo:dateOfDeath">
                    <tr>
                        <td class="beschriftung">Todesdatum:</td>
                        <td class="eintrag"><xsl:call-template name="death"></xsl:call-template></td>
                    </tr>
                </xsl:if>
                
                <xsl:if test="$gnd/gndo:biographicalOrHistoricalInformation">
                    <tr>
                        <td class="beschriftung">Biographie:</td>
                        <td class="eintrag"><xsl:call-template name="bio"></xsl:call-template></td>
                    </tr>
                </xsl:if>
            </xsl:if>
            <!-- gnd Ende -->
            
            <!-- Suchbutton SK
            <tr>
                <xsl:variable name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:variable>
                <td></td>
                <td class="beschriftung">
                   
                       <form method="get" action="personensuche.xql"> -->
            <!-- evtl. <fieldset> o.Ä. weil form/button verursacht Probleme beim Validieren, da bei xhtml.strict(!) input oder button direkt in form verboten ist
                         <button class="pers" name="pers_id" value="{$id}">Textstellen</button>
                        
                        </form>           
                </td>                
            </tr>  -->
        </table>
    </xsl:template>
    
    <xsl:template name="persName">
        <xsl:apply-templates select="tei:persName"  mode="noRoleName"/>
        
    </xsl:template>
    
    <xsl:template match="tei:roleName" mode="noRoleName"/> 
    
    <xsl:template name="surname">
        <xsl:value-of select="tei:surname"/>
    </xsl:template>
    
    <xsl:template name="head">
        <span class="bold">
            <xsl:if test="tei:persName/tei:surname">
                <xsl:value-of select="tei:persName/tei:surname"/>
                <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:value-of select="tei:persName/tei:forename"/>
        </span>     
    </xsl:template>
    
    <xsl:template name="forename">
        <xsl:for-each select="tei:forename">
            <xsl:value-of select="."/>
            <xsl:text> </xsl:text>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="nameLink">
        <xsl:value-of select="tei:nameLink"/>
        <xsl:text> </xsl:text>
    </xsl:template>
    
    <xsl:template name="addName">
        <xsl:value-of select="tei:addName"/>
        <xsl:text> </xsl:text>
    </xsl:template>
    
    
    <xsl:template name="roleName">
        <xsl:value-of select="tei:persName/tei:roleName"/>
    </xsl:template>
    
    <xsl:template name="reference">
        <a>
            <xsl:attribute name="href"><!--
                <xsl:value-of select="$gnd"/>-->
                <xsl:value-of select="tei:persName/@ref"/></xsl:attribute>
            <xsl:attribute name="target">_blank</xsl:attribute>
            <xsl:value-of select="tei:persName/@ref"/>
        </a>
    </xsl:template>
    
    
    <xsl:template name="note">
        <xsl:apply-templates select="tei:note"/>
    </xsl:template>
    
    <xsl:template name="birth">        
        <xsl:variable name="gndlink">
            <xsl:value-of select="tei:persName/@ref" />
        </xsl:variable>
        <xsl:value-of select="document('gnd.xml')//rdf:Description[@rdf:about=$gndlink]//gndo:dateOfBirth"/>        
    </xsl:template>
    
    <xsl:template name="death">
        <xsl:variable name="gndlink">
            <xsl:value-of select="tei:persName/@ref" />
        </xsl:variable>
        <xsl:value-of select="document('gnd.xml')//rdf:Description[@rdf:about=$gndlink]//gndo:dateOfDeath"/>       
    </xsl:template>
    
    <xsl:template name="bio"> 
        <xsl:variable name="gndlink">
            <xsl:value-of select="tei:persName/@ref" />
        </xsl:variable>    
        <xsl:for-each select="document('gnd.xml')//rdf:Description[@rdf:about=$gndlink]//gndo:biographicalOrHistoricalInformation"><!-- bei mehreren Elementen (Hinweis: Information manchmal doppelt?) SK 03.01.2019 -->
            <xsl:value-of select="."/><br></br>    
        </xsl:for-each>
    </xsl:template> 
    <!--     
    <xsl:template name="xml_id">
        <xsl:value-of select="@xml:id"/>
    </xsl:template> 
    -->
    
    <!-- Einfügen der Place-Links SK 19.07.2018 --> 
    <xsl:template match="tei:rs">
        <xsl:if test="@type='place'">
            <a>
                <xsl:attribute name="title">
                    <xsl:text>Ort</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="id">
                    <xsl:value-of select="generate-id()"/>
                </xsl:attribute>
                <xsl:attribute name="href">
                    <xsl:value-of select="@ref"/>
                </xsl:attribute>
                <xsl:attribute name="class">
                    <xsl:text>rs-ref place</xsl:text>
                </xsl:attribute>                            
                <xsl:apply-templates/>
            </a>
        </xsl:if>
    </xsl:template>    
    
    <xsl:template match="tei:place" mode="foot">
        <xsl:call-template name="format-place"/>
    </xsl:template>
    
    <xsl:template name="format-place">
        <div id="{@xml:id}">
            <xsl:attribute name="class">
                <xsl:text>rs-ref</xsl:text>
            </xsl:attribute>           
            
            <xsl:if test="tei:placeName">
                <span class="placeName">
                    <xsl:value-of select="tei:placeName/."/>
                    <xsl:if test="tei:placeName[@ref]">
                        <br/>
                        <a target="_blank">
                            <xsl:attribute name="href">
                                <xsl:value-of select="tei:placeName/@ref"/>
                            </xsl:attribute>
                            weiterführende Informationen
                        </a>
                    </xsl:if>
                </span><xsl:text> </xsl:text>               
            </xsl:if>           
        </div>
    </xsl:template>
    
</xsl:stylesheet>

    