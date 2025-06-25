<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:zte="http://www.topelius.fi">

	<xsl:include href="inc_common.xsl"/>

	<xsl:template match="tei:teiHeader"/>

	<xsl:template match="tei:body">
		<div class="tei container cont_titlepage">
			<xsl:apply-templates/>
			<xsl:call-template name="listFootnotes"/>
			<xsl:call-template name="endSpace"/>
		</div>
	</xsl:template>

	<xsl:template match="tei:head">
		<xsl:choose>
			<xsl:when test="@type = 'title'">
				<h1>
					<xsl:attribute name="class">
						<xsl:text>tei title</xsl:text>
					</xsl:attribute>
					<xsl:apply-templates/>
				</h1>
			</xsl:when>
			<xsl:when test="@type = 'subtitle'">
				<p>
					<xsl:attribute name="class">
						<xsl:text>tei subtitle</xsl:text>
					</xsl:attribute>
					<xsl:apply-templates/>
				</p>
			</xsl:when>
			<xsl:when test="@type = 'collectiontitle'">
				<p>
					<xsl:attribute name="class">
						<xsl:text>tei collectiontitle</xsl:text>
					</xsl:attribute>
					<xsl:apply-templates/>
				</p>
			</xsl:when>
			<xsl:when test="@type = 'sub'">
				<h4>
					<xsl:attribute name="class">
						<xsl:text>tei sub</xsl:text>
					</xsl:attribute>
					<xsl:apply-templates/>
				</h4>
			</xsl:when>
			<xsl:when test="@type = 'ZTS'">
				<p>
					<xsl:attribute name="class">
						<xsl:text>tei seriestitle</xsl:text>
					</xsl:attribute>
					<xsl:apply-templates/>
				</p>
			</xsl:when>
			<xsl:when test="parent::tei:table">
				<caption>
					<xsl:call-template name="attRend">
						<xsl:with-param name="defaultClasses">
							<xsl:text>tei table-caption</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates/>
				</caption>
			</xsl:when>
			<xsl:otherwise>
				<h3>
					<xsl:attribute name="class">
						<xsl:text>tei chapter</xsl:text>
						<xsl:if test="@style = 'blackletter'">
							<xsl:text> blackletter</xsl:text>
						</xsl:if>
					</xsl:attribute>
					<xsl:apply-templates/>
				</h3>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:div">
		<xsl:choose>
			<xsl:when test="@type = 'comments'"/>
			<xsl:otherwise>
				<div>
					<xsl:if test="@id">
						<xsl:attribute name="id">
							<xsl:value-of select="@id"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates/>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:opener">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:ref">
		<a>
			<xsl:attribute name="class">
				<xsl:text>tei reference</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="href">
				<xsl:value-of select="@target"/>
			</xsl:attribute>
			<xsl:apply-templates/>
		</a>
	</xsl:template>

	<xsl:template match="tei:lg">
		<p class="tei strofe">
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="tei:l">
		<xsl:if test="(@n mod 5) = 0">
			<span style="position:absolute;left:-12px;width:18px;color:#a9a49a;">
				<xsl:value-of select="@n"/>
			</span>
		</xsl:if>
		<xsl:if test="@rend = 'indent'">
			<xsl:text>&#160;&#160;&#160;&#160;&#160;&#160;&#160;</xsl:text>
		</xsl:if>
		<xsl:apply-templates/>
		<br/>
	</xsl:template>

	<xsl:template match="tei:address">
		<p style="font-style: italic;">
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="tei:dateline">
		<p style="margin-bottom: 1.0em;">
			<xsl:choose>
				<xsl:when test="@rend = 'italics'">
					<span style="font-style:italic">
						<xsl:apply-templates/>
					</span>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
		</p>
	</xsl:template>

	<xsl:template match="tei:salute">
		<xsl:choose>
			<xsl:when test="parent::tei:closer">
				<p> &#160;&#160;&#160;&#160;&#160;&#160;&#160;<xsl:apply-templates/>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<p>
					<xsl:apply-templates/>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:signed">
		<xsl:choose>
			<xsl:when test="parent::tei:closer">
				<p style="text-align: right;">
					<xsl:apply-templates/>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<p>
					<xsl:apply-templates/>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:title">
		<span class="tei title">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:orgName">
		<span class="tei orgName">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:placeName">
		<span class="tei placeName">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:persName">
		<span class="tei person target15 hideTitle">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:p">
		<p>
			<xsl:call-template name="attRend"/>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="tei:i">
		<i>
			<xsl:apply-templates/>
		</i>
	</xsl:template>

	<xsl:template match="tei:sic"/>

	<xsl:template match="tei:corr">
		<span class="tei corr">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:orig"/>

	<xsl:template match="tei:reg">
		<xsl:choose>
			<xsl:when test="parent::tei:choice">
				<span class="tei corr">
					<xsl:apply-templates/>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<span class="tei reg">
					<xsl:apply-templates/>
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:emph">
		<i>
			<xsl:apply-templates/>
		</i>
	</xsl:template>

	<xsl:template match="tei:hi">
		<xsl:choose>
			<xsl:when test="@rend = 'italics' or @rend = 'italic'">
				<i>
					<xsl:apply-templates/>
				</i>
			</xsl:when>
			<xsl:when test="@rend = 'bold'">
				<b>
					<xsl:apply-templates/>
				</b>
			</xsl:when>
			<xsl:when test="@rend = 'bold italics'">
				<b>
					<i>
						<xsl:apply-templates/>
					</i>
				</b>
			</xsl:when>
			<xsl:when test="@rend = 'smallCaps'">
				<span>
					<xsl:call-template name="attRend">
						<xsl:with-param name="defaultClasses">
							<xsl:text>smallcaps</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates/>
				</span>
			</xsl:when>
			<xsl:when test="@rend = 'expanded'">
				<span class="tei trueexpanded">
					<xsl:apply-templates/>
				</span>
			</xsl:when>
			<xsl:when test="contains(@rend, 'underline')">
				<span>
					<xsl:call-template name="attRend">
						<xsl:with-param name="defaultClasses">
							<xsl:text>true-underline</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates/>
				</span>
			</xsl:when>
			<xsl:when test="@rend = 'raised'">
				<span style="vertical-align: 20%;">
					<xsl:apply-templates/>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<span>
					<xsl:call-template name="attRend"/>
					<xsl:apply-templates/>
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:pb">
		<xsl:choose>
			<xsl:when test="parent::tei:body or parent::tei:div">
				<p>
					<xsl:call-template name="att_pb_class"/>
					<xsl:call-template name="pb_text"/>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<span>
					<xsl:call-template name="att_pb_class"/>
					<xsl:call-template name="pb_text"/>
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:table">
		<table>
			<xsl:apply-templates/>
		</table>
	</xsl:template>

	<xsl:template match="tei:row">
		<tr>
			<xsl:apply-templates/>
		</tr>
	</xsl:template>

	<xsl:template match="tei:add">
		<span style="vertical-align: 30%;">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:del">
		<span style="text-decoration: line-through;">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:cell">
		<td>
			<xsl:apply-templates/>
		</td>
	</xsl:template>

	<xsl:template match="tei:figure">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:graphic">
		<img>
			<xsl:attribute name="src">
				<xsl:text>assets/images/verk/</xsl:text>
				<xsl:value-of select="@url"/>
			</xsl:attribute>
			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="@url = 'pdf.gif'">
						<xsl:text>tei pdf_figure_graphic</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>tei tit_figure_graphic</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="alt">
				<xsl:text>bild</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="loading">
				<xsl:text>lazy</xsl:text>
			</xsl:attribute>
		</img>
	</xsl:template>

	<xsl:template match="tei:lb">
		<br/>
	</xsl:template>

</xsl:stylesheet>
