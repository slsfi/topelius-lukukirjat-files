<?xml version="1.0" encoding="utf-8"?>
<!--
This notice must be visible at all times.

Copyright (c) 2010 Mikael Norrgård (See Sharp IT). All rights reserved.
Created 2010 by Mikael Norrgård (Web: http://seesharp.witchmastercreations.com )
email: seesharp@witchmastercreations.com or mikael.norrgard@gmail.com

Rights to use and further develop given to Svenska litteratursällskapet i Finland.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei">

  <xsl:include href="inc_common.xsl" />
  
  <xsl:param name="estDocument" />
  <xsl:param name="sectionId" />
  <xsl:param name="commentTitle" />
  <xsl:param name="fileDiv" />
  <xsl:param name="noteId" />

  <xsl:template match="tei:teiHeader"/>
  
  <xsl:template name="listEditorNotes">
    <xsl:choose>
      <xsl:when test="string-length($noteId)&gt;0">
        <xsl:variable name="sourceRoot" select="//tei:text/tei:body" />
          <xsl:for-each select="$sourceRoot//tei:note[@id=$noteId]">
            <xsl:call-template name="printEditorNote" />
          </xsl:for-each>
        </xsl:when>
      <xsl:when test="string-length($sectionId)&gt;0">

        <xsl:variable name="sourceRoot" select="//tei:text/tei:body" />
        <xsl:for-each select="document($estDocument)//tei:div[@id=$sectionId]//tei:anchor[contains(@xml:id, 'start') and not(ancestor::tei:note/@place)]">
          <xsl:variable name="noteId" select="concat('en', substring(@xml:id, 6))"/>
          <xsl:for-each select="$sourceRoot//tei:note[@id=$noteId]">
            <xsl:call-template name="printEditorNote" />
          </xsl:for-each>
        </xsl:for-each>
        <xsl:for-each select="document($estDocument)//tei:div[@id=$sectionId]//tei:anchor[contains(@xml:id, 'start') and ancestor::tei:note/@place]">
          <xsl:variable name="noteId" select="concat('en', substring(@xml:id, 6))"/>
          <xsl:for-each select="$sourceRoot//tei:note[@id=$noteId]">
            <xsl:call-template name="printEditorNote" />
          </xsl:for-each>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>

        <xsl:variable name="sourceRoot" select="//tei:text/tei:body" />
        <xsl:for-each select="document($estDocument)//tei:anchor[contains(@xml:id, 'start') and not(ancestor::tei:note/@place)]">
          <xsl:variable name="noteId" select="concat('en', substring(@xml:id, 6))"/>
          <xsl:for-each select="$sourceRoot//tei:note[@id=$noteId]">
            <xsl:call-template name="printEditorNote" />
          </xsl:for-each>
        </xsl:for-each>
        <xsl:for-each select="document($estDocument)//tei:anchor[contains(@xml:id, 'start') and ancestor::tei:note/@place]">
          <xsl:variable name="noteId" select="concat('en', substring(@xml:id, 6))"/>
          <xsl:for-each select="$sourceRoot//tei:note[@id=$noteId]">
            <xsl:call-template name="printEditorNote" />
          </xsl:for-each>
        </xsl:for-each>

      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <xsl:template name="printEditorNote">
    <p>
      <xsl:attribute name="class">
        <xsl:text>teiComment note </xsl:text>
        <xsl:value-of select="@id" />
      </xsl:attribute>
      <xsl:apply-templates />
    </p>
  </xsl:template>


  <xsl:template match="tei:seg">
    <xsl:if test="not(@type='noteSection')">
      <span>
        <xsl:variable name="notePosition">
          <xsl:choose>
            <xsl:when test="@type='notePosition'">
              <xsl:call-template name="printNotePosition">
                <xsl:with-param name="notePos" select="." />
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise/>
          </xsl:choose>
        </xsl:variable>
        <xsl:if test="@type">
          <xsl:attribute name="class">
            <xsl:text>teiComment </xsl:text>
            <xsl:value-of select="@type"/>
            <xsl:if test="string-length($notePosition)&gt;0">
              <xsl:text> pk</xsl:text>
              <xsl:value-of select="$notePosition"/>
              <!--<xsl:choose>
                <xsl:when test="contains($notePosition, '–')">
                  <xsl:value-of select="substring-before($notePosition, '–')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$notePosition"/>
                </xsl:otherwise>
              </xsl:choose>-->
            </xsl:if>
          </xsl:attribute >
        </xsl:if>
        <xsl:choose>
          <xsl:when test="@type='notePosition'">
            <xsl:value-of select="$notePosition"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
      </span>
    </xsl:if>
  </xsl:template>

  <xsl:template name="printNotePosition">
    <xsl:param name="notePos"/>
    <xsl:variable name="sTo" select="substring-after($notePos, '–')" />
    <xsl:choose>
      
      <xsl:when test="$sTo != ''">
        <xsl:variable name="sFrom" select="substring-before($notePos, '–')" />
        <xsl:variable name="sP1" select="substring-after($sFrom, '_')" />
        <xsl:variable name="sP2" select="substring-after($sTo, '_')" />
        <xsl:choose>
          <xsl:when test="$sP1 != ''">
            <xsl:value-of select="$sP1"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="$sFrom='Titel' or $sFrom='Datering' or $sFrom='Fotnot'">
                <xsl:value-of select="$sFrom"/>
              </xsl:when>
              <xsl:when test="contains($sFrom, 'lg') or contains($sFrom, 'li')">
                <xsl:value-of select="substring($sFrom, 3)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="substring($sFrom, 2)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>–</xsl:text>
        <xsl:choose>
          <xsl:when test="$sP2 != ''">
            <xsl:value-of select="$sP2"/>
          </xsl:when>
          <xsl:when test="contains($sTo, 'lg') or contains($sTo, 'li')">
            <xsl:value-of select="substring($sTo, 3)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="substring($sTo, 2)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      
      <xsl:otherwise>
        <xsl:variable name="sP" select="substring-after($notePos, '_')" />
        <xsl:choose>
          <xsl:when test="$sP != ''">
            <xsl:value-of select="$sP"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="$notePos='Titel' or $notePos='Datering' or $notePos='Fotnot'">
                <xsl:value-of select="$notePos"/>
              </xsl:when>
              <xsl:when test="contains($notePos, 'lg') or contains($notePos, 'li')">
                <xsl:value-of select="substring($notePos, 3)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="substring($notePos, 2)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
      
    </xsl:choose>
  </xsl:template>


  <xsl:template match="tei:div">
    <xsl:choose>

      <xsl:when test="@type='comment'">
        <xsl:apply-templates/>
      </xsl:when>

      <xsl:when test="@type='notes'">
        <xsl:call-template name="listEditorNotes"/>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="tei:l">
    <xsl:apply-templates/>
    <br />
  </xsl:template>

  <xsl:template match="tei:address">
    <p style="font-style: italic;">
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="tei:dateline">
    <p style="text-align: right;">
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="tei:placeName">
    <span style="background-color:#F8E3BC">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:persName">
    <span style="background-color:#F8E3BC">
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  
  <xsl:template match="tei:p">
    <xsl:choose>
      <xsl:when test="ancestor::tei:note">
        <xsl:apply-templates />
      </xsl:when>


    </xsl:choose>
  </xsl:template>


  <xsl:template match="tei:emph">
    <i>
      <xsl:apply-templates/>
    </i>
  </xsl:template>

  <xsl:template match="tei:hi">
    <xsl:choose>
      <xsl:when test="@rend='raised'">
        <span style="vertical-align: 20%;">
          <xsl:apply-templates/>
        </span>
      </xsl:when>
      <xsl:otherwise>
        <i>
          <xsl:apply-templates/>
        </i>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:note"/>

  <xsl:template match="tei:pb">
    <xsl:choose>
      <xsl:when test="parent::tei:body">
        <p>
          <strong>//</strong>
        </p>
      </xsl:when>
      <xsl:otherwise>&#160;<strong>//</strong>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:table">
    <table style="border-collapse:collapse">
      <xsl:call-template name="attRend">
        <xsl:with-param name="defaultClasses" select="@xml:id"/>
      </xsl:call-template>
      <xsl:apply-templates/>
    </table>
  </xsl:template>

  <xsl:template match="tei:row">
    <tr>
      <xsl:call-template name="attRend"/>
      <xsl:apply-templates/>
    </tr>
  </xsl:template>

  <xsl:template match="tei:cell">
    <td>
      <xsl:choose>
        <xsl:when test="@role='label'">
          <xsl:call-template name="attRend">
            <xsl:with-param name="defaultClasses">bold</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="attRend"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates/>
    </td>
  </xsl:template>

  <xsl:template match="tei:add">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="tei:del" />
</xsl:stylesheet>