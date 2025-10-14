<?xml version="1.0" encoding="utf-8"?>
<!--
This notice must be visible at all times.

Copyright (c) 2010 Mikael Norrgård (See Sharp IT). All rights reserved.
Created 2010 by Mikael Norrgård (Web: http://swww.seesharp.fi )
email: seesharp@witchmastercreations.com or mikael.norrgard@gmail.com

Rights to use and further develop given to Svenska litteratursällskapet i Finland.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei">
	<xsl:output method="html"/>
	<xsl:strip-space elements="tei:TEI tei:teiHeader tei:text"/>

	<xsl:param name="bookId"/>

	<!-- Map bookId to collection name -->
	<xsl:variable name="collection-name">
		<xsl:choose>
			<xsl:when test="$bookId = '1'">
				<xsl:value-of select="'luonnonkirja'"/>
			</xsl:when>
			<xsl:when test="$bookId = '2'">
				<xsl:value-of select="'maammekirja'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="''"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="illustrations-path" select="'assets/images/illustrations/'"/>

	<xsl:variable name="backendMediaBaseURL" select="'https://api.sls.fi/digitaledition/topelius/gallery/get/'"/> 

	<!-- OPENER CLOSER START -->

	<xsl:template match="tei:opener">
		<p class="tei noIndent teiOpener">
			<xsl:apply-templates/>
		</p>
		<!--<xsl:apply-templates/>-->
	</xsl:template>

	<xsl:template match="tei:closer">
		<p class="tei noIndent teiCloser">
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="tei:address">
		<xsl:choose>
			<xsl:when test="parent::tei:opener or parent::tei:closer">
				<xsl:if test="preceding-sibling::*">
					<br/>
					<br/>
				</xsl:if>
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:otherwise>
				<p style="font-style: italic;">
					<xsl:apply-templates/>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:salute">
		<xsl:choose>
			<xsl:when test="parent::tei:opener or parent::tei:closer">
				<xsl:if test="preceding-sibling::*">
					<br/>
					<br/>
				</xsl:if>
				<xsl:apply-templates/>
				<!--<p>
&#160;&#160;&#160;&#160;&#160;&#160;&#160;<xsl:apply-templates/>
</p>-->
			</xsl:when>
			<xsl:otherwise>
				<p class="tei noIndent">
					<xsl:apply-templates/>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:signed">
		<xsl:choose>
			<xsl:when test="ancestor::tei:opener or ancestor::tei:closer">
				<xsl:if test="preceding-sibling::*">
					<br/>
					<br/>
				</xsl:if>
				<xsl:apply-templates/>
				<!--<p style="text-align: right;">
<xsl:apply-templates/>
</p>-->
			</xsl:when>
			<xsl:otherwise>
				<p>
					<xsl:apply-templates/>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:dateline">
		<xsl:choose>
			<xsl:when test="ancestor::tei:opener or ancestor::tei:closer">
				<xsl:if test="preceding-sibling::*">
					<br/>
					<br/>
				</xsl:if>
				<span>
					<xsl:call-template name="attRend"/>
					<xsl:apply-templates/>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<p>
					<xsl:attribute name="class">
						<xsl:text>tei dateline noIndent</xsl:text>
						<xsl:if test="@style = 'blackletter'">
							<xsl:text> blackletter </xsl:text>
						</xsl:if>
					</xsl:attribute>
					<span>
						<xsl:call-template name="attRend"/>
						<xsl:apply-templates/>
					</span>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- OPENER CLOSER END -->

	<!-- TABLES START -->

	<xsl:template match="tei:table">
		<table>
			<xsl:call-template name="attRend">
				<xsl:with-param name="defaultClasses">
					<xsl:if test="@xml:id">
						<xsl:value-of select="@xml:id"/>
					</xsl:if>
				</xsl:with-param>
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
                <xsl:when test="@role = 'label' and ancestor::tei:div[@type = 'religiousWritings']">
					<xsl:call-template name="attRend">
						<xsl:with-param name="defaultClasses">smallcaps</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="@role = 'label'">
					<xsl:call-template name="attRend">
						<xsl:with-param name="defaultClasses">bold</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="attRend"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="@cols">
				<xsl:attribute name="colspan">
					<xsl:value-of select="@cols"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@rows">
				<xsl:attribute name="rowspan">
					<xsl:value-of select="@rows"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</td>
	</xsl:template>

	<!-- TABLES END-->

	<xsl:template match="tei:list">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:item">
		<xsl:choose>
			<xsl:when test="ancestor::tei:switchPos">
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:when test="following-sibling::*">
				<p class="tei l">
					<xsl:apply-templates/>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<p class="tei l">
					<xsl:apply-templates/>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:postscript">
		<xsl:apply-templates/>
		<p class="tei paragraphSpace"/>
	</xsl:template>

	<xsl:template match="tei:xref">
		<a>
			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="@type = 'introduction'">
						<xsl:text>tei xreference ref_introduction</xsl:text>
					</xsl:when>
					<xsl:when test="@type = 'readingtext'">
						<xsl:text>tei xreference ref_readingtext</xsl:text>
					</xsl:when>
					<xsl:when test="@type = 'comment'">
						<xsl:text>tei xreference ref_comment</xsl:text>
					</xsl:when>
					<xsl:when test="@type = 'ext'">
						<xsl:text>tei xreference ref_external</xsl:text>
					</xsl:when>
					<xsl:when test="@type = 'book'">
						<xsl:text>tei xreference ref_book</xsl:text>
					</xsl:when>
					<xsl:when test="@type = 'collection'">
						<xsl:text>tei xreference ref_collection</xsl:text>
					</xsl:when>
					<xsl:when test="@type = 'pdf'">
						<xsl:text>tei xreference ref_external</xsl:text>
					</xsl:when>
					<xsl:when test="@type = 'illustration'">
						<xsl:text>tei xreference ref_illustration</xsl:text>
					</xsl:when>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="href">
				<xsl:if test="@type = 'pdf'">
					<xsl:text>assets/files/</xsl:text>
				</xsl:if>
				<xsl:if test="@type = 'illustration'">
					<xsl:text>#</xsl:text>
				</xsl:if>
				<xsl:value-of select="@target"/>
				<!--<xsl:value-of select="substring(@target, 3)"/>-->
			</xsl:attribute>
			<xsl:if test="@type = 'introduction' or @type = 'readingtext' or @type = 'comment' or @type = 'illustration'">
				<xsl:attribute name="rel">
					<xsl:text>nofollow</xsl:text>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</a>
	</xsl:template>

	<xsl:template match="tei:xptr">
		<a>
			<xsl:attribute name="class">
				<xsl:text>tei</xsl:text>
				<xsl:choose>
					<xsl:when test="@type = 'illustration'">
						<xsl:text> xreference ref_illustration</xsl:text>
					</xsl:when>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="href">
				<xsl:text>#</xsl:text>
				<xsl:value-of select="@target"/>
			</xsl:attribute>
			<xsl:attribute name="rel">
				<xsl:text>nofollow</xsl:text>
			</xsl:attribute>
			<img class="tei symbol" src="assets/images/image_symbol.svg" alt="illustration" loading="lazy"/>
		</a>
	</xsl:template>

	<xsl:template match="tei:anchor">
		<a>
			<xsl:attribute name="name">
				<xsl:choose>
					<xsl:when test="@id">
						<xsl:value-of select="@id"/>
					</xsl:when>
					<xsl:when test="@xml:id">
						<xsl:value-of select="@xml:id"/>
					</xsl:when>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="class">
				<xsl:text>tei anchor </xsl:text>
				<xsl:choose>
					<xsl:when test="@id">
						<xsl:value-of select="@id"/>
					</xsl:when>
					<xsl:when test="@xml:id">
						<xsl:value-of select="@xml:id"/>
					</xsl:when>
				</xsl:choose>
			</xsl:attribute>
		</a>
	</xsl:template>

	<xsl:template match="tei:stamp">
		<span class="tei stamp">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:print">
		<span class="tei print">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:milestone">
		<xsl:choose>
			<xsl:when test="@type = 'bar'">
				<hr class="tei milestoneBar"/>
			</xsl:when>
			<xsl:when test="@type = 'smallBar'">
				<hr class="tei milestoneSmallBar"/>
			</xsl:when>
			<xsl:when test="@unit = 'part' and @when">
				<span class="tei milestoneWhen center">
					<xsl:choose>
						<xsl:when test="$bookId = '4' or $bookId = '5' or $bookId = '6'">
							<xsl:text>Avsnittet ingår i HT </xsl:text>
						</xsl:when>
						<xsl:when test="$bookId = '23' and not(@source)">
							<xsl:text>Notisen/artikeln ingår i HT </xsl:text>
						</xsl:when>
						<xsl:when test="@source">
							<xsl:text>Notisen/artikeln ingår i </xsl:text>
							<xsl:value-of select="@source"/>
							<xsl:text> </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>Avsnittet publicerades </xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="substring(@when, 9, 1) = '0'">
							<xsl:value-of select="substring(@when, 10, 1)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(@when, 9, 2)"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:text>/</xsl:text>
					<xsl:choose>
						<xsl:when test="substring(@when, 6, 1) = '0'">
							<xsl:value-of select="substring(@when, 7, 1)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring(@when, 6, 2)"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:text> </xsl:text>
					<xsl:value-of select="substring(@when, 1, 4)"/>
					<xsl:text>:</xsl:text>
				</span>
			</xsl:when>
			<xsl:when test="@unit = 'part'">
				<p class="tei milestonePart">
					<xsl:text>&#160;</xsl:text>
				</p>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:date">
		<xsl:choose>
			<xsl:when test="@rend">
				<span>
					<xsl:call-template name="attRend"/>
					<xsl:apply-templates/>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:lb">
		<xsl:choose>
			<xsl:when test="ancestor::tei:p or ancestor::tei:l or ancestor::tei:head or ancestor::tei:note or ancestor::tei:opener or ancestor::tei:closer">
				<br/>
			</xsl:when>
			<xsl:otherwise>
				<p>&#160;</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Ignore this element inside a tooltip -->
	<xsl:template match="tei:note" mode="tooltip"/>

	<xsl:template match="tei:hi" mode="tooltip">
		<span>
			<xsl:call-template name="attRend"/>
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	<xsl:template match="tei:hi">
		<span>
			<xsl:call-template name="attRend"/>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:emph" mode="tooltip">
		<xsl:choose>
			<xsl:when test="@rend">
				<span>
					<xsl:call-template name="attRend"/>
					<xsl:apply-templates/>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<span class="tei italics">
					<xsl:apply-templates/>
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="tei:emph">
		<xsl:choose>
			<xsl:when test="@rend">
				<span>
					<xsl:call-template name="attRend"/>
					<xsl:apply-templates/>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<span class="tei italics">
					<xsl:apply-templates/>
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="attRend">
		<xsl:param name="defaultClasses"/>
		<xsl:choose>
			<xsl:when test="@rend and not(@rend = 'parIndent')">
				<xsl:attribute name="class">
					<xsl:text>tei </xsl:text>
					<xsl:value-of select="$defaultClasses"/>
					<xsl:if test="string-length(normalize-space($defaultClasses)) > 0">
						<xsl:text> </xsl:text>
					</xsl:if>
					<xsl:value-of select="@rend"/>
				</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="string-length(normalize-space($defaultClasses)) > 0">
					<xsl:attribute name="class">
						<xsl:text>tei </xsl:text>
						<xsl:value-of select="$defaultClasses"/>
					</xsl:attribute>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:note">
		<xsl:variable name="handen" select="translate(@hand, '#', '')"/>
		<xsl:if test="@type = 'editor'">
			<img src="assets/images/asterisk.svg" loading="lazy">
				<xsl:attribute name="class">
					<xsl:text>tei comment commentScrollTarget tooltiptrigger ttComment </xsl:text>
					<xsl:value-of select="@id"/>
				</xsl:attribute>
				<xsl:attribute name="id">
					<xsl:value-of select="@id"/>
				</xsl:attribute>
				<xsl:attribute name="alt">
					<xsl:text>kommentar</xsl:text>
				</xsl:attribute>
			</img>
			<span class="tei tooltip">
				<span class="tei ttFixed">
					<xsl:apply-templates/>
				</span>
			</span>
		</xsl:if>
		<xsl:if test="contains(@place, 'foot') or contains(@place, 'end') or contains(@id, 'ftn')">
			<span class="tei footnoteindicator hand">
				<xsl:attribute name="class">
					<xsl:text>tei footnoteindicator tooltiptrigger ttFoot </xsl:text>
					<xsl:value-of select="@id"/>
				</xsl:attribute>
				<xsl:attribute name="id">
					<xsl:value-of select="@id"/>
				</xsl:attribute>
				<xsl:attribute name="tabindex">
					<xsl:text>0</xsl:text>
				</xsl:attribute>
				<xsl:value-of select="@n"/>
			</span>
			<span class="tei tooltip ttFoot">
				<span class="tei ttFixed">
					<xsl:attribute name="id">
						<xsl:value-of select="@id"/>
					</xsl:attribute>
					<xsl:apply-templates/>
				</span>
			</span>
		</xsl:if>
		<xsl:if test="contains(@type, 'editorial')">
			<span>
				<xsl:attribute name="class">
					<xsl:choose>
						<xsl:when test="contains(@place, 'Margin')">
							<xsl:text>tei tei_note_editorial_margin tooltiptrigger ttMs</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>tei tei_note_editorial tooltiptrigger ttMs</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:call-template name="marginAddSymbol">
					<xsl:with-param name="place" select="@place"/>
				</xsl:call-template>
				<xsl:apply-templates/>
				<xsl:call-template name="marginAddSymbol">
					<xsl:with-param name="place" select="@place"/>
				</xsl:call-template>
			</span>
		</xsl:if>
		<xsl:call-template name="mediumTooltip">
			<xsl:with-param name="hand">
				<xsl:value-of select="$handen"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="listFootnotes">
		<xsl:param name="sectionToProcess"/>
		<xsl:param name="noEmptyLines"/>
		<xsl:if test="string-length($noEmptyLines) = 0">
			<p>&#160;</p>
			<p>&#160;</p>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="string-length($sectionToProcess) &gt; 0">
				<section>
					<xsl:attribute name="role">
						<xsl:text>doc-endnotes</xsl:text>
					</xsl:attribute>
					<ol>
						<xsl:attribute name="class">
							<xsl:text>tei footnotesList</xsl:text>
						</xsl:attribute>
						<xsl:for-each select="//tei:div[@id = $sectionToProcess]//tei:note">
							<xsl:call-template name="printFootNote"/>
						</xsl:for-each>
					</ol>
				</section>
			</xsl:when>
			<xsl:otherwise>
				<section>
					<xsl:attribute name="role">
						<xsl:text>doc-endnotes</xsl:text>
					</xsl:attribute>
					<ol>
						<xsl:attribute name="class">
							<xsl:text>tei footnotesList</xsl:text>
						</xsl:attribute>
						<xsl:for-each select="//tei:note">
							<xsl:call-template name="printFootNote"/>
						</xsl:for-each>
					</ol>
				</section>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="printFootNote">
		<xsl:if test="contains(@place, 'foot') or contains(@place, 'end') or contains(@id, 'ftn')">
			<li>
				<xsl:attribute name="id">
					<xsl:value-of select="@id"/>
				</xsl:attribute>
				<xsl:attribute name="class">
					<xsl:text>tei footnoteItem</xsl:text>
				</xsl:attribute>
				<a>
					<xsl:attribute name="href">
						<xsl:text>#</xsl:text>
						<xsl:value-of select="@id"/>
					</xsl:attribute>
					<xsl:attribute name="class">
						<xsl:text>tei xreference footnoteReference</xsl:text>
					</xsl:attribute>
					<xsl:attribute name="rel">
						<xsl:text>nofollow</xsl:text>
					</xsl:attribute>
					<xsl:attribute name="role">
						<xsl:text>doc-backlink</xsl:text>
					</xsl:attribute>
					<xsl:value-of select="@n"/>
				</a>
				<span>
					<xsl:attribute name="class">
						<xsl:text>tei footnoteText</xsl:text>
					</xsl:attribute>
					<xsl:apply-templates/>
				</span>
			</li>
		</xsl:if>
	</xsl:template>

	<xsl:template name="placeIcon">
		<xsl:if test="starts-with(@rend, 'place_')">
			<img src="assets/images/icon_link_variant.svg" loading="lazy">
				<xsl:attribute name="class">
					<xsl:text>tei tooltiptrigger ttExplanations</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="alt">
					<xsl:text>förklaring</xsl:text>
				</xsl:attribute>
			</img>
			<span class="tei tooltip">
				<xsl:text>texten fortsätter</xsl:text>
				<xsl:choose>
					<xsl:when test="contains(@rend, 'previousPage')">
						<xsl:text> på föregående sida</xsl:text>
					</xsl:when>
					<xsl:when test="contains(@rend, 'nextPage')">
						<xsl:text> på nästa sida</xsl:text>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="contains(@rend, 'rightMargin')">
						<xsl:text> i högra marginalen</xsl:text>
					</xsl:when>
					<xsl:when test="contains(@rend, 'leftMargin')">
						<xsl:text> i vänstra marginalen</xsl:text>
					</xsl:when>
					<xsl:when test="contains(@rend, 'botMargin')">
						<xsl:text> i nedre marginalen</xsl:text>
					</xsl:when>
					<xsl:when test="contains(@rend, 'topMargin')">
						<xsl:text> i övre marginalen</xsl:text>
					</xsl:when>
					<xsl:when test="contains(@rend, 'other')">
						<xsl:text> på annat/avvikande ställe</xsl:text>
					</xsl:when>
					<xsl:when test="contains(@rend, 'ontopRotatedACW90')">
						<xsl:text>, pappret vänt moturs och ny text skriven ovanpå tidigare text</xsl:text>
					</xsl:when>
					<xsl:when test="contains(@rend, 'ontopRotatedCW90')">
						<xsl:text>, pappret vänt medurs och ny text skriven ovanpå tidigare text</xsl:text>
					</xsl:when>
				</xsl:choose>
			</span>
		</xsl:if>
	</xsl:template>

	<xsl:template match="tei:figure">
		<img class="tei tei_bar" loading="lazy">
			<xsl:attribute name="src">
				<xsl:text>assets/images/figures/</xsl:text>
				<xsl:value-of select="@type"/>
				<xsl:text>.svg</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="alt">
				<xsl:text>horisontaalinen viiva</xsl:text>
			</xsl:attribute>
		</img>
	</xsl:template>

	<xsl:template name="variantMouseOver">
		<xsl:if test="@type">
			<span class="tei teiVariant tooltip ttVariant">
				<xsl:choose>
					<xsl:when test="contains(@type, 'sub') and contains(@type, 'ort') and contains(@type, 'int')">
						<xsl:text>asiamuutos, ortograafinen muutos ja välimerkkimuutos</xsl:text>
					</xsl:when>
					<xsl:when test="contains(@type, 'sub') and contains(@type, 'ort')">
						<xsl:text>asiamuutos ja ortograafinen muutos</xsl:text>
					</xsl:when>
					<xsl:when test="contains(@type, 'sub') and contains(@type, 'int')">
						<xsl:text>asiamuutos ja välimerkkimuutos</xsl:text>
					</xsl:when>
					<xsl:when test="contains(@type, 'ort') and contains(@type, 'int')">
						<xsl:text>ortograafinen muutos ja välimerkkimuutos</xsl:text>
					</xsl:when>
					<xsl:when test="substring(@type, 1, 3) = 'sub'">
						<xsl:text>asiamuutos</xsl:text>
					</xsl:when>
					<xsl:when test="substring(@type, 1, 3) = 'ort'">
						<xsl:text>ortograafinen muutos</xsl:text>
					</xsl:when>
					<xsl:when test="substring(@type, 1, 3) = 'int'">
						<xsl:text>välimerkkimuutos</xsl:text>
					</xsl:when>
					<xsl:when test="substring(@type, 1, 3) = 'ide'">
						<xsl:text>ei muutosta</xsl:text>
					</xsl:when>
					<xsl:when test="substring(@type, 1, 3) = 'err'">
						<xsl:text>ladonta- tai painovirhe jossain versiossa</xsl:text>
					</xsl:when>
					<xsl:when test="substring(@type, 1, 3) = 'typ'">
						<xsl:text>kirjoitusasun muutos</xsl:text>
					</xsl:when>
				</xsl:choose>
			</span>
		</xsl:if>
	</xsl:template>

	<xsl:template name="variantMouseOver_collection">
		<xsl:if test="@type">
			<span class="tei teiVariant tooltip ttVariant">
				<xsl:choose>
					<xsl:when test="substring(@type, 1, 3) = 'sub'">
						<xsl:text>substantiell skillnad</xsl:text>
					</xsl:when>
					<xsl:when test="substring(@type, 1, 3) = 'ort'">
						<xsl:text>ortografisk/stilistisk skillnad</xsl:text>
					</xsl:when>
					<xsl:when test="substring(@type, 1, 3) = 'int'">
						<xsl:text>skillnad i interpunktion</xsl:text>
					</xsl:when>
					<xsl:when test="substring(@type, 1, 3) = 'ide'">
						<xsl:text>identiskt</xsl:text>
					</xsl:when>
					<xsl:when test="substring(@type, 1, 3) = 'err'">
						<xsl:text>sättnings-/tryckfel i endera texten</xsl:text>
					</xsl:when>
					<xsl:when test="substring(@type, 1, 3) = 'typ'">
						<xsl:text>skillnad i typografi</xsl:text>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="substring(@type, 5, 3) = 'sub'">
						<xsl:text>; substantiell skillnad</xsl:text>
					</xsl:when>
					<xsl:when test="substring(@type, 5, 3) = 'ort'">
						<xsl:text>; ortografisk/stilistisk skillnad</xsl:text>
					</xsl:when>
					<xsl:when test="substring(@type, 5, 3) = 'int'">
						<xsl:text>; skillnad i interpunktion</xsl:text>
					</xsl:when>
					<xsl:when test="substring(@type, 5, 3) = 'ide'">
						<xsl:text>; identiskt</xsl:text>
					</xsl:when>
					<xsl:when test="substring(@type, 5, 3) = 'err'">
						<xsl:text>; sättnings-/tryckfel i endera texten</xsl:text>
					</xsl:when>
					<xsl:when test="substring(@type, 5, 3) = 'typ'">
						<xsl:text>; skillnad i typografi</xsl:text>
					</xsl:when>
				</xsl:choose>
			</span>
		</xsl:if>
	</xsl:template>

	<xsl:template match="tei:gap">
		<span>
			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="@reason = 'overstrike' or @reason = 'erased'">
						<xsl:text>tei gap deletion tooltiptrigger ttMs</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>tei gap tooltiptrigger ttMs</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:call-template name="mediumClass"/>
			</xsl:attribute>
			<xsl:text>[oläsligt]</xsl:text>
		</span>
		<span class="tei tooltip">
			<xsl:text>oläsligt</xsl:text>
			<xsl:choose>
				<xsl:when test="@extent and @unit">
					<xsl:text> (</xsl:text>
					<xsl:value-of select="@extent"/>
					<xsl:choose>
						<xsl:when test="@extent = '1'">
							<xsl:choose>
								<xsl:when test="@unit = 'letters'">
									<xsl:text> bokstav</xsl:text>
								</xsl:when>
								<xsl:when test="@unit = 'words'">
									<xsl:text> ord</xsl:text>
								</xsl:when>
								<xsl:when test="@unit = 'lines'">
									<xsl:text> rad</xsl:text>
								</xsl:when>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="@unit = 'letters'">
									<xsl:text> bokstäver</xsl:text>
								</xsl:when>
								<xsl:when test="@unit = 'words'">
									<xsl:text> ord</xsl:text>
								</xsl:when>
								<xsl:when test="@unit = 'lines'">
									<xsl:text> rader</xsl:text>
								</xsl:when>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:text>)</xsl:text>
				</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
			<xsl:call-template name="attReason"/>
			<xsl:if test="@medium">
				<br/>
				<xsl:call-template name="inks">
					<xsl:with-param name="ink" select="@medium"/>
				</xsl:call-template>
			</xsl:if>
		</span>
	</xsl:template>

	<xsl:template name="mediumClass">
		<xsl:if test="@medium">
			<xsl:text> medium tooltiptrigger ttMs</xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template name="mediumTooltip">
		<xsl:param name="hand"/>
		<xsl:param name="medium"/>
		<xsl:if test="@medium">
			<span class="tei tooltip">
				<xsl:call-template name="inks">
					<xsl:with-param name="ink" select="@medium"/>
					<xsl:with-param name="attHand" select="$hand"/>
				</xsl:call-template>
			</span>
		</xsl:if>
	</xsl:template>

	<xsl:template name="attReason">
		<xsl:choose>
			<xsl:when test="@reason = 'faded'">
				<xsl:text>: svagt bläck</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'binding'">
				<xsl:text>: inbindning</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'damage'">
				<xsl:text>: skador</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'endline'">
				<xsl:text>: slutet av raden</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'erased'">
				<xsl:text>: utsuddning</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'glue'">
				<xsl:text>: överlimning eller tejp</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'inksmudge'">
				<xsl:text>: bläckplump eller motsvarande</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'overstrike'">
				<xsl:text>: strykning</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'overwritten'">
				<xsl:text>: överskrivning</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'seal'">
				<xsl:text>: sigill</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'smudge'">
				<xsl:text>: avsvärtning, utflutet bläck</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'stamp'">
				<xsl:text>: frimärke/poststämpel</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'writing'">
				<xsl:text>: handstil</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'ribbon'">
				<xsl:text>: dåligt färgband</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'overtyped'">
				<xsl:text>: strykning (på skrivmaskin)</xsl:text>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="attReasonUnclear">
		<xsl:choose>
			<xsl:when test="@reason = 'writing'">
				<xsl:text>svårtytt</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'endline'">
				<xsl:text>svårläst p.g.a. radslut</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'damage'">
				<xsl:text>svårläst p.g.a. skada</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'inksmudge'">
				<xsl:text>svårläst p.g.a. bläckplump eller motsvarande</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'binding'">
				<xsl:text>svårläst p.g.a. inbindning/konservering</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'overstrike'">
				<xsl:text>svårläst p.g.a. strykning</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'overwritten'">
				<xsl:text>svårläst p.g.a. överskrivning</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'glue'">
				<xsl:text>svårläst p.g.a. överlimning eller tejp</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'faded'">
				<xsl:text>svårläst p.g.a. att bläcket är svagt och avmattat, på väg att ta slut</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'erased'">
				<xsl:text>svårläst p.g.a. utsuddning</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'stamp'">
				<xsl:text>svårläst p.g.a. frimärke</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'seal'">
				<xsl:text>svårläst p.g.a. sigill</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'ribbon'">
				<xsl:text>svårläst p.g.a. dåligt färgband</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'overtyped'">
				<xsl:text>svårläst p.g.a. strykning (på skrivmaskin)</xsl:text>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="attReasonSupplied">
		<xsl:choose>
			<xsl:when test="@reason = 'writing'">
				<xsl:text>oläslig handstil</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'endline'">
				<xsl:text>utanför pappret (radslut)</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'damage'">
				<xsl:text>oläsligt p.g.a. skada</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'inksmudge'">
				<xsl:text>oläsligt p.g.a. bläckplump eller motsvarande</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'bindning'">
				<xsl:text>oläsligt p.g.a. konservering/inbindning</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'binding'">
				<xsl:text>oläsligt p.g.a. konservering/inbindning</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'glue'">
				<xsl:text>oläsligt p.g.a. överlimning eller tejp</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'faded'">
				<xsl:text>oläsligt p.g.a. att bläcket är svagt och avmattat, på väg att ta slut</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'erased'">
				<xsl:text>oläsligt p.g.a. utsuddning</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'stamp'">
				<xsl:text>oläsligt p.g.a. frimärke/poststämpel</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'seal'">
				<xsl:text>oläsligt p.g.a. sigill</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'overwritten'">
				<xsl:text>oläsligt p.g.a. överskrivning</xsl:text>
			</xsl:when>
			<xsl:when test="@reason = 'ribbon'">
				<xsl:text>oläsligt p.g.a. dåligt färgband</xsl:text>
			</xsl:when>
			<xsl:when test="@source">
				<xsl:text>tillagt av utgivaren (källa för ändring: </xsl:text>
				<xsl:value-of select="@source"/>
				<xsl:text>)</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>tillagt av utgivaren</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="xmlLang">
		<span class="tei tooltip ttLang">
			<xsl:text>språk: </xsl:text>
			<xsl:choose>
				<xsl:when test="@xml:lang = 'cel'">
					<xsl:text>keltiska</xsl:text>
				</xsl:when>
				<xsl:when test="@xml:lang = 'dan'">
					<xsl:text>danska</xsl:text>
				</xsl:when>
				<xsl:when test="@xml:lang = 'eng'">
					<xsl:text>engelska</xsl:text>
				</xsl:when>
				<xsl:when test="@xml:lang = 'ang'">
					<xsl:text>fornengelska</xsl:text>
				</xsl:when>
				<xsl:when test="@xml:lang = 'est'">
					<xsl:text>estniska</xsl:text>
				</xsl:when>
				<xsl:when test="@xml:lang = 'fin'">
					<xsl:text>finska</xsl:text>
				</xsl:when>
				<xsl:when test="@xml:lang = 'fre'">
					<xsl:text>franska</xsl:text>
				</xsl:when>
				<xsl:when test="@xml:lang = 'ger'">
					<xsl:text>tyska</xsl:text>
				</xsl:when>
				<xsl:when test="@xml:lang = 'gre'">
					<xsl:text>grekiska</xsl:text>
				</xsl:when>
				<xsl:when test="@xml:lang = 'ita'">
					<xsl:text>italienska</xsl:text>
				</xsl:when>
				<xsl:when test="@xml:lang = 'lap'">
					<xsl:text>samiska</xsl:text>
				</xsl:when>
				<xsl:when test="@xml:lang = 'lat'">
					<xsl:text>latin</xsl:text>
				</xsl:when>
				<xsl:when test="@xml:lang = 'nor'">
					<xsl:text>norska</xsl:text>
				</xsl:when>
				<xsl:when test="@xml:lang = 'oic'">
					<xsl:text>fornisländska</xsl:text>
				</xsl:when>
				<xsl:when test="@xml:lang = 'rus'">
					<xsl:text>ryska</xsl:text>
				</xsl:when>
				<xsl:when test="@xml:lang = 'spa'">
					<xsl:text>spanska</xsl:text>
				</xsl:when>
				<xsl:when test="@xml:lang = 'ara'">
					<xsl:text>arabiska</xsl:text>
				</xsl:when>
				<xsl:when test="@xml:lang = 'heb'">
					<xsl:text>hebreiska</xsl:text>
				</xsl:when>
				<xsl:when test="@xml:lang = 'tib'">
					<xsl:text>tibetanska</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>annat</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</span>
	</xsl:template>

	<xsl:template name="spaceText">
		<xsl:text>[</xsl:text>
		<xsl:call-template name="repeatText">
			<xsl:with-param name="i" select="1"/>
			<xsl:with-param name="count" select="@extent"/>
			<xsl:with-param name="text">
				<xsl:choose>
					<xsl:when test="name() = 'space'">
						<xsl:choose>
							<xsl:when test="@unit = 'letters'">
								<xsl:text>&#160;</xsl:text>
							</xsl:when>
							<xsl:when test="@unit = 'words'">
								<xsl:text>&#160;&#160;&#160;&#160;</xsl:text>
							</xsl:when>
							<xsl:when test="@unit = 'lines'">
								<xsl:text>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</xsl:text>
							</xsl:when>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="@unit = 'letters'">
								<xsl:text>-</xsl:text>
							</xsl:when>
							<xsl:when test="@unit = 'words'">
								<xsl:text>----</xsl:text>
							</xsl:when>
							<xsl:when test="@unit = 'lines'">
								<xsl:text>---- ---- ---- ---- ----</xsl:text>
							</xsl:when>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="spaces">
				<xsl:if test="@unit = 'words' or @unit = 'lines'">
					<xsl:value-of select="1"/>
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:text>]</xsl:text>
	</xsl:template>

	<xsl:template name="pb_text">
		<xsl:choose>
			<xsl:when test="contains(@type, 'unprinted')">
				<xsl:text>[</xsl:text>
				<xsl:value-of select="@n"/>
				<xsl:text>]</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>|</xsl:text>
				<xsl:value-of select="@n"/>
				<xsl:text>|</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="att_pb_class">
		<xsl:attribute name="class">
			<xsl:choose>
				<xsl:when test="contains(@type, 'ZTS')">
					<xsl:text>tei pb_edition</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>tei pb_orig</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>

	<xsl:template name="spaceTooltipText">
		<xsl:text>Tomrum</xsl:text>
	</xsl:template>

	<xsl:template name="inks">
		<xsl:param name="ink"/>
		<xsl:text>med annan penna: </xsl:text>
		<xsl:choose>
			<xsl:when test="$ink = 'black-ink'">
				<xsl:text>svart bläck</xsl:text>
			</xsl:when>
			<xsl:when test="$ink = 'black-inkOther'">
				<xsl:text>annat svart bläck</xsl:text>
			</xsl:when>
			<xsl:when test="$ink = 'blue-ink'">
				<xsl:text>blått bläck</xsl:text>
			</xsl:when>
			<xsl:when test="$ink = 'blue-pencil'">
				<xsl:text>blå färgpenna</xsl:text>
			</xsl:when>
			<xsl:when test="$ink = 'brown-ink'">
				<xsl:text>brunt bläck</xsl:text>
			</xsl:when>
			<xsl:when test="$ink = 'brown-inkOther'">
				<xsl:text>annat brunt bläck</xsl:text>
			</xsl:when>
			<xsl:when test="$ink = 'pencil'">
				<xsl:text>blyerts</xsl:text>
			</xsl:when>
			<xsl:when test="$ink = 'red-ink'">
				<xsl:text>rött bläck</xsl:text>
			</xsl:when>
			<xsl:when test="$ink = 'violet-ink'">
				<xsl:text>violett bläck</xsl:text>
			</xsl:when>
			<xsl:when test="$ink = 'blue-pen'">
				<xsl:text>blå kulspetspenna</xsl:text>
			</xsl:when>
			<xsl:when test="$ink = 'green-ink'">
				<xsl:text>grönt bläck</xsl:text>
			</xsl:when>
			<xsl:when test="$ink = 'green-pencil'">
				<xsl:text>grönt färgpenna</xsl:text>
			</xsl:when>
			<xsl:when test="$ink = 'green-pen'">
				<xsl:text>grön kulspetspenna</xsl:text>
			</xsl:when>
			<xsl:when test="$ink = 'purple-pencil'">
				<xsl:text>violett färgpenna</xsl:text>
			</xsl:when>
			<xsl:when test="$ink = 'purple-pen'">
				<xsl:text>violett kulspetspenna</xsl:text>
			</xsl:when>
			<xsl:when test="$ink = 'red-pencil'">
				<xsl:text>röd färgpenna</xsl:text>
			</xsl:when>
			<xsl:when test="$ink = 'violet-ink'">
				<xsl:text>violett bläck</xsl:text>
			</xsl:when>
			<xsl:when test="$ink = 'typewrite'">
				<xsl:text>maskinskrivet</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="endSpace">
		<p>&#160;</p>
		<p>&#160;</p>
		<p>&#160;</p>
	</xsl:template>

	<xsl:template name="repeatText">
		<xsl:param name="i"/>
		<xsl:param name="count"/>
		<xsl:param name="text"/>
		<xsl:param name="spaces" select="0"/>
		<!-- 0 = no spaces, 1 = with spaces -->
		<xsl:param name="lineBreaks" select="0"/>
		<!-- 0 = no linebreaks, 1 = with linebreaks -->
		<xsl:if test="$i &lt;= $count">
			<xsl:value-of select="$text"/>
			<xsl:if test="$i &lt; $count and $spaces = 1">
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="$i &lt; $count and $lineBreaks = 1">
				<br/>
			</xsl:if>
		</xsl:if>
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="repeatText">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
				<xsl:with-param name="text">
					<xsl:value-of select="$text"/>
				</xsl:with-param>
				<xsl:with-param name="spaces">
					<xsl:value-of select="$spaces"/>
				</xsl:with-param>
				<xsl:with-param name="lineBreaks">
					<xsl:value-of select="$lineBreaks"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="marginAddSymbol">
		<xsl:param name="place"/>
		<xsl:choose>
			<xsl:when test="@place = 'leftMargin' or $place = 'leftMargin'">
				<img src="assets/images/ms_arrow_left.svg" alt="marginaltillägg vänster" loading="lazy"/>
			</xsl:when>
			<xsl:when test="@place = 'rightMargin' or $place = 'rightMargin'">
				<img src="assets/images/ms_arrow_right.svg" alt="marginaltillägg höger" loading="lazy"/>
			</xsl:when>
			<xsl:when test="@place = 'topMargin' or $place = 'topMargin'">
				<img src="assets/images/ms_arrow_up.svg" alt="marginaltillägg uppe" loading="lazy"/>
			</xsl:when>
			<xsl:when test="@place = 'botMargin' or $place = 'botMargin'">
				<img src="assets/images/ms_arrow_down.svg" alt="marginaltillägg nere" loading="lazy"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
