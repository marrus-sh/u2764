<stylesheet id="transform" version="1.0" xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:html="http://www.w3.org/1999/xhtml">
	<variable name="feed" select="//html:link[@rel='alternate'][@type='application/atom+xml']/@href[1]"/>
	<template name="entries">
		<param name="source" select="$feed"/>
		<variable name="self" select="document($source)//atom:feed/atom:link[@rel='self']/@href[1]"/>
		<variable name="name" select="substring-before(substring-after($self, atom:link[@rel='alternate']/@href[1]), '.')"/>
		<html:li>
			<html:details>
				<if test="$name='index'">
					<attribute name="open"/>
				</if>
				<html:summary lang="en" xml:lang="en">
					<choose>
						<when test="$name='index'">
							<text>Most Recent</text>
						</when>
						<when test="starts-with($name, 'archive-')">
							<value-of select="concat(translate(substring(substring-after($name, 'archive-'), 1, 1), 'abcdðefƒghijklmnŋopqrstuvwxyzþæœ', 'ABCDÐEFƑGHIJKLMNŊOPQRSTUVWXYZÞÆŒ'), translate(substring(substring-after($name, 'archive-'), 2), '-_', '‐ '))"/>
						</when>
						<otherwise>
							<value-of select="concat(translate(substring($name, 1, 1), 'abcdðefƒghijklmnŋopqrstuvwxyzþæœ-_', 'ABCDÐEFƑGHIJKLMNŊOPQRSTUVWXYZÞÆŒ· '), translate(substring($name, 2), '-_', '‐ '))"/>
						</otherwise>
					</choose>
				</html:summary>
				<html:ol>
					<for-each select="document($source)//atom:entry">
						<sort select="atom:link[@rel='alternate']/@href[1]" lang="zxx" order="descending"/>
						<variable name="date" select="substring-before(substring-after(atom:link[@rel='alternate']/@href[1], document($feed)//atom:feed[1]/atom:link[@rel='alternate']/@href[1]), '/')"/>
						<variable name="identifier" select="substring-before(substring-after(substring-after(atom:link[@rel='alternate']/@href[1], document($feed)//atom:feed[1]/atom:link[@rel='alternate']/@href[1]), '/'), '/')"/>
						<html:li title="{normalize-space(atom:summary)}">
							<apply-templates select="." mode="lang"/>
							<html:a data-atom-id="{atom:id}" href="{atom:link[@rel='alternate']/@href[1]}">
								<if test="@xml:id">
									<attribute name="id">
										<value-of select="@xml:id"/>
									</attribute>
								</if>
								<html:small>
									<html:time datetime="{$date}">
										<text>[</text>
										<value-of select="$date"/>
										<text>]</text>
									</html:time>
									<text> </text>
									<html:code>
										<value-of select="$identifier"/>
									</html:code>
								</html:small>
								<if test="atom:link[@rel='http://id.loc.gov/ontologies/bibframe/coverArt']">
									<html:img alt="{atom:title} cover art." src="{atom:link[@rel='http://id.loc.gov/ontologies/bibframe/coverArt']/@href[1]}"/>
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
			</html:details>
		</html:li>
		<if test="document($source)//atom:feed[1]/atom:link[@rel='prev-archive']">
			<call-template name="entries">
				<with-param name="source" select="document($source)//atom:feed[1]/atom:link[@rel='prev-archive'][1]/@href[1]"/>
			</call-template>
		</if>
	</template>
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
details#sidebar>nav>h1{ Box-Sizing: Border-Box; Grid-Area: 1 / 1; Margin: Auto; Padding: .5EM; Width: Max-Content; Max-Width: 100%; Text-Align: Center; Text-Decoration: Underline }
div#scroller{ Box-Sizing: Border-Box; Direction: RTL; Grid-Area: 2 / 1; Justify-Self: Stretch; Border-Top: Thin Solid; Overflow-Y: Scroll }
div#scroller ol{ Direction: LTR; Margin: 0; Padding: 0 }
div#scroller li{ Display: Block; Margin: 0; Padding: 0 }
div#scroller li>details>summary{ Box-Sizing: Border-Box; Border-Width: Medium; Border-Bottom-Style: Double; Padding: .25REM .5REM; Overflow: Hidden; White-Space: NoWrap; Font-Style: Italic; Font-Weight: Bold; Text-Align: Center; Text-Overflow: Ellipsis }
div#scroller li:Not(:First-Child)>details{ Margin-Top: .75REM; Border-Top-Style: Double }
div#scroller li:Only-Child>details[open]>summary{ Display: None }
div#scroller li>a{ Display: Grid; Border-Bottom: Thin Solid; Padding: .5REM .5REM .5REM .5REM; Grid: Auto-Flow / MinMax(1.5REM, Max-Content) 1FR; Gap: .5REM }
div#scroller li>a:Any-Link{ Color: Inherit; Text-Decoration: None }
div#scroller li>a>small:First-Child{ Display: Block; Box-Sizing: Border-Box; Grid-Column: 1 / Span 2; Margin: -.5REM -.5REM 0 -.5REM; Border-Bottom: Thin Solid; Padding: .25REM .5REM; Min-Width: 100%; Overflow: Hidden; White-Space: NoWrap; Font-Size: Inherit; Font-Weight: Bold; Line-Height: 1; Text-Overflow: Ellipsis }
div#scroller li>a>small:First-Child>code{ Font: Inherit; Font-Style: Italic }
div#scroller li>a>img{ Display: Block; Grid-Column: 1; Width: 3REM; Height: 3REM; Object-Fit: Contain }
div#scroller li>a>span{ Display: Block; Grid-Column: 2; Align-Self: Center; Max-Width: Max-Content; Hyphens: Auto }
div#scroller li>a:Any-Link>span{ Text-Decoration: Underline }
div#scroller li>a>small:First-Child+span{ Margin-Left: -1.5REM; Padding-Left: 1.5REM; Text-Indent: -1REM }
div#scroller>footer{ Direction: LTR; Padding: 0 .5EM; Font-Size: Smaller }
div#scroller>footer hr{ Border-Style: Solid None None; Border-Color: Inherit; Border-Width: Thin; Font-Style: Italic }
div#scroller>footer p{ Direction: LTR; Margin: .75EM 0 }
div#scroller>footer cite,
div#scroller>footer em,
div#scroller>footer i{ Font-Style: Normal }
div#window{ Position: Relative; Grid-Area: 1 / 2 / Span 2 / Span 1; Border-Left: Thin Solid; Overflow: Auto }
iframe#pane[name=pane]{ Display: Block; Box-Sizing: Border-Box; Margin: 0; Border: None; Width: 100%; Height: 100% }
iframe#pane[name=pane][src]:Not([src="about:blank"]){ Background: #FFFFFF }
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
				<variable name="entries">
					<call-template name="entries"/>
				</variable>
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
								<call-template name="entries"/>
							</html:ol>
							<html:footer>
								<for-each select="atom:subtitle|atom:rights">
									<variable name="wrapper">
										<choose>
											<when test="@type='xhtml' and .//html:*[local-name()='p' or local-name()='pre']">div</when>
											<otherwise>p</otherwise>
										</choose>
									</variable>
									<element name="{$wrapper}" namespace="http://www.w3.org/1999/xhtml">
										<apply-templates select="." mode="lang"/>
										<apply-templates select="." mode="content"/>
									</element>
								</for-each>
								<html:hr/>
								<html:p lang="en" xml:lang="en">
									<html:a target="_self">
										<attribute name="href">
											<choose>
												<when test="atom:link[@rel='self']/@href">
													<value-of select="atom:link[@rel='self']/@href[1]"/>
												</when>
												<otherwise>
													<value-of select="$feed"/>
												</otherwise>
											</choose>
										</attribute>
										<html:img width="14" height="14" style="Height: 2EX; Width: 2EX; Vertical-Align: Middle" title="Feed icon" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAJDSURBVHjajJJNSBRhGMd/887MzrQxRSLbFuYhoUhEKsMo8paHUKFLdBDrUIdunvq4RdClOq8Hb0FBSAVCUhFR1CGD/MrIJYqs1kLUXd382N356plZFOrUO/MMz/vO83+e93n+f+1zF+kQBoOQNLBJg0CTj7z/rvWjGbEOIwKp9O7WkhtQc/wMWrlIkP8Kc1lMS8eyFHpkpo5SgWCCVO7Z5JARhuz1Qg29fh87u6/9VWL1/SPc4Qy6n8c0FehiXin6dcCQaylDMhqGz8ydS2hKkmxNkWxowWnuBLHK6G2C8X6UJkBlxUmNqLYyNbzF74QLDrgFgh9LLE0NsPKxjW1Hz2EdPIubsOFdH2HgbwAlC4S19dT13o+3pS+vcSfvUcq9YnbwA6muW9hNpym/FWBxfh0CZkKGkPBZeJFhcWQAu6EN52QGZ/8prEKW+cdXq0039UiLXhUYzdjebOJQQI30UXp6mZn+Dtam32Afu0iyrgUvN0r+ZQbr8HncSpUVJfwRhBWC0hyGV8CxXBL5SWYf9sYBidYLIG2V87/ifVjTWAX6AlxeK2C0X8e58hOr/Qa2XJ3iLMWxB1h72tHs7bgryzHAN2o2gJorTrLxRHVazd0o4TXiyV2Yjs90uzauGvvppmqcLjwmbZ3V7BO2HOrBnbgrQRqWUgTZ5+Snx4WeKfzCCrmb3axODKNH+vvUyWjqyK4DiKQ0eXSpFsgVvLJQWpH+xSpr4otg/HI0TR/t97cxTUS+QxIMRTLi/9ZYJPI/AgwAoc3W7ZrqR2IAAAAASUVORK5CYII="/> Atom feed</html:a> | <html:a href="/" target="_self">Take me home</html:a>.
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
