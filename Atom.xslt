<stylesheet id="transform" version="1.0" xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:html="http://www.w3.org/1999/xhtml">
	<variable name="feed" select="//html:link[@rel='alternate'][@type='application/atom+xml']/@href[1]"/>
	<template match="@*|node()" mode="clone">
		<copy>
			<apply-templates select="@*|node()" mode="clone"/>
		</copy>
	</template>
	<template match="*" mode="lang">
		<attribute name="lang">
			<value-of select="ancestor-or-self::*[@xml:lang][1]/@xml:lang"/>
		</attribute>
		<attribute name="xml:lang">
			<value-of select="ancestor-or-self::*[@xml:lang][1]/@xml:lang"/>
		</attribute>
	</template>
	<template match="*" mode="content">
		<choose>
			<!-- "html" content is not supported; use "xhtml" -->
			<when test="@type='xhtml'">
				<for-each select="html:div[1]">
					<apply-templates mode="clone"/>
				</for-each>
			</when>
			<otherwise>
				<value-of select="."/>
			</otherwise>
		</choose>
	</template>
	<template match="html:html">
		<copy>
			<for-each select="@*">
				<copy/>
			</for-each>
			<apply-templates/>
		</copy>
	</template>
	<template match="html:head">
		<copy>
			<for-each select="@*">
				<copy/>
			</for-each>
			<html:style>
@namespace "http://www.w3.org/1999/xhtml";
html{ Margin: 0; Padding: 0 }
body{ Display: Grid; Margin: 0; Padding: 0; Height: 100VH; Grid: 1FR / Auto 1FR }
details#sidebar{ Writing-Mode: Vertical-RL; Width: Max-Content; Height: 100VH }
details#sidebar>summary{ Padding: .25EM; Font-Size: X-Large; Font-Style: Italic; Line-Height: 1 }
details#sidebar>nav{ Display: Grid; Writing-Mode: Horizontal-TB; Border-Right: Thin Solid; Max-Width: Calc(100VW / 3); Height: 100VH; Overflow: Hidden; Grid: Max-Content 1FR / MinMax(Calc(100VW / 3), Min-Content) }
details#sidebar>nav>h1{ Box-Sizing: Border-Box; Grid-Area: 1 / 1; Margin: Auto; Padding: .5EM; Width: Max-Content; Text-Decoration: Underline }
div#scroller{ Box-Sizing: Border-Box; Direction: RTL; Grid-Area: 2 / 1; Justify-Self: Stretch; Border-Top: Thin Solid; Overflow-Y: Scroll }
div#scroller>ol{ Direction: LTR; Margin: 0; Padding: 0 }
div#scroller>ol>li{ Display: Block; Margin: 0; Padding: 0 }
div#scroller>ol>li>a{ Display: Block; Border-Bottom: Thin Solid; Padding: .5EM .5EM .5EM 2.5EM }
div#scroller>ol>li>a:Any-Link{ Color: Inherit; Text-Decoration: None }
div#scroller>ol>li>a:Any-Link>span{ Text-Decoration: Underline }
div#scroller>ol>li>a::before{ Display: Block; Box-Sizing: Border-Box; Margin: -.5EM -.5EM .5EM -2.5EM; Border-Bottom: Thin Solid; Padding: .25EM .5EM; Overflow: Hidden; White-Space: NoWrap; Font-Style: Italic; Font-Weight: Bold; Line-Height: 1; Text-Overflow: Ellipsis; Content: "[" Attr(data-datetime) "] " Attr(data-identifier) }
div#scroller>ol>li>a>span{ Display: Block; Text-Indent: -1EM; Hyphens: Auto }
div#scroller>footer{ Direction: LTR; Padding: 0 .5EM; Font-Size: Smaller }
div#scroller>footer hr{ Border-Style: Solid None None; Border-Color: Inherit; Border-Width: Thin; Font-Style: Italic }
div#scroller>footer p{ Direction: LTR; Margin: .75EM 0 }
div#scroller>footer cite,
div#scroller>footer em,
div#scroller>footer i{ Font-Style: Normal }
div#window{ Position: Relative; Grid-Area: 1 / 2 / Span 2 / Span 1; Border-Left: Thin Solid; Overflow: Auto }
iframe#pane[name=pane]{ Display: Block; Box-Sizing: Border-Box; Margin: 0; Border: None; Width: 100%; Height: 100% }
			</html:style>
			<apply-templates mode="clone"/>
			<html:base target="pane"/>
			<if test="not(html:title)">
				<html:title>
					<apply-templates select="." mode="lang"/>
					<value-of select="document($feed)//atom:feed/atom:title"/>
				</html:title>
			</if>
			<html:meta name="viewport" content="width=device-width,intial-scale=1"/>
			<html:meta name="referrer" content="no-referrer"/>
			<if test="document($feed)//atom:feed/atom:icon">
				<html:link rel="icon" href="{document($feed)//atom:feed/atom:icon}"/>
			</if>
		</copy>
	</template>
	<template match="html:body">
		<copy>
			<for-each select="@*">
				<copy/>
			</for-each>
			<for-each select="document($feed)//atom:feed[1]">
				<html:details id="sidebar" open="">
					<html:summary lang="en" xml:lang="en">Contents</html:summary>
					<html:nav>
						<apply-templates select="." mode="lang"/>
						<for-each select="atom:title[1]">
							<html:h1>
								<apply-templates select="." mode="content"/>
							</html:h1>
						</for-each>
						<html:div id="scroller">
							<html:ol>
								<for-each select="atom:entry">
									<sort select="@xml:id" lang="zxx"/>
									<html:li>
										<apply-templates select="." mode="lang"/>
										<html:a data-atom-id="{atom:id}" data-datetime="{substring-before(substring-after(atom:link[@rel='alternate']/@href, 'XRPT/'), '/')}" data-identifier="{substring-before(substring-after(substring-after(atom:link[@rel='alternate']/@href, 'XRPT/'), '/'), '/')}" href="{atom:link[@rel='alternate']/@href}">
											<if test="@xml:id">
												<attribute name="id">
													<value-of select="@xml:id"/>
												</attribute>
											</if>
											<for-each select="atom:title">
												<html:span>
													<apply-templates select="." mode="lang"/>
													<apply-templates select="." mode="content"/>
												</html:span>
											</for-each>
										</html:a>
									</html:li>
								</for-each>
							</html:ol>
							<html:footer>
								<for-each select="atom:subtitle|atom:rights">
									<variable name="wrapper">
										<choose>
											<when test="@type='xhtml' and html:p">div</when>
											<otherwise>p</otherwise>
										</choose>
									</variable>
									<element name="{$wrapper}" namespace="http://www.w3.org/1999/xhtml">
										<apply-templates select="." mode="lang"/>
										<apply-templates select="." mode="content"/>
									</element>
								</for-each>
								<html:hr/>
								<html:p>
									<html:a lang="en" xml:lang="en" href="/" target="_self">Take me home.</html:a>
								</html:p>
							</html:footer>
						</html:div>
					</html:nav>
				</html:details>
				<html:div id="window">
					<html:iframe id="pane" name="pane" src="about:blank"/>
				</html:div>
			</for-each>
		</copy>
	</template>
</stylesheet>
