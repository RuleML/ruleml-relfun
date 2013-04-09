<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


<!--
<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:ruleml="http://www.ruleml.org/0.91/xsd"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns="http://www.ruleml.org/0.91/xsd"
>
-->


<!-- Transforming Hornlog RuleML to Hornlog RFML         2001-09-17, rev. 2006-10-19 -->
<!-- Harold Boley -->


  <!-- process Asserted rulebase and position Atom/Implies transformers -->
  <xsl:template match="/RuleML/Assert">
    <rfml>
      <xsl:apply-templates mode="clause"/>
    </rfml>
  </xsl:template>

  <!-- process a factual Atom, transforming it to a hn clause without premises -->
  <xsl:template match="Atom" mode="clause">
    <hn>
      <xsl:apply-templates select="." mode="pattop"/>
    </hn>
  </xsl:template>


  <!-- process an Implies, transforming it to a hn clause with at least one premise -->
  <xsl:template match="Implies" mode="clause">
    <hn>
      <xsl:apply-templates select="head" mode="pattop"/>
      <xsl:apply-templates select="body" mode="callop"/>
    </hn>
  </xsl:template>

  <!-- process head Atom as pattop -->
  <xsl:template match="Atom" mode="pattop">
    <xsl:call-template name="atomfun">
      <xsl:with-param name="pattorcall">pattop</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- process body Atom (skipping possible And) as callop -->
  <xsl:template match="Atom" mode="callop">
    <xsl:call-template name="atomfun">
      <xsl:with-param name="pattorcall">callop</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- process Atom and transform to pattop or callop -->
  <xsl:template name="atomfun">
    <xsl:param name="pattorcall"></xsl:param>
    <xsl:element name="{$pattorcall}">
      <con>
        <xsl:value-of select="op/Rel"/>
      </con>
      <xsl:for-each select="Ind|Var|Expr">
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template match="Expr">
    <struc>
      <con>
        <xsl:value-of select="op/Fun"/>
      </con>
      <xsl:for-each select="Ind|Var|Expr">
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </struc>
  </xsl:template>

  <xsl:template match="Var">
    <var><xsl:value-of select="."/></var>
  </xsl:template>

  <xsl:template match="Ind">
    <con><xsl:value-of select="."/></con>
  </xsl:template>

</xsl:stylesheet>
