<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template match="/">
		<xsl:element name="seg">
			<xsl:attribute name="type">
				<xsl:text>noteText</xsl:text>
			</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="p">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="em">
		<xsl:element name="hi">
			<xsl:attribute name="rend">
				<xsl:text>italics</xsl:text>
			</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="i">
		<xsl:element name="hi">
			<xsl:attribute name="rend">
				<xsl:text>italics</xsl:text>
			</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="br">
		<xsl:element name="lb"/>
	</xsl:template>
	
	<xsl:template match="sup">
		<xsl:element name="hi">
			<xsl:attribute name="rend">
				<xsl:text>raised</xsl:text>
			</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="span">
		<xsl:variable name="elemName" select="substring-before(@class, ' ')" />
		
		<xsl:choose>
			<xsl:when test="$elemName != '' and $elemName != ' '">
				<xsl:element name="{$elemName}">
					<xsl:variable name="rendAtt" select="substring-after(@class, ' ')" />
					<xsl:if test="$rendAtt != ''">
						<xsl:attribute name="rend">
							<xsl:value-of select="substring-after(@class, ' ')"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:if test="@title">
						<xsl:attribute name="corresp">
							<xsl:value-of select="@title"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates />
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{@class}">
					<xsl:if test="@title">
						<xsl:attribute name="corresp">
							<xsl:value-of select="@title"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates />
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template match="a">
		<xsl:choose>
			<xsl:when test="contains(@class, 'anchor')">
				<xsl:variable name="elemName" select="@class" />
				<xsl:element name="{$elemName}">
					<xsl:if test="@name">
						<xsl:attribute name="id">
							<xsl:value-of select="@name"/>
						</xsl:attribute>
					</xsl:if>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="@class">
					<xsl:variable name="elemName" select="substring-before(@class, ' ')" />
					<xsl:element name="{$elemName}">
						<xsl:variable name="typeAtt" select="substring-after(@class, ' ')" />
						<xsl:if test="$typeAtt != ''">
							<xsl:attribute name="type">
								<xsl:value-of select="substring-after(@class, ' ')"/>
							</xsl:attribute>
						</xsl:if>
						<xsl:if test="@href">
							<xsl:attribute name="target">
								<xsl:value-of select="@href"/>
							</xsl:attribute>
						</xsl:if>
						<xsl:apply-templates />
					</xsl:element>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
</xsl:stylesheet>
