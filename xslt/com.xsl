<?xml version="1.0" encoding="utf-8"?>
<!--
This notice must be visible at all times.

Copyright (c) 2010 Mikael Norrgård (See Sharp IT). All rights reserved.
Created 2010 by Mikael Norrgård (Web: http://seesharp.witchmastercreations.com )
email: seesharp@witchmastercreations.com or mikael.norrgard@gmail.com

Rights to use and further develop given to Svenska litteratursällskapet i Finland.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0">

	<xsl:include href="inc_common.xsl"/>

	<xsl:param name="estDocument"/>
	<xsl:param name="sectionId"/>
	<xsl:param name="commentTitle"/>
	<xsl:param name="fileDiv"/>

	<xsl:template match="tei:teiHeader"/>

	<xsl:template match="tei:body">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template name="listEditorNotes">

		<xsl:choose>
			<xsl:when test="string-length($sectionId) &gt; 0">
				<xsl:call-template name="printEditorNoteHeader">
					<xsl:with-param name="noteCount" select="count(document($estDocument)//tei:div[@id = $sectionId]//tei:anchor[contains(@xml:id, 'start')])"/>
				</xsl:call-template>
				<xsl:variable name="sourceRoot" select="//tei:text/tei:body"/>
				<xsl:for-each select="document($estDocument)//tei:div[@id = $sectionId]//tei:anchor[contains(@xml:id, 'start') and not(ancestor::tei:note/@place)]">
					<xsl:variable name="noteId" select="concat('en', substring(@xml:id, 6))"/>
					<xsl:for-each select="$sourceRoot//tei:note[@id = $noteId]">
						<xsl:call-template name="printEditorNote"/>
					</xsl:for-each>
				</xsl:for-each>
				<xsl:for-each select="document($estDocument)//tei:div[@id = $sectionId]//tei:anchor[contains(@xml:id, 'start') and ancestor::tei:note/@place]">
					<xsl:variable name="noteId" select="concat('en', substring(@xml:id, 6))"/>
					<xsl:for-each select="$sourceRoot//tei:note[@id = $noteId]">
						<xsl:call-template name="printEditorNote"/>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="printEditorNoteHeader">
					<xsl:with-param name="noteCount" select="count(document($estDocument)//tei:body//tei:anchor[contains(@xml:id, 'start')])"/>
				</xsl:call-template>
				<xsl:variable name="sourceRoot" select="//tei:text/tei:body"/>
				<xsl:for-each select="document($estDocument)//tei:anchor[contains(@xml:id, 'start') and not(ancestor::tei:note/@place)]">
					<xsl:variable name="noteId" select="concat('en', substring(@xml:id, 6))"/>
					<xsl:for-each select="$sourceRoot//tei:note[@id = $noteId]">
						<xsl:call-template name="printEditorNote"/>
					</xsl:for-each>
				</xsl:for-each>
				<xsl:for-each select="document($estDocument)//tei:anchor[contains(@xml:id, 'start') and ancestor::tei:note/@place]">
					<xsl:variable name="noteId" select="concat('en', substring(@xml:id, 6))"/>
					<xsl:for-each select="$sourceRoot//tei:note[@id = $noteId]">
						<xsl:call-template name="printEditorNote"/>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="printEditorNoteHeader">
		<xsl:param name="noteCount"/>
		<p class="teiComment noteLegend"><i>sijainti&#160;–&#160;tekstikohta – kommentti</i></p>
	</xsl:template>

	<xsl:template name="printEditorNote">
		<p>
			<xsl:attribute name="class">
				<xsl:text>teiComment note paragraphSpace commentScrollTarget </xsl:text>
				<xsl:value-of select="@id"/>
			</xsl:attribute>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="tei:seg">
		<xsl:if test="not(@type = 'noteSection')">
			<span>
				<xsl:variable name="notePosition">
					<xsl:choose>
						<xsl:when test="@type = 'notePosition'">
							<xsl:call-template name="printNotePosition">
								<xsl:with-param name="notePos" select="."/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise/>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="@type">
					<xsl:attribute name="class">
						<xsl:text>teiComment </xsl:text>
						<xsl:value-of select="@type"/>
						<xsl:if test="string-length($notePosition) &gt; 0">
							<xsl:text> pk</xsl:text>
							<xsl:choose>
								<xsl:when test="contains($notePosition, 'Fotnot') or contains($notePosition, 'Rubrik') or contains($notePosition, 'Titel') or contains($notePosition, 'Datering')">
									<xsl:value-of select="$notePosition"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="translate(translate(translate(translate(translate($notePosition, 'list', ''), 'li', ''), 'lg', ''), 'p', ''), 'g', '')"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</xsl:attribute>
				</xsl:if>
				<xsl:choose>
					<!-- Positions for notes to paragraphs in poems should not be printed since their numbering is separate from poem lines -->
					<xsl:when test="@type = 'notePosition' and document($estDocument)//tei:div[@type = 'poem'] and starts-with($notePosition, 'p')">
						<xsl:text>&#x2b25; </xsl:text>
					</xsl:when>
					<xsl:when test="@type = 'notePosition' and contains($notePosition, '–')">
						<xsl:choose>	
							<xsl:when test="starts-with($notePosition, 'Viite') or starts-with($notePosition, 'Otsikko') or starts-with($notePosition, 'Päiväys')">
								<!-- Remove unwanted characters only from latter part of position -->
								<xsl:variable name="sTo" select="substring-after($notePosition, '–')"/>
								<xsl:variable name="sFrom" select="substring-before($notePosition, '–')"/>
								<xsl:value-of select="$sFrom"/>
								<xsl:text>–</xsl:text>
								<xsl:value-of select="translate($sTo, 'abcdefghijklmnopqrstuvwxyz', '')"/>
								<xsl:text> </xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="translate($notePosition, 'abcdefghijklmnopqrstuvwxyz', '')"/>
								<xsl:text> </xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="@type = 'notePosition'">
						<xsl:choose>
							<xsl:when test="contains($notePosition, 'Viite') or contains($notePosition, 'Otsikko') or contains($notePosition, 'Päiväys')">
								<xsl:value-of select="$notePosition"/>
								<xsl:text> </xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="translate($notePosition, 'abcdefghijklmnopqrstuvwxyz', '')"/>
								<xsl:text> </xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates/>
					</xsl:otherwise>
				</xsl:choose>
			</span>
		</xsl:if>
	</xsl:template>

	<xsl:template name="replace">
		<xsl:param name="text"/>
		<xsl:param name="replace"/>
		<xsl:param name="by"/>
		<xsl:choose>
			<xsl:when test="contains($text, $replace)">
				<xsl:value-of select="substring-before($text, $replace)"/>
				<xsl:value-of select="$by"/>
				<xsl:call-template name="replace">
					<xsl:with-param name="text" select="substring-after($text, $replace)"/>
					<xsl:with-param name="replace" select="$replace"/>
					<xsl:with-param name="by" select="$by"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="printNotePosition">
		<xsl:param name="notePos"/>
		<xsl:variable name="sTo" select="substring-after($notePos, '-')"/>
		<xsl:choose>
			<xsl:when test="$sTo != ''">
				<xsl:variable name="sFrom" select="substring-before($notePos, '-')"/>
				<xsl:variable name="sP1" select="substring-after($sFrom, '_')"/>
				<xsl:variable name="sP2" select="substring-after($sTo, '_')"/>
				<xsl:choose>
					<xsl:when test="$sP1 != ''">
						<xsl:value-of select="$sP1"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$notePos = 'Datering' or $notePos = 'Fotnot' or $notePos = 'Titel' or $notePos = 'Rubrik'">
								<xsl:choose>
									<xsl:when test="$notePos = 'Datering'">
										<xsl:value-of select="'Päiväys'"/>
									</xsl:when>
									<xsl:when test="$notePos = 'Fotnot'">
										<xsl:value-of select="'Viite'"/>
									</xsl:when>
									<xsl:when test="$notePos = 'Titel'">
										<xsl:value-of select="'Otsikko'"/>
									</xsl:when>
									<xsl:when test="$notePos = 'Rubrik'">
										<xsl:value-of select="'Otsikko'"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$sFrom"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="contains($sFrom, 'lg') or contains($sFrom, 'li')">
								<xsl:value-of select="$sFrom"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$sFrom"/>
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
						<xsl:value-of select="$sTo"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$sTo"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="sP" select="substring-after($notePos, '_')"/>
				<xsl:choose>
					<xsl:when test="$sP != ''">
						<xsl:value-of select="$sP"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$notePos = 'Datering' or $notePos = 'Fotnot' or $notePos = 'Titel' or $notePos = 'Rubrik'">
								<xsl:choose>
									<xsl:when test="$notePos = 'Datering'">
										<xsl:value-of select="'Päiväys'"/>
									</xsl:when>
									<xsl:when test="$notePos = 'Fotnot'">
										<xsl:value-of select="'Viite'"/>
									</xsl:when>
									<xsl:when test="$notePos = 'Titel'">
										<xsl:value-of select="'Otsikko'"/>
									</xsl:when>
									<xsl:when test="$notePos = 'Rubrik'">
										<xsl:value-of select="'Otsikko'"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$notePos"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="contains($notePos, 'lg') or contains($notePos, 'li')">
								<xsl:value-of select="$notePos"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$notePos"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:head">
		<xsl:choose>
			<xsl:when test="@type = 'main'">
				<h3>
					<xsl:call-template name="attRend">
						<xsl:with-param name="defaultClasses">mainHeader</xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates/>
				</h3>
			</xsl:when>
			<xsl:when test="@type = 'author'">
				<p>
					<xsl:call-template name="attRend">
						<xsl:with-param name="defaultClasses">authorHeader</xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates/>
				</p>
			</xsl:when>
			<xsl:when test="@type = 'sub'">
				<h4>
					<xsl:call-template name="attRend"/>
					<xsl:apply-templates/>
				</h4>
			</xsl:when>
			<xsl:when test="@type = 'illustration'">
				<p class="teiComment noIndent halfLinePadding bold">
					<xsl:apply-templates/>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<h3>
					<xsl:call-template name="attRend"/>
					<xsl:apply-templates/>
				</h3>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:opener">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:div">
		<xsl:choose>
			<xsl:when test="@type = 'comment'">
				<xsl:choose>
                    <!-- $commentTitle is not implemented on the generic digital edition platform and will thus always be an empty string -->
					<xsl:when test="$commentTitle != ''">
						<xsl:choose>
							<xsl:when test="($bookId = '30' or $bookId = '31') or ($fileDiv = '2' and $sectionId != 'ch1')">
								<xsl:variable name="noteCount">
									<xsl:choose>
										<xsl:when test="$fileDiv = '2'">
											<xsl:value-of select="count(document($estDocument)//tei:div[@id = $sectionId]//tei:anchor[contains(@xml:id, 'start')])"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="count(document($estDocument)//tei:anchor[contains(@xml:id, 'start')])"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<h3 class="teiComment smallCaps">
									<xsl:text>Kommentarer till </xsl:text>
									<xsl:value-of select="$commentTitle"/>
								</h3>
								<xsl:if test="not($fileDiv = '2' and $sectionId != 'ch1')">
									<xsl:apply-templates/>
								</xsl:if>
								<xsl:if test="$noteCount = 0">
									<p class="teiComment noIndent">
										<xsl:choose>
											<xsl:when test="$bookId = '30' or $bookId = '31'">
												<xsl:text>Det finns inga kommentarer till detta brev.</xsl:text>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>Det finns inga kommentarer till detta kapitel.</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</p>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<h3 class="teiComment smallCaps">
									<xsl:text>Kommentar till </xsl:text>
									<xsl:value-of select="$commentTitle"/>
								</h3>
								<xsl:if test="not($fileDiv = '2' and $sectionId != 'ch1')">
									<xsl:apply-templates/>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$bookId = '23'">
								<p class="teiComment noIndent">
									<xsl:text>Det finns inga kommentarer till de enskilda artiklarna och artikelserierna i delutgåvan.</xsl:text>
								</p>
							</xsl:when>
                            <xsl:when test="string-length(normalize-space(//tei:div[@type = 'comment'])) = 0 and string-length(normalize-space(//tei:div[@type = 'notes'])) = 0 and string-length(normalize-space(//tei:div[@type = 'bibl'])) = 0">
                                <p class="teiComment noIndent">
                                    <xsl:text>Inga kommentarer.</xsl:text>
                                </p>
                            </xsl:when>
                            <xsl:otherwise>
                                <h3 class="teiComment smallCaps">
                                    <xsl:text>Kommentar</xsl:text>
                                </h3>
                                <xsl:if test="not($fileDiv = '2' and $sectionId != 'ch1')">
                                    <xsl:apply-templates/>
                                </xsl:if>
                            </xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@type = 'bibl'">
				<xsl:if test="not($fileDiv = '2' and $sectionId != 'ch1')">
					<h4 class="teiComment italics">Bibliografi</h4>
					<xsl:apply-templates/>
				</xsl:if>
			</xsl:when>
			<xsl:when test="@type = 'background' or @rend = 'background'">
				<xsl:choose>
					<xsl:when test="ancestor::tei:note">
						<br/>
						<span class="teiComment comment_background">
							<xsl:apply-templates/>
						</span>
					</xsl:when>
					<xsl:otherwise>
						<div class="teiComment comment_background">
							<xsl:apply-templates/>
						</div>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@type = 'notes'">
				<xsl:call-template name="listEditorNotes"/>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:lg">
		<xsl:choose>
			<xsl:when test="ancestor::tei:note[@type = 'editor']">
				<br/>
				<xsl:apply-templates/>
				<br/>
			</xsl:when>
			<xsl:otherwise>
				<p>
					<xsl:attribute name="class">
						<xsl:text>teiComment strofe </xsl:text>
						<xsl:value-of select="@xml:id"/>
					</xsl:attribute>
					<xsl:apply-templates/>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:l">
		<xsl:apply-templates/>
		<br/>
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
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:otherwise>
				<p>
					<xsl:attribute name="class">
						<xsl:text>teiComment </xsl:text>
						<xsl:value-of select="@xml:id"/>
						<xsl:if test="parent::tei:postscript or @rend = 'noIndent' or @n = '1'">
							<xsl:text> noIndent</xsl:text>
						</xsl:if>
						<xsl:if test="@rend = 'parIndent'">
							<xsl:text> parIndent</xsl:text>
						</xsl:if>
					</xsl:attribute>
					<xsl:choose>
						<xsl:when test="@rend = 'italics'">
							<i>
								<xsl:apply-templates/>
							</i>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates/>
						</xsl:otherwise>
					</xsl:choose>
				</p>
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
			<xsl:when test="@rend = 'raised'">
				<span style="vertical-align: 20%;">
					<xsl:apply-templates/>
				</span>
			</xsl:when>
			<xsl:when test="@rend = 'underline italics'">
				<span>
					<xsl:attribute name="class">
						<xsl:text>teiComment true-underline italics</xsl:text>
					</xsl:attribute>
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
		<table>
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
				<xsl:when test="@role = 'label'">
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

	<xsl:template match="tei:del">
		<span>
			<xsl:attribute name="class">
				<xsl:text>teiComment deletion</xsl:text>
			</xsl:attribute>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

</xsl:stylesheet>
