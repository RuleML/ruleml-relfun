<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<?cocoon-process type="xslt"?>

<!-- Transforming Hornlog RFML to Hornlog RuleML                2001-09-17  -->
<!-- Harold Boley    "boley@informatik.uni-kl.de" -->


  <!-- process rfml knowledge base and position hn transformer -->
  <xsl:template match="/rfml">
    <rulebase>
      <xsl:apply-templates/>
    </rulebase>
  </xsl:template>

  <!-- process hn clause, that is a fact,
       a single-premise, or a multi-premise implication -->
  <xsl:template match="hn">
    <xsl:choose>
      <xsl:when test="count(child::*)=1">
        <fact>
          <_head>
            <xsl:apply-templates select="pattop"/>
          </_head>
        </fact>
      </xsl:when>
      <xsl:when test="count(child::*)=2">
        <imp>
          <_head>
            <xsl:apply-templates select="pattop"/>
          </_head>
          <_body>
            <xsl:apply-templates select="con|var|struc|callop"/>
          </_body>
        </imp>
      </xsl:when>
      <xsl:otherwise>
        <imp>
          <_head>
            <xsl:apply-templates select="pattop"/>
          </_head>
          <_body>
            <and>
              <xsl:for-each select="con|var|struc|callop">
                <xsl:apply-templates select="."/>
              </xsl:for-each>
            </and>
          </_body>
        </imp>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="callop">
    <atom>
      <_opr>
        <rel>
          <xsl:value-of select="con[position()=1]"/>
        </rel>
      </_opr>
      <xsl:for-each select="(con|var|struc|callop)[position()>1]">
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </atom>
  </xsl:template>

  <xsl:template match="pattop">
    <atom>
      <_opr>
        <rel>
          <xsl:value-of select="con[position()=1]"/>
        </rel>
      </_opr>
      <xsl:for-each select="(con|var|struc)[position()>1]">
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </atom>
  </xsl:template>

  <xsl:template match="struc">
    <cterm>
      <_opc>
        <ctor>
          <xsl:value-of select="con[position()=1]"/>
        </ctor>
      </_opc>
      <xsl:for-each select="(con|var|struc)[position()>1]">
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </cterm>
  </xsl:template>

  <xsl:template match="var">
    <var><xsl:value-of select="."/></var>
  </xsl:template>

  <xsl:template match="con">
    <ind><xsl:value-of select="."/></ind>
  </xsl:template>

</xsl:stylesheet>
