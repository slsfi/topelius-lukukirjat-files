<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0">
    
    <xsl:output method="text" omit-xml-declaration="yes" indent="no" encoding="utf-8"/>
	<xsl:param name="bookId"/>
	<xsl:param name="sectionId"/>

    <xsl:template match="tei:teiHeader"/>

    <!-- if section param given, process only matching section from all sections -->
    <xsl:template match="tei:div">
        <xsl:choose>
            <xsl:when test="string-length($sectionId) &gt; 0">
                <xsl:choose>
                    <xsl:when test="@type = 'chapter'">
                        <xsl:if test="@id = $sectionId">
                            <xsl:apply-templates/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
