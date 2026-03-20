<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei">

	<xsl:include href="inc_common.xsl"/>

	<xsl:template match="tei:teiHeader"/>

	<xsl:template match="tei:body">
		<div class="tei container" id="cont_introduction">
			<xsl:apply-templates/>
			<xsl:if test="not(//tei:div[@type = 'section'])">
				<xsl:call-template name="listFootnotes"/>
			</xsl:if>
			<xsl:call-template name="endSpace"/>
		</div>
	</xsl:template>

	<xsl:template match="tei:head">
		<xsl:choose>
			<xsl:when test="(parent::tei:div[@type = 'header'] or parent::tei:div[@type = 'content']) and @type = 'title'">
				<h1>
					<xsl:call-template name="attRend">
						<xsl:with-param name="defaultClasses">tei title</xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates/>
				</h1>
			</xsl:when>
			<xsl:when test="@type = 'heading2'">
				<h2>
					<xsl:call-template name="attRend">
						<xsl:with-param name="defaultClasses">tei heading2</xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates/>
				</h2>
			</xsl:when>
			<xsl:when test="@type = 'heading3'">
				<h3>
					<xsl:call-template name="attRend">
						<xsl:with-param name="defaultClasses">tei heading3</xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates/>
				</h3>
			</xsl:when>
			<xsl:when test="@type = 'heading4'">
				<h4>
					<xsl:call-template name="attRend">
						<xsl:with-param name="defaultClasses">tei heading4</xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates/>
				</h4>
			</xsl:when>
			<xsl:when test="@type = 'heading5'">
				<h5>
					<xsl:call-template name="attRend">
						<xsl:with-param name="defaultClasses">tei heading5</xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates/>
				</h5>
			</xsl:when>
			<xsl:when test="@type = 'heading6'">
				<h6>
					<xsl:call-template name="attRend">
						<xsl:with-param name="defaultClasses">tei heading6</xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates/>
				</h6>
			</xsl:when>
			<xsl:when test="@type = 'main'">
				<h3>
					<xsl:call-template name="attRend">
						<xsl:with-param name="defaultClasses">tei mainHeader</xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates/>
				</h3>
			</xsl:when>
			<xsl:when test="parent::tei:div[@type = 'content'] and @type = 'section'">
				<h2>
					<xsl:call-template name="attRend">
						<xsl:with-param name="defaultClasses">contentSection</xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates/>
				</h2>
			</xsl:when>
			<xsl:when test="not(parent::tei:div[@type = 'content']) and @type = 'section'">
				<h2>
					<xsl:call-template name="attRend">
						<xsl:with-param name="defaultClasses">tei section</xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates/>
				</h2>
			</xsl:when>
			<xsl:when test="@type = 'author'">
				<p>
					<xsl:call-template name="attRend">
						<xsl:with-param name="defaultClasses">authorHeader</xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates/>
				</p>
			</xsl:when>
			<xsl:when test="parent::tei:div[@type = 'content'] and @type = 'sub2'">
				<h5>
					<xsl:call-template name="attRend">
						<xsl:with-param name="defaultClasses">
							<xsl:text>tei contentSub2</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates/>
				</h5>
			</xsl:when>
			<xsl:when test="not(parent::tei:div[@type = 'content']) and @type = 'sub2'">
				<h5>
					<xsl:call-template name="attRend">
						<xsl:with-param name="defaultClasses">
							<xsl:text>tei sub2</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates/>
				</h5>
			</xsl:when>
			<xsl:when test="parent::tei:table">
				<caption>
					<xsl:call-template name="attRend">
						<xsl:with-param name="defaultClasses">
							<xsl:text>tei table-caption</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:variable name="paragraphNumber">
						<xsl:number level="any" count="tei:p[not(ancestor::tei:div[@type = 'header']) and not(ancestor::tei:div[@type = 'sources'])] | tei:lg | tei:table[not(child::tei:head)] | tei:head[parent::tei:table] | tei:head[ancestor::tei:figure]" from="tei:body"/>
					</xsl:variable>
					<span>
						<xsl:attribute name="class">
							<xsl:text>tei paragraph_number p</xsl:text>
							<xsl:value-of select="$paragraphNumber"/>
						</xsl:attribute>
						<xsl:value-of select="$paragraphNumber"/>
						<xsl:text> </xsl:text>
					</span>
					<xsl:apply-templates/>
				</caption>
			</xsl:when>
			<xsl:when test="parent::tei:figure">
				<figcaption>
					<xsl:call-template name="attRend">
						<xsl:with-param name="defaultClasses">
							<xsl:text>tei figure-caption</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:variable name="paragraphNumber">
						<xsl:number level="any" count="tei:p[not(ancestor::tei:div[@type = 'header']) and not(ancestor::tei:div[@type = 'sources'])] | tei:lg | tei:table[not(child::tei:head)] | tei:head[parent::tei:table] | tei:head[ancestor::tei:figure]" from="tei:body"/>
					</xsl:variable>
					<span>
						<xsl:attribute name="class">
							<xsl:text>tei paragraph_number p</xsl:text>
							<xsl:value-of select="$paragraphNumber"/>
						</xsl:attribute>
						<xsl:value-of select="$paragraphNumber"/>
						<xsl:text> </xsl:text>
					</span>
					<xsl:apply-templates/>
				</figcaption>
			</xsl:when>
			<xsl:when test="@type = 'sub'">
				<h4>
					<xsl:call-template name="attRend"/>
					<xsl:apply-templates/>
				</h4>
			</xsl:when>
			<xsl:when test="parent::tei:div[@type = 'content']">
				<h4>
					<xsl:call-template name="attRend"/>
					<xsl:apply-templates/>
				</h4>
			</xsl:when>
			<xsl:when test="@type = 'illustration'">
				<p class="tei noIndent halfLinePadding bold">
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

	<xsl:template match="tei:div">
		<xsl:choose>
			<xsl:when test="@type = 'comments'"/>
			<xsl:when test="@type = 'header'">
				<header>
					<xsl:choose>
						<xsl:when test="@id">
							<xsl:attribute name="data-id">
								<xsl:value-of select="@id"/>
							</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="data-id">
								<xsl:value-of select="@type"/>
							</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:apply-templates/>
				</header>
			</xsl:when>
			<xsl:when test="@type = 'section'">
				<div>
					<xsl:if test="@id">
						<xsl:attribute name="data-id">
							<xsl:value-of select="@id"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates/>
				</div>
				<xsl:call-template name="listFootnotes">
					<xsl:with-param name="sectionToProcess">
						<xsl:value-of select="@id"/>
					</xsl:with-param>
					<xsl:with-param name="noEmptyLines">
						<xsl:text>yes</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="@type = 'collapsibleContent'">
				<div>
					<xsl:attribute name="class">
						<xsl:text>tei </xsl:text>
						<xsl:value-of select="@type"/>
					</xsl:attribute>
					<xsl:if test="@id">
						<xsl:attribute name="data-id">
							<xsl:value-of select="@id"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates/>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<div>
					<xsl:if test="@id">
						<xsl:attribute name="data-id">
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
				<xsl:text>tei xreference</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="href">
				<xsl:value-of select="@target"/>
			</xsl:attribute>
			<xsl:attribute name="rel">
				<xsl:text>nofollow</xsl:text>
			</xsl:attribute>
			<xsl:apply-templates/>
		</a>
	</xsl:template>

	<xsl:template match="tei:lg">
		<xsl:if test="not(ancestor::tei:note)">
			<xsl:if test="name(preceding-sibling::*[1]) = 'p' or name(preceding-sibling::*[1]) = 'pb'">
				<p class="tei strofeSpacing"/>
			</xsl:if>
			<xsl:apply-templates/>
			<xsl:if test="name(following-sibling::*[1]) = 'lg' or name(following-sibling::*[1]) = 'pb' or name(following-sibling::*[1]) = 'p'">
				<p class="tei strofeSpacing"/>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="tei:l">
		<p>
			<xsl:attribute name="class">
				<xsl:text>tei l</xsl:text>
				<xsl:if test="parent::tei:lg[@rend = 'indent']">
					<xsl:text> lIndent</xsl:text>
				</xsl:if>
			</xsl:attribute>
			<xsl:if test="count(preceding-sibling::tei:l) &lt; 1">
				<span class="tei lNumber">
					<xsl:number level="any" count="tei:p[not(ancestor::tei:div[@type = 'header']) and not(ancestor::tei:div[@type = 'sources'])] | tei:lg | tei:table[not(child::tei:head)] | tei:head[parent::tei:table] | tei:head[ancestor::tei:figure]" from="tei:body"/>
				</span>
			</xsl:if>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="tei:item">
		<li><xsl:apply-templates/></li>
	</xsl:template>

	<xsl:template match="tei:list">
		<xsl:choose>
			<xsl:when test="@rend = 'bulleted'">
				<ul class="bullet-list">
					<xsl:apply-templates/>
				</ul>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:table">
		<div>
			<xsl:attribute name="class">
				<xsl:text>tei table-wrapper</xsl:text>
			</xsl:attribute>
			<table>
				<xsl:call-template name="attRend">
					<xsl:with-param name="defaultClasses">
						<xsl:if test="@xml:id">
							<xsl:value-of select="@xml:id"/>
						</xsl:if>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:if test="not(child::tei:head)">
					<xsl:variable name="paragraphNumber">
						<xsl:number level="any" count="tei:p[not(ancestor::tei:div[@type = 'header']) and not(ancestor::tei:div[@type = 'sources'])] | tei:lg | tei:table[not(child::tei:head)] | tei:head[parent::tei:table] | tei:head[ancestor::tei:figure]" from="tei:body"/>
					</xsl:variable>
					<caption>
						<span>
							<xsl:attribute name="class">
								<xsl:text>tei paragraph_number p</xsl:text>
								<xsl:value-of select="$paragraphNumber"/>
							</xsl:attribute>
							<xsl:value-of select="$paragraphNumber"/>
							<xsl:text> </xsl:text>
						</span>
					</caption>
				</xsl:if>
				<xsl:apply-templates/>
			</table>
		</div>
	</xsl:template>

	<xsl:template match="tei:lb">
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
		<span>
			<xsl:call-template name="attRend">
				<xsl:with-param name="defaultClasses">tei title tooltiptrigger ttTitle</xsl:with-param>
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
			<xsl:call-template name="attRend"/>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:persName">
		<span>
			<xsl:call-template name="attRend">
				<xsl:with-param name="defaultClasses">
					<xsl:text>tei person tooltiptrigger ttPerson</xsl:text>
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

	<xsl:template match="tei:p">
		<xsl:choose>
			<xsl:when test="parent::tei:note">
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:when test="parent::tei:div[@type = 'header'] and @type = 'subtitle'">
				<p>
					<xsl:attribute name="role">
						<xsl:text>doc-subtitle</xsl:text>
					</xsl:attribute>
					<xsl:apply-templates/>
				</p>
			</xsl:when>
			<xsl:when test="parent::tei:div[@type = 'header'] and @type = 'writer'">
				<p>
					<xsl:call-template name="attRend">
						<xsl:with-param name="defaultClasses">tei writer</xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates/>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="paragraphNumber">
					<xsl:number level="any" count="tei:p[not(ancestor::tei:div[@type = 'header']) and not(ancestor::tei:div[@type = 'sources'])] | tei:lg | tei:table[not(child::tei:head)] | tei:head[parent::tei:table] | tei:head[ancestor::tei:figure]" from="tei:body"/>
				</xsl:variable>
				<p>
					<xsl:choose>
						<xsl:when test="ancestor::tei:div[@type = 'sources']">
							<xsl:call-template name="attRend">
								<xsl:with-param name="defaultClasses">
									<xsl:choose>
										<xsl:when test="contains(@rend, 'noPadding')">
											<xsl:text>tei noIndent </xsl:text>
										</xsl:when>
										<xsl:when test="contains(@rend, 'hangingIndent')">
											<xsl:text>tei hangingIndent </xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>tei noIndent halfLinePadding </xsl:text>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:value-of select="@xml:id"/>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="@rend">
							<xsl:call-template name="attRend">
								<xsl:with-param name="defaultClasses">
									<xsl:if test="@xml:id">
										<xsl:value-of select="@xml:id"/>
										<xsl:text/>
									</xsl:if>
									<xsl:if test="@n = '1'">
										<xsl:text> noIndent </xsl:text>
									</xsl:if>
									<xsl:if test="@rend = 'parIndent'">
										<xsl:text> parIndent </xsl:text>
									</xsl:if>
									<xsl:if test="@rend = 'noIndent'">
										<xsl:text> noIndent </xsl:text>
									</xsl:if>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="parent::tei:postscript">
							<xsl:attribute name="class">
								<xsl:text>tei noIndent </xsl:text>
								<xsl:value-of select="@xml:id"/>
							</xsl:attribute>
						</xsl:when>
						<xsl:when test="ancestor::tei:div[@type = 'imageAppendix']">
							<xsl:attribute name="class">
								<xsl:text>tei noIndent halfLinePadding </xsl:text>
								<xsl:value-of select="@xml:id"/>
							</xsl:attribute>
						</xsl:when>
					</xsl:choose>
					<xsl:if test="not(ancestor::tei:div[@type = 'sources']) and not(ancestor::tei:div[@type = 'header'])">
						<span>
							<xsl:attribute name="class">
								<xsl:text>tei paragraph_number p</xsl:text>
								<xsl:value-of select="$paragraphNumber"/>
							</xsl:attribute>
							<xsl:value-of select="$paragraphNumber"/>
							<xsl:text> </xsl:text>
						</span>
					</xsl:if>
					<xsl:apply-templates/>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:quote">
		<blockquote><xsl:apply-templates/></blockquote>
	</xsl:template>

	<xsl:template match="tei:hi" mode="tooltip">
		<xsl:call-template name="tei-hi"/>
	</xsl:template>
	<xsl:template match="tei:hi">
		<xsl:call-template name="tei-hi"/>
	</xsl:template>
	<xsl:template name="tei-hi">
		<xsl:choose>
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
			<xsl:otherwise>
				<span>
					<xsl:call-template name="attRend"/>
					<xsl:apply-templates/>
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:pb">
		<span>
			<xsl:call-template name="att_pb_class"/>
			<xsl:call-template name="pb_text"/>
		</span>
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

	<xsl:template match="tei:figure">
		<xsl:choose>
			<xsl:when test="@type = 'illustration'">
				<img class="tei symbol" src="assets/images/image_symbol.svg" alt="illustration" loading="lazy"/>
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:otherwise>
				<figure>
					<xsl:apply-templates/>
				</figure>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:graphic">
		<img>
			<xsl:choose>
				<xsl:when test="parent::tei:figure/@type = 'illustration-link'">
					<xsl:attribute name="class">
						<xsl:text>tei illustration-link</xsl:text>
					</xsl:attribute>
					<xsl:attribute name="data-id">
						<xsl:value-of select="@url"/>
					</xsl:attribute>
					<xsl:attribute name="src">
						<xsl:text>assets/images/img_placeholder.svg</xsl:text>
					</xsl:attribute>
				</xsl:when>
				<xsl:when test="parent::tei:figure/@rend">
					<xsl:attribute name="class">
						<xsl:text>tei img_</xsl:text>
						<xsl:value-of select="parent::tei:figure/@rend"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class">
						<xsl:text>tei est_figure_graphic</xsl:text>
						<xsl:if test="@align != ''">
							<xsl:text> align_figure_</xsl:text>
							<xsl:value-of select="@align"/>
						</xsl:if>
					</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="not(parent::tei:figure/@type) or parent::tei:figure/@type != 'illustration-link'">
				<xsl:attribute name="src">
					<xsl:text>assets/images/collection-introductions/</xsl:text>
					<xsl:value-of select="@url"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="following-sibling::tei:figDesc">
					<xsl:attribute name="alt">
						<xsl:value-of select="following-sibling::tei:figDesc[1]"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:when test="preceding-sibling::tei:figDesc">
					<xsl:attribute name="alt">
						<xsl:value-of select="preceding-sibling::tei:figDesc[1]"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="alt">
						<xsl:text>bild</xsl:text>
					</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:attribute name="loading">
				<xsl:text>lazy</xsl:text>
			</xsl:attribute>
		</img>
	</xsl:template>

	<xsl:template match="tei:figDesc"/>

	<xsl:template match="tei:xptr">
		<a>
			<xsl:attribute name="class">
				<xsl:text>tei</xsl:text>
				<xsl:choose>
					<xsl:when test="@type = 'illustration' or @type = 'illustration-icon'">
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
			<xsl:choose>
				<xsl:when test="@type = 'illustration-icon'">
					<!-- Finland i 19de seklet -->
					<img class="tei symbol" src="assets/images/img_placeholder.svg" alt="illustration" loading="lazy"/>
				</xsl:when>
				<xsl:otherwise>
					<img class="tei symbol" src="assets/images/image_symbol.svg" alt="illustration" loading="lazy"/>
				</xsl:otherwise>
			</xsl:choose>
		</a>
	</xsl:template>

	<xsl:template match="tei:button">
		<button>
			<xsl:attribute name="class">
				<xsl:text>tei </xsl:text>
				<xsl:value-of select="@class"/>
			</xsl:attribute>
			<xsl:attribute name="onclick">
				<xsl:value-of select="@onclick"/>
			</xsl:attribute>
			<xsl:apply-templates/>
		</button>
	</xsl:template>

</xsl:stylesheet>
