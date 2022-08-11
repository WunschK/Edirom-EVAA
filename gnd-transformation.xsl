<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
xmlns:mets="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink"
xmlns:exist="http://exist.sourceforge.net/NS/exist"
xmlns:gndo="https://d-nb.info/standards/elementset/gnd#"
xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
exclude-result-prefixes="tei exist mets xlink rdf" version="2.0">


<xsl:template match="/">
<rdf:RDF xmlns:schema="http://schema.org/" xmlns:gndo="https://d-nb.info/standards/elementset/gnd#"
xmlns:lib="http://purl.org/library/" xmlns:owl="http://www.w3.org/2002/07/owl#"
xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:skos="http://www.w3.org/2004/02/skos/core#"
xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:editeur="https://ns.editeur.org/thema/"
xmlns:geo="http://www.opengis.net/ont/geosparql#" xmlns:umbel="http://umbel.org/umbel#"
xmlns:rdau="http://rdaregistry.info/Elements/u/" xmlns:sf="http://www.opengis.net/ont/sf#"
xmlns:bflc="http://id.loc.gov/ontologies/bflc/" xmlns:dcterms="http://purl.org/dc/terms/"
xmlns:vivo="http://vivoweb.org/ontology/core#"
xmlns:isbd="http://iflastandards.info/ns/isbd/elements/" xmlns:foaf="http://xmlns.com/foaf/0.1/"
xmlns:mo="http://purl.org/ontology/mo/" xmlns:marcRole="http://id.loc.gov/vocabulary/relators/"
xmlns:agrelon="https://d-nb.info/standards/elementset/agrelon#"
xmlns:dcmitype="http://purl.org/dc/dcmitype/" xmlns:dbp="http://dbpedia.org/property/"
xmlns:dnbt="https://d-nb.info/standards/elementset/dnb#"
xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#" xmlns:dnb_intern="http://dnb.de/"
xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:v="http://www.w3.org/2006/vcard/ns#"
xmlns:wdrs="http://www.w3.org/2007/05/powder-s#"
xmlns:ebu="http://www.ebu.ch/metadata/ontologies/ebucore/ebucore#"
xmlns:bibo="http://purl.org/ontology/bibo/" xmlns:gbv="http://purl.org/ontology/gbv/"
xmlns:dc="http://purl.org/dc/elements/1.1/">
<xsl:for-each select="//tei:listPerson/tei:person">
<xsl:copy-of select="document(concat(tei:persName/@ref, '/about/lds.rdf'))//rdf:Description"/>
</xsl:for-each>
</rdf:RDF>
</xsl:template>


</xsl:stylesheet>
