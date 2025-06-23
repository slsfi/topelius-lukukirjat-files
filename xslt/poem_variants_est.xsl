<?xml version="1.0" encoding="utf-8"?>
<!--
This notice must be visible at all times.

Copyright (c) 2010 Mikael Norrgård (See Sharp IT). All rights reserved.
Created 2010 by Mikael Norrgård (Web: http://seesharp.witchmastercreations.com )
email: seesharp@witchmastercreations.com or mikael.norrgard@gmail.com

Rights to use and further develop given to Svenska litteratursällskapet i Finland.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:ns0="http://tei-c.org/TextComparator">

	<xsl:include href="inc_common.xsl"/>

	<xsl:param name="sectionId"/>

	<xsl:strip-space elements="tei:choice"/>

	<xsl:template match="tei:teiHeader"/>

	<xsl:template match="tei:body">
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
		<xsl:call-template name="endSpace"/>
	</xsl:template>

	<xsl:template match="tei:head">
		<xsl:choose>
			<xsl:when test="@type = 'letter'">
				<p>
					<xsl:attribute name="class">
						<xsl:text>tei teiVariant noIndent topMargin bottomMargin </xsl:text>
					</xsl:attribute>
					<xsl:apply-templates/>
				</p>
			</xsl:when>
			<xsl:when test="@type = 'title'">
				<xsl:choose>
					<xsl:when test="parent::tei:div[@type = 'poem'] and not(@subtype)">
						<h1>
							<xsl:attribute name="class">
								<xsl:text>tei teiVariant poemtitle </xsl:text>
								<xsl:if test="@style = 'blackletter'">
									<xsl:text>blackletter</xsl:text>
								</xsl:if>
							</xsl:attribute>
							<xsl:apply-templates/>
						</h1>
					</xsl:when>
					<xsl:when test="parent::tei:div[@type = 'poem'] and @subtype = 'fromMs'">
						<h1>
							<xsl:attribute name="class">
								<xsl:text>tei teiVariant poemtitleFromMs </xsl:text>
							</xsl:attribute>
							<xsl:apply-templates/>
						</h1>
					</xsl:when>
					<xsl:when test="parent::tei:div[@type = 'poem'] and @subtype = 'suite'">
						<h1>
							<xsl:attribute name="class">
								<xsl:text>tei teiVariant poemtitleSuite </xsl:text>
							</xsl:attribute>
							<xsl:apply-templates/>
						</h1>
					</xsl:when>
					<xsl:otherwise>
						<h1>
							<xsl:attribute name="class">
								<xsl:text>tei teiVariant title </xsl:text>
								<xsl:if test="@style = 'blackletter'">
									<xsl:text>blackletter</xsl:text>
								</xsl:if>
							</xsl:attribute>
							<xsl:apply-templates/>
						</h1>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@type = 'section'">
				<xsl:choose>
					<xsl:when test="parent::tei:div[@type = 'poem']">
						<h2>
							<xsl:attribute name="class">
								<xsl:text>tei teiVariant poemsection </xsl:text>
								<xsl:if test="@style = 'blackletter'">
									<xsl:text>blackletter</xsl:text>
								</xsl:if>
							</xsl:attribute>
							<xsl:apply-templates/>
						</h2>
					</xsl:when>
					<xsl:otherwise>
						<h2>
							<xsl:attribute name="class">
								<xsl:text>tei teiVariant section </xsl:text>
								<xsl:if test="@style = 'blackletter'">
									<xsl:text>blackletter</xsl:text>
								</xsl:if>
							</xsl:attribute>
							<xsl:apply-templates/>
						</h2>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@type = 'section2'">
				<xsl:choose>
					<xsl:when test="parent::tei:div[@type = 'poem'] and not(@subtype)">
						<h2>
							<xsl:attribute name="class">
								<xsl:text>tei teiVariant poemsection2 </xsl:text>
								<xsl:if test="@style = 'blackletter'">
									<xsl:text>blackletter</xsl:text>
								</xsl:if>
							</xsl:attribute>
							<xsl:apply-templates/>
						</h2>
					</xsl:when>
					<xsl:when test="parent::tei:div[@type = 'poem'] and @subtype = 'suite'">
						<h1>
							<xsl:attribute name="class">
								<xsl:text>tei teiVariant poemtitle </xsl:text>
							</xsl:attribute>
							<xsl:apply-templates/>
						</h1>
					</xsl:when>
					<xsl:otherwise>
						<h2>
							<xsl:attribute name="class">
								<xsl:text>tei teiVariant section2 </xsl:text>
								<xsl:if test="@style = 'blackletter'">
									<xsl:text>blackletter</xsl:text>
								</xsl:if>
							</xsl:attribute>
							<xsl:apply-templates/>
						</h2>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@type = 'sub'">
				<xsl:choose>
					<xsl:when test="parent::tei:div[@type = 'poem'] and $bookId = '29'">
						<h4>
							<xsl:attribute name="class">
								<xsl:text>tei teiVariant poemsubdiary </xsl:text>
								<xsl:if test="@style = 'blackletter'">
									<xsl:text>blackletter</xsl:text>
								</xsl:if>
							</xsl:attribute>
							<xsl:apply-templates/>
						</h4>
					</xsl:when>
					<xsl:when test="parent::tei:div[@type = 'poem'] and not($bookId = '29')">
						<h4>
							<xsl:attribute name="class">
								<xsl:text>tei teiVariant poemsub </xsl:text>
								<xsl:if test="@style = 'blackletter'">
									<xsl:text>blackletter</xsl:text>
								</xsl:if>
							</xsl:attribute>
							<xsl:apply-templates/>
						</h4>
					</xsl:when>
					<xsl:otherwise>
						<h4>
							<xsl:attribute name="class">
								<xsl:text>tei teiVariant sub </xsl:text>
								<xsl:if test="@style = 'blackletter'">
									<xsl:text>blackletter</xsl:text>
								</xsl:if>
							</xsl:attribute>
							<xsl:apply-templates/>
						</h4>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@type = 'sub2' or @type = 'incorp'">
				<xsl:choose>
					<xsl:when test="parent::tei:div[@type = 'poem'] or @type = 'incorp'">
						<h5>
							<xsl:attribute name="class">
								<xsl:text>tei teiVariant poemsub2 </xsl:text>
								<xsl:if test="@style = 'blackletter'">
									<xsl:text>blackletter</xsl:text>
								</xsl:if>
							</xsl:attribute>
							<xsl:apply-templates/>
						</h5>
					</xsl:when>
					<xsl:otherwise>
						<h5>
							<xsl:attribute name="class">
								<xsl:text>tei teiVariant sub2est </xsl:text>
								<xsl:if test="@style = 'blackletter'">
									<xsl:text>blackletter</xsl:text>
								</xsl:if>
							</xsl:attribute>
							<xsl:apply-templates/>
						</h5>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@type = 'motto' or @type = 'incorp motto'">
				<xsl:choose>
					<xsl:when test="parent::tei:div[@type = 'poem'] or @type = 'incorp motto'">
						<h5>
							<xsl:attribute name="class">
								<xsl:text>tei teiVariant poemmotto </xsl:text>
								<xsl:if test="@style = 'blackletter'">
									<xsl:text>blackletter</xsl:text>
								</xsl:if>
							</xsl:attribute>
							<xsl:apply-templates/>
						</h5>
					</xsl:when>
					<xsl:otherwise>
						<h5>
							<xsl:attribute name="class">
								<xsl:text>tei teiVariant motto </xsl:text>
								<xsl:if test="@style = 'blackletter'">
									<xsl:text>blackletter</xsl:text>
								</xsl:if>
							</xsl:attribute>
							<xsl:apply-templates/>
						</h5>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@type = 'motto2'">
				<xsl:choose>
					<xsl:when test="parent::tei:div[@type = 'poem']">
						<h6>
							<xsl:attribute name="class">
								<xsl:text>tei teiVariant poemmotto2 </xsl:text>
								<xsl:if test="@style = 'blackletter'">
									<xsl:text>blackletter</xsl:text>
								</xsl:if>
							</xsl:attribute>
							<xsl:apply-templates/>
						</h6>
					</xsl:when>
					<xsl:otherwise>
						<h6>
							<xsl:attribute name="class">
								<xsl:text>tei teiVariant motto2 </xsl:text>
								<xsl:if test="@style = 'blackletter'">
									<xsl:text>blackletter</xsl:text>
								</xsl:if>
							</xsl:attribute>
							<xsl:apply-templates/>
						</h6>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@type = 'sub3'">
				<xsl:choose>
					<xsl:when test="parent::tei:div[@type = 'poem']">
						<h6>
							<xsl:attribute name="class">
								<xsl:text>tei teiVariant sub3 </xsl:text>
								<xsl:if test="@style = 'blackletter'">
									<xsl:text>blackletter</xsl:text>
								</xsl:if>
							</xsl:attribute>
							<xsl:apply-templates/>
						</h6>
					</xsl:when>
					<xsl:otherwise>
						<h6>
							<xsl:attribute name="class">
								<xsl:text>tei teiVariant sub3 </xsl:text>
								<xsl:if test="@style = 'blackletter'">
									<xsl:text>blackletter</xsl:text>
								</xsl:if>
							</xsl:attribute>
							<xsl:apply-templates/>
						</h6>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="parent::tei:div[@type = 'poem'] and not(@type) and $bookId = '29'">
				<h3>
					<xsl:attribute name="class">
						<xsl:text>tei teiVariant poemdiary </xsl:text>
						<xsl:if test="@style = 'blackletter'">
							<xsl:text>blackletter</xsl:text>
						</xsl:if>
					</xsl:attribute>
					<xsl:apply-templates/>
				</h3>
			</xsl:when>
			<xsl:when test="parent::tei:div[@type = 'poem'] and not(@type) and not($bookId = '29')">
				<h3>
					<xsl:attribute name="class">
						<xsl:text>tei teiVariant poem </xsl:text>
						<xsl:if test="@style = 'blackletter'">
							<xsl:text>blackletter</xsl:text>
						</xsl:if>
					</xsl:attribute>
					<xsl:apply-templates/>
				</h3>
			</xsl:when>
			<xsl:when test="ancestor::tei:div[@type = 'diary'] and not(@type)">
				<h3>
					<xsl:attribute name="class">
						<xsl:text>tei teiVariant diary </xsl:text>
					</xsl:attribute>
					<xsl:apply-templates/>
				</h3>
			</xsl:when>
			<xsl:when test="parent::tei:castList and not(@type)">
				<h4>
					<xsl:attribute name="class">
						<xsl:text>tei teiVariant poemsub </xsl:text>
						<xsl:if test="@style = 'blackletter'">
							<xsl:text>blackletter</xsl:text>
						</xsl:if>
					</xsl:attribute>
					<xsl:apply-templates/>
				</h4>
			</xsl:when>
			<xsl:when test="parent::tei:castGroup and not(@type)">
				<h5>
					<xsl:attribute name="class">
						<xsl:text>tei teiVariant poemsub2 </xsl:text>
						<xsl:if test="@style = 'blackletter'">
							<xsl:text>blackletter</xsl:text>
						</xsl:if>
					</xsl:attribute>
					<xsl:apply-templates/>
				</h5>
			</xsl:when>
			<xsl:otherwise>
				<h3>
					<xsl:attribute name="class">
						<xsl:text>tei teiVariant chapter </xsl:text>
						<xsl:if test="@style = 'blackletter'">
							<xsl:text>blackletter</xsl:text>
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
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:lg">
		<xsl:if test="name(preceding-sibling::*[1]) = 'p'">
			<p class="tei teiVariant strofeSpacing"/>
		</xsl:if>
		<p>
			<xsl:if test="@xml:id">
				<xsl:attribute name="class">
					<xsl:text>tei teiVariant invisible </xsl:text>
					<xsl:value-of select="@xml:id"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@ns0:cid">
				<xsl:attribute name="id">
					<xsl:value-of select="@ns0:cid"/>
				</xsl:attribute>
			</xsl:if>
		</p>
		<xsl:if test="tei:xptr">
			<span class="tei teiVariant var_margin">
				<xsl:choose>
					<xsl:when test="count(tei:xptr[@type = 'variant']) > 3">
						<span class="tei teiVariant extVariantsTrigger">
							<img src="assets/images/icon_link_variant_big.svg" alt="länkar till varianter" loading="lazy"/>
						</span>
						<span class="tei teiVariant extVariants">
							<xsl:call-template name="extVariants"/>
						</span>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="extVariants"/>
					</xsl:otherwise>
				</xsl:choose>
			</span>
		</xsl:if>
		<xsl:apply-templates/>
		<xsl:if test="name(following-sibling::*[1]) = 'lg' or name(following-sibling::*[1]) = 'p'">
			<p class="tei teiVariant strofeSpacing"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="tei:l">
		<xsl:choose>
			<xsl:when test="@empty = 'true'"/>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="child::tei:seg[@type = 'split']">
						<p>
							<xsl:attribute name="class">
								<xsl:text>tei teiVariant l l</xsl:text>
								<xsl:value-of select="@n"/>
								<xsl:if test="@rend = 'indent' or $bookId = '4' or $bookId = '5'">
									<xsl:text> lIndent</xsl:text>
								</xsl:if>
								<xsl:if test="@style = 'blackletter'">
									<xsl:text> blackletter </xsl:text>
								</xsl:if>
							</xsl:attribute>
							<xsl:choose>
								<xsl:when test="(@n mod 5) = 0 and ancestor::tei:div[@type = 'poem']">
									<span>
										<xsl:attribute name="class">
											<xsl:text>tei teiVariant lNumber l</xsl:text>
											<xsl:value-of select="@n"/>
										</xsl:attribute>
										<xsl:value-of select="@n"/>
									</span>
								</xsl:when>
								<xsl:when test="count(preceding-sibling::tei:l) &lt; 1 and (ancestor::tei:div[@type = 'main'] or ancestor::tei:div[@type = 'letter'] or not(ancestor::tei:div[@type]))">
									<span class="tei teiVariant lNumber">
										<xsl:choose>
											<xsl:when test="$bookId = '15'">
												<xsl:number count="tei:p | tei:lg | tei:list" level="any" from="//tei:body"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:number count="tei:p | tei:lg | tei:list"/>
											</xsl:otherwise>
										</xsl:choose>
									</span>
								</xsl:when>
							</xsl:choose>
							<xsl:value-of select="text()"/>
						</p>
						<xsl:apply-templates select="child::tei:seg" mode="split"/>
					</xsl:when>
					<xsl:otherwise>
						<p>
							<xsl:attribute name="class">
								<xsl:text>tei teiVariant l l</xsl:text>
								<xsl:value-of select="@n"/>
								<xsl:if test="@rend = 'indent' or $bookId = '4' or $bookId = '5' or $bookId = '6' or $bookId = '29'">
									<xsl:text> lIndent</xsl:text>
								</xsl:if>
								<xsl:if test="parent::tei:lg[@type = 'labelledLines_before']">
									<xsl:text> labelledLines_before</xsl:text>
								</xsl:if>
								<xsl:if test="@style = 'blackletter'">
									<xsl:text> blackletter </xsl:text>
								</xsl:if>
							</xsl:attribute>
							<xsl:choose>
								<xsl:when test="(@n mod 5) = 0 and ancestor::tei:div[@type = 'poem']">
									<span>
										<xsl:attribute name="class">
											<xsl:text>tei teiVariant lNumber l</xsl:text>
											<xsl:value-of select="@n"/>
										</xsl:attribute>
										<xsl:value-of select="@n"/>
									</span>
								</xsl:when>
								<xsl:when test="count(preceding-sibling::tei:l) &lt; 1 and (ancestor::tei:div[@type = 'main'] or ancestor::tei:div[@type = 'letter'] or not(ancestor::tei:div[@type]))">
									<span class="tei teiVariant lNumber">
										<xsl:choose>
											<xsl:when test="$bookId = '15'">
												<xsl:number count="tei:p | tei:lg | tei:list" level="any" from="//tei:body"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:number count="tei:p | tei:lg | tei:list"/>
											</xsl:otherwise>
										</xsl:choose>
									</span>
								</xsl:when>
							</xsl:choose>
							<xsl:apply-templates/>
						</p>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:label">
		<xsl:choose>
			<xsl:when test="@place = 'margin'">
				<p class="tei teiVariant label_margin">
					<xsl:apply-templates/>
				</p>
			</xsl:when>
			<xsl:when test="@place = 'above'">
				<p class="tei teiVariant label_above">
					<xsl:apply-templates/>
				</p>
			</xsl:when>
			<xsl:when test="ancestor::tei:lg[@type = 'labelledLines_before']/tei:l and not(parent::tei:l[@part = 'F'])">
				<span class="tei teiVariant labelledLines_before">
					<xsl:apply-templates/>
				</span>
			</xsl:when>
			<xsl:when test="ancestor::tei:lg[@type = 'labelledLines_after']/tei:l and not(parent::tei:l[@part = 'F'])">
				<span class="tei teiVariant labelledLines_after">
					<xsl:apply-templates/>
				</span>
			</xsl:when>
			<xsl:when test="ancestor::tei:lg[@type = 'labelledLines_before']/tei:l[@part = 'F']">
				<span class="tei teiVariant labelledLines_before_F">
					<xsl:apply-templates/>
				</span>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:lb">
		<br/>
	</xsl:template>

	<xsl:template match="tei:p">
		<xsl:call-template name="paragraph"/>
	</xsl:template>

	<xsl:template name="paragraph">
		<xsl:variable name="paragraphNumber">
			<xsl:choose>
				<xsl:when test="contains(@xml:id, '_')">
					<xsl:value-of select="substring-after(@xml:id, '_')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring-after(@xml:id, 'p')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="not(@empty = 'true')">
			<p>
				<xsl:call-template name="attRend">
					<xsl:with-param name="defaultClasses">
						<xsl:if test="@xml:id">
							<xsl:value-of select="@xml:id"/>
							<xsl:text> </xsl:text>
						</xsl:if>
						<xsl:if test="@n = '1' or ($paragraphNumber = '1' and ($bookId = '30' or $bookId = '31')) or parent::tei:postscript">
							<xsl:text>noIndent </xsl:text>
						</xsl:if>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:if test="@ns0:cid">
					<xsl:attribute name="id">
						<xsl:value-of select="@ns0:cid"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="tei:xptr">
					<span class="tei teiVariant var_margin">
						<xsl:choose>
							<xsl:when test="count(tei:xptr[@type = 'variant']) > 3">
								<span class="tei teiVariant extVariantsTrigger">#</span>
								<span class="tei teiVariant extVariants">
									<xsl:call-template name="extVariants"/>
								</span>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="extVariants"/>
							</xsl:otherwise>
						</xsl:choose>
					</span>
				</xsl:if>
				<xsl:if test="@rend = 'italics'">
					<i>
						<xsl:apply-templates/>
					</i>
				</xsl:if>
				<span>
					<xsl:attribute name="class">
						<xsl:text>tei teiVariant paragraph_number p</xsl:text>
						<xsl:value-of select="$paragraphNumber"/>
					</xsl:attribute>
					<xsl:value-of select="$paragraphNumber"/>
					<xsl:text> </xsl:text>
				</span>
				<xsl:apply-templates/>
			</p>
		</xsl:if>
	</xsl:template>

	<xsl:template name="extVariants">
		<xsl:for-each select="tei:xptr[@type = 'variant']">
			<a class="tei teiVariant xreference ref_variant tooltiptrigger ttRefVar">
				<xsl:attribute name="href">
					<xsl:text>#</xsl:text>
					<xsl:value-of select="@target"/>
				</xsl:attribute>
				<xsl:attribute name="rel">
					<xsl:text>nofollow</xsl:text>
				</xsl:attribute>
				<img src="assets/images/icon_link_variant.svg" alt="länk till variant" loading="lazy"/>
			</a>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="tei:figure">
		<xsl:if test="@type = 'illustration'">
			<img class="tei symbol illustration-placeholder" src="assets/images/img_placeholder.svg" alt="kuva" loading="lazy"/>	
		</xsl:if>
	</xsl:template>

	<xsl:template match="tei:graphic">
		<img>
			<xsl:if test="parent::tei:figure/@rend">
				<xsl:attribute name="class">
					<xsl:text>tei teiVariant img_</xsl:text>
					<xsl:value-of select="parent::tei:figure/@rend"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="src">
				<xsl:text>assets/images/verk/</xsl:text>
				<xsl:value-of select="@url"/>
			</xsl:attribute>
			<xsl:attribute name="alt">
				<xsl:text>bild</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="loading">
				<xsl:text>lazy</xsl:text>
			</xsl:attribute>
		</img>
	</xsl:template>

	<xsl:template match="tei:app">
		<xsl:choose>
			<xsl:when test="child::tei:lem/tei:l">
				<div>
					<xsl:attribute name="class">
						<xsl:text>tei teiVariant lemma variantScrollTarget </xsl:text>
						<xsl:value-of select="@id"/>
					</xsl:attribute>
					<xsl:attribute name="id">
						<xsl:value-of select="@id"/>
					</xsl:attribute>
					<xsl:apply-templates/>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<span>
					<xsl:attribute name="class">
						<xsl:text>tei teiVariant lemma variantScrollTarget </xsl:text>
						<xsl:value-of select="@id"/>
					</xsl:attribute>
					<xsl:attribute name="id">
						<xsl:value-of select="@id"/>
					</xsl:attribute>
					<xsl:apply-templates/>
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:anchor">
		<span class="tei teiVariant anchor">
			<xsl:attribute name="class">
				<xsl:text>tei teiVariant anchor anchorScrollTarget </xsl:text>
				<xsl:if test="@subtype = 'ide'">
					<xsl:text>ide </xsl:text>
				</xsl:if>
				<xsl:value-of select="@id"/>
			</xsl:attribute>
			<xsl:choose>
				<xsl:when test="substring(@id, string-length(@id) - string-length('a') + 1) = 'a'">
					<img src="assets/images/ms_arrow_right_gray.svg" alt="pil höger" loading="lazy"/>
				</xsl:when>
				<xsl:otherwise>
					<img src="assets/images/ms_arrow_left_gray.svg" alt="pil vänster" loading="lazy"/>
				</xsl:otherwise>
			</xsl:choose>
		</span>
	</xsl:template>

	<xsl:template match="tei:seg">
		<xsl:text>&#8968;</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>&#8969;</xsl:text>
	</xsl:template>

	<xsl:template match="tei:rdg"/>

	<xsl:template match="tei:lem">
		<xsl:choose>
			<xsl:when test="contains(@type, 'empty')">
				<span class="tei teiVariant seg">
					<img src="assets/images/squared_times.svg" alt="lemma" loading="lazy"/>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:choice">
		<xsl:apply-templates select="tei:sic"/>
	</xsl:template>

	<xsl:template match="tei:corr">
		<xsl:choose>
			<xsl:when test="@source = 'Rättelser'">
				<xsl:apply-templates/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:sic">
		<xsl:apply-templates/>
	</xsl:template>

	<!--<xsl:template match="tei:note">
<xsl:if test="contains(@place, 'foot')">
<span class="tei teiVariant footnoteindicator">
<xsl:attribute name="onmouseover">
<xsl:text>Tip("</xsl:text>
<xsl:value-of select="." />
<xsl:text>")</xsl:text>
</xsl:attribute>
<xsl:value-of select="@n" />
</span>
</xsl:if>
</xsl:template>-->

	<xsl:template match="tei:pb">
		<span>
			<xsl:call-template name="att_pb_class"/>
			<xsl:call-template name="pb_text"/>
		</span>
	</xsl:template>

	<xsl:template match="tei:name">
		<xsl:apply-templates/>
	</xsl:template>

	<!--<xsl:template match="tei:hi">
<span>
<xsl:call-template name="attRend"/>
<xsl:apply-templates/>
</span>
*<xsl:choose>
<xsl:when test="@rend='underline'">
<u>
<xsl:apply-templates/>
</u>
</xsl:when>
<xsl:when test="@rend='expanded'">
<span class="tei teiVariant expanded">
<xsl:apply-templates/>
</span>
</xsl:when>
<xsl:when test="@rend='italics'">
<span class="tei teiVariant italics">
<xsl:apply-templates/>
</span>
</xsl:when>
<xsl:otherwise>
<strong>
<xsl:apply-templates/>
</strong>
</xsl:otherwise>
</xsl:choose>*
</xsl:template>-->

	<xsl:template match="tei:xptr">
		<xsl:choose>
			<xsl:when test="@type = 'variant' and (parent::tei:p or parent::tei:lg)"/>
			<xsl:otherwise>
				<a>
					<xsl:attribute name="class">
						<xsl:text>tei teiVariant</xsl:text>
						<xsl:choose>
							<xsl:when test="@type = 'variant'">
								<xsl:text> xreference ref_variant var_margin tooltiptrigger ttRefVar</xsl:text>
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
					<img src="assets/images/icon_link_variant.svg" alt="länk till varianter" loading="lazy"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:note">
		<xsl:if test="contains(@type, 'editor')">
			<img src="assets/images/asterisk.svg" alt="kommentar" loading="lazy">
				<xsl:attribute name="class">
					<xsl:text>tei teiVariant comment commentScrollTarget tooltiptrigger ttComment </xsl:text>
					<xsl:value-of select="@id"/>
				</xsl:attribute>
				<xsl:attribute name="id">
					<xsl:value-of select="@id"/>
				</xsl:attribute>
			</img>
			<span class="tei teiVariant tooltip">
				<span class="tei teiVariant ttFixed">
					<xsl:apply-templates/>
				</span>
			</span>
		</xsl:if>
		<xsl:if test="contains(@place, 'foot') or contains(@place, 'end') or contains(@id, 'ftn')">
			<span class="tei teiVariant footnoteindicator hand">
				<xsl:attribute name="class">
					<xsl:text>tei teiVariant footnoteindicator tooltiptrigger ttFoot </xsl:text>
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
			<span class="tei teiVariant tooltip ttFoot">
				<span class="tei teiVariant ttFixed">
					<xsl:attribute name="id">
						<xsl:value-of select="@id"/>
					</xsl:attribute>
					<xsl:apply-templates mode="tooltip"/>
				</span>
			</span>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
