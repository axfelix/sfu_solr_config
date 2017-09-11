
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xlink="http://www.w3.org/1999/xlink" 
  xmlns:foxml="info:fedora/fedora-system:def/foxml#" 
  xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" 
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:ddi="ddi:codebook:2_5"
  exclude-result-prefixes="ddi">
  <xsl:template match="/">
    <!-- Root element for testing only-->
    <!--<xsl:element name="root">-->
      <xsl:apply-templates select="*"/>
    <!--</xsl:element>-->
  </xsl:template>
  
  <!-- Recursively traverse the tree -->
  <xsl:template  match="ddi:*">
     <xsl:if test="current()[not(*)]">
        <xsl:apply-templates mode="slurp_ddi" select="."/>
     </xsl:if>
     <xsl:apply-templates select="ddi:*"/>
  </xsl:template>

  <!-- Example of an override template if we need
  to handle specific instances differently.
  -->
  <!-- 
  <xsl:template match="ddi:confDec" mode="slurp_ddi">
 
  </xsl:template>
  -->

  <!-- Create a flat list of all text nodes.
  ex. <field name="ddi_codeBook_stdyDscr_citation_titlStmt_titl_ms">NEBC Springs Database</field>
  -->
  <xsl:template match="*" mode="slurp_ddi">
    <xsl:call-template name="build_field"> 
      <xsl:with-param name="elem_name">
        <xsl:call-template name="flatten_full_path" />
      </xsl:with-param>  
    </xsl:call-template>
  </xsl:template>

  <!-- Build the Solr field -->
  <xsl:template name="build_field" mode="slurp_ddi">
    <xsl:param name="elem_name"/>
    <xsl:param name="value">
      <xsl:value-of select="."/>
    </xsl:param>
    <xsl:element name="field">
      <xsl:attribute name="name">
        <xsl:call-template name="prefix_name_suffix">
          <xsl:with-param name="name">
            <xsl:value-of select="$elem_name"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:value-of select="normalize-space($value)"/>
    </xsl:element>
  </xsl:template>

  <!-- Flatten the full path of this node in string form -->
  <xsl:template name="flatten_full_path" mode="slurp_ddi">
    <xsl:variable name="test" select="ancestor::*" />
    <xsl:for-each select="$test">
      <xsl:value-of select="name()"/>
    <!-- Don't add underscore to last path segment -->
      <xsl:if test="*">
        <xsl:text>_</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:value-of select="local-name()"/>
  </xsl:template>

  <!-- Add solr prefix and suffix to the string -->
  <xsl:template name="prefix_name_suffix" mode="slurp_ddi">
    <xsl:param name="prefix">ddi_</xsl:param>
    <xsl:param name="name"/>
    <xsl:param name="suffix">_ms</xsl:param>
    <xsl:value-of select="concat($prefix, $name, $suffix)"/>
  </xsl:template>
</xsl:stylesheet>
