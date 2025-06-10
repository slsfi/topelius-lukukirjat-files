<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0">
    
    <xsl:output method="xml" version="1.0" encoding="utf-8"/>
    <xsl:param name="estDocument"/>
	<xsl:param name="sectionId"/>

<!-- copy all nodes and attributes -->
<xsl:template match="node() | @*">
    <xsl:copy>
        <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
</xsl:template>

<!-- if section param given, copy only matching section from all sections -->
<xsl:template match="tei:div">
	<xsl:choose>
		<xsl:when test="string-length($sectionId) &gt; 0">
			<xsl:choose>
				<xsl:when test="@type = 'chapter'">
					<xsl:if test="@id = $sectionId">
						<xsl:copy>
							<xsl:apply-templates select="node() | @*"/>
						</xsl:copy>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy>
						<xsl:apply-templates select="node() | @*"/>
					</xsl:copy>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<xsl:copy>
				<xsl:apply-templates select="node() | @*"/>
			</xsl:copy>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
