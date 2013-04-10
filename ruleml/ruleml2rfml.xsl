<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<?cocoon-process type="xslt"?>

<!-- Transforming Hornlog RuleML to Hornlog RFML                2001-09-17  -->
<!-- Harold Boley    "boley@informatik.uni-kl.de" -->


  <!-- process rulebase and position fact/imp transformers -->
  <xsl:template match="/rulebase">
    <rfml>
      <xsl:apply-templates/>
    </rfml>
  </xsl:template>

  <!-- process a fact, transforming it to a hn clause without premises -->
  <xsl:template match="fact">
    <hn>
      <xsl:apply-templates select="_head" mode="pattop"/>
    </hn>
  </xsl:template>


  <!-- process an imp, transforming it to a hn clause with at least one premise -->
  <xsl:template match="imp">
    <hn>
      <xsl:apply-templates select="_head" mode="pattop"/>
      <xsl:apply-templates select="_body" mode="callop"/>
    </hn>
  </xsl:template>

  <!-- process _head atom as pattop -->
  <xsl:template match="atom" mode="pattop">
    <xsl:call-template name="atomfun">
      <xsl:with-param name="pattorcall">pattop</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- process _body atom (skipping possible and) as callop -->
  <xsl:template match="atom" mode="callop">
    <xsl:call-template name="atomfun">
      <xsl:with-param name="pattorcall">callop</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- process atom and transform to pattop or callop -->
  <xsl:template name="atomfun">
    <xsl:param name="pattorcall"/>
    <xsl:element name="{$pattorcall}">
      <con>
        <xsl:value-of select="_opr/rel"/>
      </con>
      <xsl:for-each select="ind|var|cterm">
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template match="cterm">
    <struc>
      <con>
        <xsl:value-of select="_opc/ctor"/>
      </con>
      <xsl:for-each select="ind|var|cterm">
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </struc>
  </xsl:template>

  <xsl:template match="var">
    <var><xsl:value-of select="."/></var>
  </xsl:template>

  <xsl:template match="ind">
    <con><xsl:value-of select="."/></con>
  </xsl:template>

</xsl:stylesheet>