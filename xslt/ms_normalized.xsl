<?xml version="1.0" encoding="utf-8"?>
<!--
This notice must be visible at all times.

Copyright (c) 2010 Mikael Norrgård (See Sharp IT). All rights reserved.
Created 2010 by Mikael Norrgård (Web: http://swww.seesharp.fi )
email: seesharp@witchmastercreations.com or mikael.norrgard@gmail.com

Rights to use and further develop given to Svenska litteratursällskapet i Finland.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0">

	<xsl:include href="inc_ms.xsl"/>

	<xsl:param name="sectionId"/>

	<xsl:template match="tei:teiHeader"/>

	<xsl:template match="tei:body">
		<div class="tei teiManuscript container cont_manuscript">
			<xsl:choose>
				<xsl:when test="string-length($sectionId) &gt; 0">
					<xsl:for-each select="//tei:div[@id = $sectionId]">
						<xsl:apply-templates/>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="listFootnotes">
				<xsl:with-param name="sectionToProcess">
					<xsl:value-of select="$sectionId"/>
				</xsl:with-param>
			</xsl:call-template>
		</div>
	</xsl:template>

	<xsl:template match="tei:div">
		<xsl:if test="@type = 'letterpart' and @part = 'f'">
			<p>&#160;</p>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="$sectionId">
				<div>
					<xsl:if test="@id != $sectionId">
						<xsl:attribute name="class">
							<xsl:text>tei teiManuscript ms_hidden</xsl:text>
						</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates/>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<div>
					<xsl:apply-templates/>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:head">
		<xsl:choose>
			<xsl:when test="preceding-sibling::tei:delSpan">
				<xsl:variable name="delSpanId" select="substring(preceding-sibling::tei:delSpan[1]/@spanTo, 2)"/>
				<xsl:choose>
					<xsl:when test="following-sibling::tei:anchor[@id = $delSpanId]"/>
					<xsl:otherwise>
						<xsl:call-template name="tei_head"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="tei_head"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:trailer">
		<p>
			<xsl:call-template name="attRend"> </xsl:call-template>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template name="tei_head">
		<xsl:choose>
			<xsl:when test="@type = 'letter'">
				<p class="tei teiManuscript noIndent topMargin bottomMargin">
					<xsl:apply-templates/>
				</p>
			</xsl:when>
			<xsl:when test="@rend = 'underline'">
				<h3>
					<xsl:attribute name="class">
						<xsl:call-template name="attRend"/>
						<xsl:text>tei teiManuscript ms underline</xsl:text>
					</xsl:attribute>
					<xsl:apply-templates/>
				</h3>
			</xsl:when>
			<xsl:when test="@type = 'sub' or @type = 'sub2' or @type = 'scene'">
				<h4>
					<xsl:call-template name="attRend"/>
					<xsl:attribute name="class">
						<xsl:text>tei teiManuscript mssub </xsl:text>
					</xsl:attribute>
					<xsl:apply-templates/>
				</h4>
			</xsl:when>
			<xsl:otherwise>
				<h3>
					<xsl:call-template name="attRend"/>
					<xsl:attribute name="class">
						<xsl:text>tei teiManuscript ms </xsl:text>
					</xsl:attribute>
					<xsl:apply-templates/>
				</h3>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:lg">
		<xsl:choose>
			<xsl:when test="preceding-sibling::tei:delSpan">
				<xsl:variable name="delSpanId" select="substring(preceding-sibling::tei:delSpan[1]/@spanTo, 2)"/>
				<xsl:choose>
					<xsl:when test="following-sibling::tei:anchor[@id = $delSpanId]"/>
					<xsl:otherwise>
						<xsl:call-template name="tei_lg"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="tei_lg"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="tei_lg">
		<p>
			<xsl:attribute name="class">
				<xsl:text>tei teiManuscript strofe</xsl:text>
				<xsl:if test="@xml:id">
					<xsl:text> </xsl:text>
					<xsl:value-of select="@xml:id"/>
				</xsl:if>
			</xsl:attribute>
			<xsl:call-template name="switchPosNumber"/>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="tei:l">
		<xsl:choose>
			<xsl:when test="preceding-sibling::tei:delSpan">
				<xsl:variable name="delSpanId" select="substring(preceding-sibling::tei:delSpan[1]/@spanTo, 2)"/>
				<xsl:choose>
					<xsl:when test="following-sibling::tei:anchor[@id = $delSpanId]"/>
					<xsl:otherwise>
						<xsl:call-template name="tei_l"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="tei_l"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="tei_l">
		<xsl:call-template name="switchPosNumber"/>
		<xsl:apply-templates/>
		<br/>
	</xsl:template>

	<xsl:template match="tei:milestone">
		<xsl:choose>
			<xsl:when test="preceding::tei:delSpan">
				<xsl:variable name="delSpanId1" select="substring(preceding::tei:delSpan[1]/@spanTo, 2)"/>
				<xsl:variable name="delSpanId2" select="substring(preceding::tei:delSpan[2]/@spanTo, 2)"/>
				<xsl:choose>
					<xsl:when test="following::tei:anchor[@id = $delSpanId1]"/>
					<xsl:when test="following::tei:anchor[@id = $delSpanId2]"/>
					<xsl:otherwise>
						<xsl:if test="@type = 'bar'">
							<hr class="tei teiManuscript milestoneBar"/>
						</xsl:if>
						<xsl:if test="@type = 'smallBar'">
							<hr class="tei teiManuscript milestoneSmallBar"/>
						</xsl:if>
						<xsl:if test="@unit = 'part'">
							<p class="tei teiManuscript milestonePart">
								<xsl:text>&#160;</xsl:text>
							</p>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="@type = 'bar'">
					<hr class="tei teiManuscript milestoneBar"/>
				</xsl:if>
				<xsl:if test="@type = 'smallBar'">
					<hr class="tei teiManuscript milestoneSmallBar"/>
				</xsl:if>
				<xsl:if test="@unit = 'part'">
					<p class="tei teiManuscript milestonePart">
						<xsl:text>&#160;</xsl:text>
					</p>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:p">
		<xsl:variable name="paragraphNumber">
			<xsl:number count="tei:p | tei:lg"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="preceding-sibling::tei:delSpan">
				<xsl:variable name="delSpanId" select="substring(preceding-sibling::tei:delSpan[1]/@spanTo, 2)"/>
				<xsl:choose>
					<xsl:when test="following-sibling::tei:anchor[@id = $delSpanId]"/>
					<xsl:otherwise>
						<xsl:call-template name="tei_p">
							<xsl:with-param name="paragraphNumber" select="$paragraphNumber"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="tei_p">
					<xsl:with-param name="paragraphNumber" select="$paragraphNumber"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="tei_p">
		<xsl:param name="paragraphNumber"/>
		<p>
			<xsl:choose>
				<xsl:when test="($paragraphNumber = '1' and ($bookId = '30' or $bookId = '31')) or parent::tei:postscript">
					<xsl:call-template name="attRend">
						<xsl:with-param name="defaultClasses">
							<xsl:text>noIndent</xsl:text>
							<xsl:if test="@xml:id">
								<xsl:text> </xsl:text>
								<xsl:value-of select="@xml:id"/>
							</xsl:if>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="@rend">
					<xsl:call-template name="attRend">
						<xsl:with-param name="defaultClasses">
							<xsl:if test="@xml:id">
								<xsl:value-of select="@xml:id"/>
							</xsl:if>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="@xml:id">
					<xsl:attribute name="class">
						<xsl:text>tei teiManuscript </xsl:text>
						<xsl:value-of select="@xml:id"/>
					</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<xsl:call-template name="switchPosNumber"/>
			<xsl:call-template name="placeIcon"/>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="tei:choice">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:expan"/>

	<xsl:template match="tei:abbr">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:unclear">
		<xsl:if test="@reason != 'overstrike' and @reason != 'erased'">
			<span class="tei teiManuscript unclear tooltiptrigger ttMs">
				<xsl:apply-templates/>
			</span>
			<span class="tei teiManuscript tooltip">
				<!--<xsl:text>Svårläst</xsl:text>-->
				<xsl:call-template name="attReasonUnclear"/>
			</span>
		</xsl:if>
	</xsl:template>

	<xsl:template match="tei:gap">
		<xsl:if test="@reason != 'overstrike'">
			<span>
				<xsl:attribute name="class">
					<xsl:text>tei teiManuscript </xsl:text>
					<xsl:choose>
						<xsl:when test="@reason = 'erased'">
							<xsl:text>gap deletion tooltiptrigger ttMs</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>gap tooltiptrigger ttMs</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:call-template name="mediumClass"/>
				</xsl:attribute>
				<xsl:text>[oläsligt]</xsl:text>
			</span>
			<span class="tei teiManuscript tooltip">
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
		</xsl:if>
	</xsl:template>

	<xsl:template match="tei:space">
		<span class="tei teiManuscript space tooltiptrigger ttMs">
			<xsl:call-template name="spaceText"/>
		</span>
		<span class="tei teiManuscript tooltip">
			<xsl:call-template name="spaceTooltipText"/>
		</span>
	</xsl:template>

	<xsl:template match="tei:seg">
		<xsl:choose>
			<xsl:when test="@type = 'alt'">
				<xsl:apply-templates select="tei:add[@reason = 'choice']"/>
			</xsl:when>
			<xsl:otherwise>
				<span>
					<xsl:attribute name="class">
						<xsl:text>tei teiManuscript segment</xsl:text>
					</xsl:attribute>
					<xsl:call-template name="placeIcon"/>
					<xsl:apply-templates/>
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:subst">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:add">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:addSpan"/>

	<xsl:template match="tei:anchor"/>

	<xsl:template match="tei:del">
		<xsl:choose>
			<xsl:when test="ancestor::tei:restore">
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:delSpan"/>

	<xsl:template match="tei:restore">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:switchPos">
		<xsl:choose>
			<xsl:when test="child::tei:lg">
				<xsl:for-each select="child::tei:lg">
					<xsl:sort select="@n" data-type="number"/>
					<p class="tei teiManuscript strofe">
						<xsl:apply-templates/>
					</p>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="child::tei:l">
				<xsl:for-each select="child::tei:l">
					<xsl:sort select="@n" data-type="number"/>
					<xsl:choose>
						<xsl:when test="preceding-sibling::tei:delSpan">
							<xsl:variable name="delSpanId" select="substring(preceding-sibling::tei:delSpan[1]/@spanTo, 2)"/>
							<xsl:choose>
								<xsl:when test="following-sibling::tei:anchor[@id = $delSpanId]"/>
								<xsl:otherwise>
									<xsl:apply-templates/>
									<br/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates/>
							<br/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="child::tei:item">
				<xsl:variable name="countItems" select="count(child::tei:item)"/>
				<xsl:for-each select="child::tei:item">
					<xsl:sort select="@n" data-type="number"/>
					<xsl:apply-templates/>
					<xsl:if test="position() != $countItems">
						<xsl:text> </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:item">
		<xsl:choose>
			<xsl:when test="ancestor::tei:switchPos">
				<xsl:call-template name="switchPosNumber"/>
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:when test="ancestor::tei:p">
				<xsl:if test="not(preceding-sibling::tei:item)">
					<br/>
				</xsl:if>
				<xsl:apply-templates/>
				<br/>
			</xsl:when>
			<xsl:otherwise>
				<p class="tei teiManuscript item">
					<xsl:apply-templates/>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="switchPosNumber">
		<xsl:if test="@n and parent::tei:switchPos">
			<span>
				<xsl:attribute name="class">
					<xsl:text>tei teiManuscript </xsl:text>
					<xsl:choose>
						<xsl:when test="parent::tei:switchPos[@type = 'unnumbered']">
							<xsl:text>switchpos_nonumber</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>switchpos_nonumber</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:value-of select="@n"/>
			</span>
		</xsl:if>
	</xsl:template>

	<xsl:template match="tei:emph">
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

	<xsl:template match="tei:choice">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:orig">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:reg">
		<xsl:choose>
			<xsl:when test="parent::tei:choice"/>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="printStrings">
		<xsl:param name="i"/>
		<xsl:param name="count"/>
		<xsl:param name="toPrint"/>
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			<xsl:value-of select="$toPrint"/>
		</xsl:if>
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="printStrings">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
				<xsl:with-param name="toPrint">
					<xsl:value-of select="$toPrint"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="tei:figure">
		<xsl:choose>
			<xsl:when test="@type = 'pictogram' and child::tei:figDesc">
				<img class="tei teiManuscript doodle" src="assets/images/symbol_illustration.svg" alt="illustration" loading="lazy"/>
			</xsl:when>
			<xsl:when test="@type = 'pictogram' and not(child::tei:figDesc)">
				<img class="tei teiManuscript doodle" src="assets/images/symbol_illustration.svg" alt="illustration" loading="lazy"/>
			</xsl:when>
			<xsl:when test="$bookId = '29' and @type = 'illustration'">
				<img class="tei teiManuscript symbol" src="assets/images/image_symbol.svg" alt="illustration" loading="lazy"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:pb">
		<span>
			<xsl:call-template name="att_pb_class"/>
			<xsl:call-template name="pb_text"/>
		</span>
	</xsl:template>

	<xsl:template match="tei:supplied">
		<xsl:choose>
			<xsl:when test="not(@reason)"/>
			<xsl:otherwise>
				<xsl:text>[</xsl:text>
				<xsl:apply-templates/>
				<xsl:text>]</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
