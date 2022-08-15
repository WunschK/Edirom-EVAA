<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs tei" version="2.0">
    
    <xsl:output method="xml"/>
    
    <!-- aktuelle Fassung vom 12.01.2022 -->
    
    <!-- Skript, um die Dateien aus dem DFG-Projekt zu aktualisieren
        - benennt die xml:id des Dokuments um
        - erneuert den Header (editor u. resp, editionStmt, projectDesc etc.
        - fügt surface in facsimile hinzu
        - aktualisiert das Register und fügt es als standOff an, aktualisiert die Bibliographie
        - passt Codierung entsprechend Bf an: 
            - milestone[@unit='line'] raus
            - bibl/ref zu rs type="bibl" ref="..."
            - quote zu q
            - lb rend='trennstrich' zu pc/lb
            - auskommentiert: choice raus        
    -->
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    
    <xsl:key name="place-ref" match="tei:rs[@type='place']" use="@ref"/>
    <xsl:key name="person-ref" match="tei:rs[@type='person']" use="@ref"/>
    <xsl:key name="bibl-ref" match="tei:ref[@type='bibl']" use="@target"/>
    <xsl:key name="abbr-ref" match="tei:ref[@type='abbr']" use="@target"/>
    
    
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- Anm.: publicationStmt/date soll bei den neuen Dateien neu hinzugefügt werden; muss noch umgesetzt werden -->
    
    <!-- Trennstrich; hinzugefügt 29.12.2021 --><!-- rausnehmen bei den Transkribus-Dateien -->
    <xsl:template match="tei:w//tei:lb">
        <xsl:choose>
            <xsl:when test="ancestor::tei:reg">
                <pc>-</pc><lb/>
            </xsl:when>
            <xsl:when test="ancestor::tei:orig">
                <xsl:choose>
                    <xsl:when test="@rend='trennstrich'">
                        <pc>-</pc><lb/>
                    </xsl:when>
                    <xsl:otherwise>
                        <lb/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="@rend='trennstrich'">
                        <pc>-</pc><lb/>
                    </xsl:when>
                    <xsl:otherwise>
                        <choice><orig/><reg><pc>-</pc></reg></choice><lb/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    
    <!-- ändert xml:id -->
    <xsl:template match="/tei:TEI/@xml:id">
        <xsl:attribute name="xml:id"><xsl:value-of select="concat('pa000008_', substring-after(., 'edoc_ed000227_fg_'))"/></xsl:attribute>
    </xsl:template>
    
    <!-- teiHeader -->
    <xsl:template match="tei:title[@level='s']"><xsl:element name="title"><xsl:attribute name="level">s</xsl:attribute><xsl:text>Europäische Religionsfrieden Digital</xsl:text></xsl:element></xsl:template>
    <xsl:template match="tei:titleStmt/tei:principal"></xsl:template>
    <xsl:template match="tei:titleStmt/tei:editor[1]"></xsl:template>
    <xsl:template match="tei:titleStmt/tei:editor[3]"><!-- bei Quellentext -->
        <xsl:element name="respStmt">
            <xsl:element name="resp"><xsl:attribute name="ref">http://id.loc.gov/vocabulary/relators/mrk</xsl:attribute><xsl:text>Mitarbeit</xsl:text></xsl:element>
            <xsl:element name="persName"><xsl:text>Kevin Wunsch</xsl:text></xsl:element>
            <xsl:element name="persName"><xsl:text>Silke Kalmer</xsl:text></xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:titleStmt/tei:editor[2][preceding-sibling::tei:author]"><!-- bei Einleitung -->
        <xsl:element name="respStmt">
            <xsl:element name="resp"><xsl:attribute name="ref">http://id.loc.gov/vocabulary/relators/mrk</xsl:attribute><xsl:text>Mitarbeit</xsl:text></xsl:element>
            <xsl:element name="persName"><xsl:text>Kevin Wunsch</xsl:text></xsl:element>
            <xsl:element name="persName"><xsl:text>Silke Kalmer</xsl:text></xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:titleStmt/tei:editor[2][not(preceding-sibling::tei:author)]"><!-- bei Quellentext um persName einzufügen -->
        <xsl:element name="editor">
            <xsl:if test="@role"><xsl:attribute name="role"><xsl:value-of select="@role"/></xsl:attribute></xsl:if>
            <xsl:if test="@ref"><xsl:attribute name="ref"><xsl:value-of select="@ref"/></xsl:attribute></xsl:if>
            <xsl:element name="persName"><xsl:value-of select="."/></xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:titleStmt/tei:author"><!-- bei Einleitung um persName einzufügen -->
        <xsl:element name="author">
            <xsl:if test="@role"><xsl:attribute name="role"><xsl:value-of select="@role"/></xsl:attribute></xsl:if>
            <xsl:if test="@ref"><xsl:attribute name="ref"><xsl:value-of select="@ref"/></xsl:attribute></xsl:if>
            <xsl:element name="persName"><xsl:value-of select="."/></xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!--    <xsl:template match="tei:publicationStmt/tei:date">
        <xsl:element name="date"><xsl:attribute name="when"><xsl:value-of select="current-date()"></xsl:value-of></xsl:attribute><xsl:attribute name="type">issued</xsl:attribute><xsl:text>2021</xsl:text></xsl:element>
    </xsl:template>-->
    
    <xsl:template match="tei:funder">
        <xsl:element name="funder"><xsl:text>Akademie der Wissenschaften und der Literatur Mainz</xsl:text></xsl:element>
        <xsl:element name="principal"><xsl:text>Unter der Leitung von Irene Dingel und Thomas Stäcker</xsl:text></xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:projectDesc/tei:p">
        <p>
            <ref target="https://eured.de">Europäische Religionsfrieden Digital</ref>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:revisionDesc"><xsl:comment><xsl:text>&lt;revisionDesc&gt;&lt;change/&gt;&lt;/revisionDesc&gt;</xsl:text></xsl:comment></xsl:template>
    
    <xsl:template match="tei:teiHeader">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
        <standOff>
            <xsl:if test="//tei:rs[@type='person']">         
                <xsl:element name="listPerson">
                    <xsl:for-each select="//tei:rs[generate-id() = generate-id(key('person-ref', @ref)[1])]">
                        <xsl:variable name="id" select="substring(@ref, 2)"/>
                        <xsl:apply-templates select="document('../register/listPerson.xml')//tei:person[@xml:id=$id]" mode="profileDesc"/>
                    </xsl:for-each>
                </xsl:element>            
            </xsl:if>
            <xsl:if test="//tei:rs[@type='place']">          
                <xsl:element name="listPlace">
                    <xsl:for-each select="//tei:rs[generate-id() = generate-id(key('place-ref', @ref)[1])]">
                        <xsl:variable name="id" select="substring(@ref, 2)"/>
                        <xsl:apply-templates select="document('../register/listPlace.xml')//tei:place[@xml:id=$id]" mode="profileDesc"/>
                    </xsl:for-each>
                    <!-- um zusätzliche Registereinträge wegen Kästchen in Kästchen zu generieren, also von Personen mit Ortsangaben -->
                    <xsl:for-each select="//tei:rs[generate-id() = generate-id(key('person-ref', @ref)[1])]">
                        <xsl:variable name="person" select="substring(@ref, 2)"/>
                        <xsl:for-each select="document('../register/listPerson.xml')//tei:person[@xml:id=$person]//tei:rs[@type='place']">
                            <!-- <xsl:if test="//tei:rs[generate-id() = generate-id(key('place-ref', @ref)[1])]">-->
                            <xsl:variable name="place" select="./substring(@ref, 2)"/> 
                            <!--    <xsl:if test="not($varplace=$place) and not($place = following::tei:rs/substring(@ref, 2))">--><!-- ergänzt 18.12.2019 SK; funktioniert nicht 17.11.2020 -->
                            <xsl:apply-templates select="document('../register/listPlace.xml')//tei:place[@xml:id=$place]"/>
                            <!--</xsl:if>-->
                            <!--      </xsl:if>-->
                        </xsl:for-each>                        
                    </xsl:for-each>
                </xsl:element>            
            </xsl:if>
        </standOff>
    </xsl:template>
    
    <!-- fügt surface hinzu -->
    <xsl:template match="tei:graphic">
        <xsl:element name="surface"><xsl:attribute name="xml:id"><xsl:value-of select="@xml:id"/></xsl:attribute>
            <xsl:element name="graphic"><xsl:attribute name="url"><xsl:value-of select="@url"/></xsl:attribute></xsl:element>
        </xsl:element>        
    </xsl:template>
    
    <!-- particDesc und settingDesc rausnehmen -->
    <xsl:template match="tei:particDesc"></xsl:template>
    
    <xsl:template match="tei:settingDesc"></xsl:template>
    
    
    <xsl:variable name="varplace" select="//tei:rs[generate-id() = generate-id(key('place-ref', @ref)[1])]/substring(@ref, 2)" ></xsl:variable><!-- um Doppelungen im Register zu vermeiden SK 08.07.2019-->
    
    <xsl:template match="tei:person" mode="profileDesc">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>     
    </xsl:template>
    
    <xsl:template match="tei:place" mode="profileDesc">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>     
    </xsl:template>
    
    
    <xsl:template match="tei:back/tei:listBibl">
        <xsl:if test="tei:bibl">
            <xsl:copy>
                <xsl:apply-templates select="@*|node()"/>
            </xsl:copy> 
        </xsl:if>
        
    </xsl:template>
    <xsl:template match="tei:back/tei:list">
        <xsl:if test="tei:item">
            <xsl:copy>
                <xsl:apply-templates select="@*|node()"/>
            </xsl:copy> 
        </xsl:if>
        
    </xsl:template>
    
    
    <!-- neu wg. neuem Bf, 24.08.2021 -->    
    <!-- lösche milestone -->
    <xsl:template match="tei:milestone[@unit='line']"></xsl:template>
    
    <!-- bibl/ref im Text bei Referenz -> rs type="bibl" ref="..."; Element ref rausnehmen;  @target zu @ref (mit URL); so dass Textinhalt von bibl jetzt in rs steht  -->
    <xsl:template match="tei:body//tei:bibl[not(ancestor::tei:listBibl)][not(child::tei:msIdentifier)]"><!-- nicht in der bibliography im Anhang und nicht bei msIdentifier im Fließtext, da sie keinen Verweis haben und msIdentifier auch nicht in rs erlaubt ist SK 12.10.2021 -->
        <xsl:element name="rs">
            <xsl:attribute name="type">bibl</xsl:attribute>
            <xsl:attribute name="ref"><xsl:value-of select="tei:ref[@type='bibl']/@target"/></xsl:attribute>
            <xsl:apply-templates select="node()"></xsl:apply-templates>
        </xsl:element>        
    </xsl:template>    
    
    <xsl:template match="tei:bibl/tei:ref[@type='bibl'][not(@subtype='long')]">
        <xsl:copy-of select="*|text()"></xsl:copy-of>
    </xsl:template>  
    
    <!-- folgendes Template wegen note mit bibl/ref in listBibl zur Umwandlung in rs[@type='bibl']; ansonsten soll bibl, auch mit einem ref, in listBibl so bleiben -->
    <xsl:template match="tei:bibl//tei:bibl[parent::tei:note][not(child::tei:msIdentifier)]">
        <xsl:element name="rs">
            <xsl:attribute name="type">bibl</xsl:attribute>
            <xsl:attribute name="ref"><xsl:value-of select="tei:ref[@type='bibl']/@target"/></xsl:attribute>
            <xsl:apply-templates select="node()"></xsl:apply-templates>
        </xsl:element>        
    </xsl:template>
    
    
    <!-- wenn kein bibl, sondern schon rs (mit ref als child); kommt vor bei Augsburger und Declaratio nach span, auch andere Dateien -->
    <xsl:template match="tei:rs[@type='bibl'][tei:ref[@type='bibl']]">
        <xsl:element name="rs">
            <xsl:attribute name="type">bibl</xsl:attribute>
            <xsl:attribute name="ref"><xsl:value-of select="tei:ref[@type='bibl']/@target"/></xsl:attribute>
            <xsl:apply-templates select="node()"></xsl:apply-templates>
        </xsl:element>
    </xsl:template> 
    
    <xsl:template match="tei:rs[@type='bibl']/tei:ref">
        <xsl:copy-of select="text()"></xsl:copy-of>
    </xsl:template>
    
    <!-- nur noch <q> benutzt werden, deswegen alle <quote> zu <q> machen -->
    <xsl:template match="tei:quote">
        <xsl:element name="q"><xsl:value-of select="."/></xsl:element>
    </xsl:template>
    
    
    <!-- choice löschen --><!-- Template soll vorerst drin bleiben, aber nicht angewandt werden -->
    <!--    <xsl:template match="tei:choice">   
        <xsl:apply-templates></xsl:apply-templates>       
    </xsl:template>
    
    <xsl:template match="tei:orig">
        <xsl:choose>
            <xsl:when test="parent::tei:choice"></xsl:when><!-\- nur löschen wenn in <choice>, um z.B. <orig>¶ </orig> ohne <choice> zu behalten -> testen wg. Speyrer Z.1581-\->
            <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:reg">
        
        <xsl:if test="tei:w">
            <xsl:apply-templates select="tei:w"></xsl:apply-templates>
        </xsl:if>
        <xsl:if test="tei:rs">
            <xsl:apply-templates select="tei:rs"></xsl:apply-templates>
        </xsl:if>
        <xsl:if test="tei:pb">
            <xsl:apply-templates select="tei:pb"></xsl:apply-templates>
        </xsl:if><!-\- 14.05.2021 betrifft evtl. auch pb muss noch getestet werden; z.B. 2. Kappeler bei A2v -\->
        <!-\-   <xsl:otherwise><xsl:copy-of select="text()"/></xsl:otherwise>-\->
        <xsl:copy-of select="text()"/>
        
    </xsl:template>-->
    
</xsl:stylesheet>
