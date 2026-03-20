<?xml version="1.0" encoding="utf-8"?>
<!--
This notice must be visible at all times.

Copyright (c) 2010 Mikael Norrgård (See Sharp IT). All rights reserved.
Created 2010 by Mikael Norrgård (Web: http://swww.seesharp.fi )
email: seesharp@witchmastercreations.com or mikael.norrgard@gmail.com

Rights to use and further develop given to Svenska litteratursällskapet i Finland.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei">

	<xsl:include href="inc_common.xsl"/>

	<xsl:template match="tei:closer">
		<p class="tei teiManuscript noIndent teiCloser">
			<xsl:call-template name="placeIcon"/>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="tei:persName | tei:rs">
		<span>
			<xsl:call-template name="attRend">
				<xsl:with-param name="defaultClasses">
					<xsl:text>person tooltiptrigger ttPerson</xsl:text>
					<xsl:if test="@correspUncert = 'Y'">
						<xsl:text> uncertain</xsl:text>
					</xsl:if>
					<xsl:if test="@role = 'fictional'">
						<xsl:text> fictional</xsl:text>
					</xsl:if>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:if test="@corresp">
				<xsl:attribute name="data-id">
					<xsl:value-of select="@corresp"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:placeName">
		<span>
			<xsl:call-template name="attRend">
				<xsl:with-param name="defaultClasses">
					<xsl:text>placeName tooltiptrigger ttPlace</xsl:text>
					<xsl:if test="@correspUncert = 'Y'">
						<xsl:text> uncertain</xsl:text>
					</xsl:if>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:if test="@corresp">
				<xsl:attribute name="data-id">
					<xsl:value-of select="@corresp"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:title">
		<span>
			<xsl:call-template name="attRend">
				<xsl:with-param name="defaultClasses">title tooltiptrigger ttTitle</xsl:with-param>
			</xsl:call-template>
			<xsl:if test="@corresp">
				<xsl:attribute name="data-id">
					<xsl:value-of select="@corresp"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:foreign">
		<span>
			<xsl:call-template name="attRend">
				<xsl:with-param name="defaultClasses">foreign tooltiptrigger ttLang</xsl:with-param>
			</xsl:call-template>
			<xsl:attribute name="lang">
				<xsl:value-of select="@xml:lang"/>
			</xsl:attribute>
			<xsl:apply-templates/>
		</span>
		<xsl:call-template name="xmlLang"/>
	</xsl:template>

	<xsl:template match="tei:note">
		<xsl:choose>
			<xsl:when test="@type = 'instruction'">
				<xsl:choose>
					<xsl:when test="ancestor::tei:p or ancestor::tei:lg">
						<span class="tei teiManuscript small">
							<xsl:apply-templates/>
						</span>
					</xsl:when>
					<xsl:otherwise>
						<p class="tei teiManuscript small">
							<xsl:apply-templates/>
						</p>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="contains(@type, 'editor')">
				<img src="assets/images/asterisk.svg" loading="lazy">
					<xsl:attribute name="class">
						<xsl:text>tei teiManuscript comment commentScrollTarget tooltiptrigger ttComment </xsl:text>
						<xsl:value-of select="@id"/>
					</xsl:attribute>
					<xsl:attribute name="data-id">
						<xsl:value-of select="@id"/>
					</xsl:attribute>
					<xsl:attribute name="alt">
						<xsl:text>kommentar</xsl:text>
					</xsl:attribute>
				</img>
				<span class="tei teiManuscript tooltip">
					<span class="tei teiManuscript ttFixed">
						<xsl:apply-templates/>
					</span>
				</span>
			</xsl:when>
			<xsl:when test="contains(@place, 'foot') or contains(@place, 'end') or contains(@id, 'ftn')">
				<span class="tei teiManuscript footnoteindicator hand">
					<xsl:attribute name="class">
						<xsl:text>tei teiManuscript footnoteindicator tooltiptrigger ttFoot </xsl:text>
						<xsl:value-of select="@id"/>
					</xsl:attribute>
					<xsl:attribute name="data-id">
						<xsl:value-of select="@id"/>
					</xsl:attribute>
					<xsl:attribute name="tabindex">
						<xsl:text>0</xsl:text>
					</xsl:attribute>
					<xsl:value-of select="@n"/>
				</span>
				<span class="tei teiManuscript tooltip ttFoot">
					<span class="tei teiManuscript ttFixed">
						<xsl:attribute name="data-id">
							<xsl:value-of select="@id"/>
						</xsl:attribute>
						<xsl:apply-templates/>
					</span>
				</span>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:pb">
		<span>
			<xsl:call-template name="att_pb_class"/>
			<xsl:call-template name="pb_text"/>
		</span>
	</xsl:template>

</xsl:stylesheet>
