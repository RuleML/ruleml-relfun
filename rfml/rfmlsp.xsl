<?xml version="1.0" encoding="ISO-8859-1" ?>

<!-- Written by Harold Boley "boley@informatik.uni-kl.de" -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!-- <xsl:strip-space elements="*"/> -->

  <xsl:template match="rfml">
   <xsl:processing-instruction name="cocoon-format">type="text/html"</xsl:processing-instruction>
   <html>
    <head>
     <title>Relfun KB for <xsl:value-of select="//*/pattop/*"/> etc.</title>
     <style type="text/css">
       strong { color: blue }
     </style>
    </head>
    <body bgcolor="#EEEEEE">
      <xsl:apply-templates/>
    </body>
   </html>
  </xsl:template>

  <xsl:template match="hn">
    <xsl:apply-templates select="pattop"/><xsl:if test="count(child::*)>1"><tt> :- </tt><xsl:for-each select="(con|var|struc|callop)"><xsl:apply-templates select="."/><xsl:if test="not(position()=last())"><tt>, </tt></xsl:if></xsl:for-each></xsl:if><tt>.</tt><br/>
  </xsl:template>

  <xsl:template match="ft">
    <xsl:apply-templates select="pattop"/><xsl:choose><xsl:when test="count(child::*)>2"><tt> :- </tt><xsl:for-each select="(con|var|struc|callop)[not(position()=last())]"><xsl:apply-templates select="."/><xsl:if test="not(position()=last())"><tt>, </tt></xsl:if></xsl:for-each><tt> &amp; </tt></xsl:when><xsl:otherwise><tt> :&amp; </tt></xsl:otherwise></xsl:choose><xsl:apply-templates select="(con|var|struc|callop)[position()=last()]"/><tt>.</tt><br/>
  </xsl:template>

  <xsl:template match="callop">
    <strong><xsl:apply-templates select="(con|var|struc|callop)[position()=1]"/></strong>(<xsl:for-each select="(con|var|struc|callop)[position()>1]"><xsl:apply-templates select="."/><xsl:if test="not(position()=last())"><tt>,</tt></xsl:if></xsl:for-each>)</xsl:template>

  <xsl:template match="pattop">
    <strong><xsl:apply-templates select="(con|var|struc)[position()=1]"/></strong>(<xsl:for-each select="(con|var|struc)[position()>1]"><xsl:apply-templates select="."/><xsl:if test="not(position()=last())"><tt>,</tt></xsl:if></xsl:for-each>)</xsl:template>

  <xsl:template match="struc">
    <xsl:apply-templates select="(con|var|struc)[position()=1]"/>[<xsl:for-each select="(con|var|struc)[position()>1]"><xsl:apply-templates select="."/><xsl:if test="not(position()=last())"><tt>,</tt></xsl:if></xsl:for-each>]</xsl:template>

  <xsl:template match="var">
    <i>_<xsl:value-of select="."/></i>
  </xsl:template>

  <xsl:template match="con">
    <b><xsl:value-of select="."/></b>
  </xsl:template>

</xsl:stylesheet>

