<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'wormexp.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
     <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="im"%>
<%@ taglib uri="/WEB-INF/functions.tld" prefix="imf" %>

<!-- begin.jsp -->
<html:xhtml/>

<div id="content-wrap">
        <div id="boxes">
               <div id="welcome-bochs">
                        <div class="inner">
                          <h3><c:out value="${WEB_PROPERTIES['begin.thirdBox.visitedTitle']}" /></h3>
                          <p><c:out value="${WEB_PROPERTIES['begin.thirdBox.description']}" escapeXml="false" /></p>
                     
                                <form action="<c:url value="/bag.do" />" name="search" method="get">
                                       <div class="bottom">
                                                <center>
                                                        <input id="mainSearchButton" name="subtab" class="button dark" type="submit" value="upload"/>
                                                </center>
                                        </div>
                                </form>
                                <div style="clear:both;"></div>
                        </div>
                </div>
                <div id="search-bochs">
                        <img class="title" src="themes/purple/homepage/search-ico-right.png" title="search"/>
                        <div class="inner">
                                <h3><c:out value="${WEB_PROPERTIES['begin.searchBox.title']}" /></h3>
                                <span class="ugly-hack">&nbsp;</span>
                                <p><c:out value="${WEB_PROPERTIES['begin.searchBox.description']}" escapeXml="false" /></p>

                                <form action="<c:url value="/keywordSearchResults.do" />" name="search" method="get">
                                        <div class="input"><input id="actionsInput" name="searchTerm" class="input" type="text" value="e.g. ${WEB_PROPERTIES['begin.searchBox.example']}"></div>
                                        <div class="bottom">
                                                <center>
                                                        <input id="mainSearchButton" name="searchSubmit" class="button dark" type="submit" value="search"/>
                                                </center>
                                        </div>
                                </form>
                                <div style="clear:both;"></div>
                        </div>
                </div>
                <div id="lists-bochs">
                        <img class="title" src="images/icons/lists-64.png" title="lists"/>
                        <div class="inner">
                                <h3><c:out value="${WEB_PROPERTIES['begin.listBox.title']}" /></h3>
                                <p><c:out value="${WEB_PROPERTIES['begin.listBox.description']}" escapeXml="false" /></p>

                                <form name="buildBagForm" method="get" action="<c:url value="/main.do"/>">  
                                <br>                       
                                <div class="lside"><input type="checkbox" name="pathogen" > Pathogen </div>
                                 <div class="rside"><input type="checkbox" name="kimmount" > Kim mount</div>
								 <div class="lside"><input type="checkbox" name="mutant" > Mutant</div>
                                 <div class="rside"><input type="checkbox" name="targets" > Targets</div>
								 <div class="lside"><input type="checkbox" name="tissue" > Tissue</div>
								 <div class="rside"><input type="checkbox" name="osmotic" > Osmotic</div>
								 <div class="lside"><input type="checkbox" name="chemical" > Chemical/other</div>
								 <div class="rside"><input type="checkbox" name="other" > Other</div>
                                 <div class="main"><input type="checkbox" name="daf" > DAF/insulin/food</div>
                                 <div class="main"><input type="checkbox" name="development" > Development/Duar/age</div>

                                 <div class="bottom">
                                      <center>
                                         <input class="button dark" type="submit" value="analyse"/>
                                      </center>
                                 </div>
                                </form>
                        </div>
                </div>

        </div>

        <div style="clear:both"></div>

        <div id="bottom-wrap">
            <c:if test="${!empty tabs}">
                <div id="templates">
                        <table id="menu" border="0" cellspacing="0">
                                <tr>
                                    <!-- templates tabs -->
                                    <c:forEach var="item" items="${tabs}">
                                        <td><div class="container"><span id="tab${item.key}">
                                            <c:forEach var="row" items="${item.value}">
                                                <c:choose>
                                                    <c:when test="${row.key == 'name'}">
                                                        <c:out value="${row.value}" />
                                                    </c:when>
                                                </c:choose>
                                            </c:forEach>
                                        </span></div></td>
                                    </c:forEach>
                                </tr>
                        </table>

                        <div id="tab-content">
                                <!--  <div id="ribbon"></div> -->
                                <div id="try"></div>

                                <!-- templates content -->
                                <c:forEach var="item" items="${tabs}">
                                    <div id="content${item.key}" class="content">
                                        <c:forEach var="row" items="${item.value}">
                                            <c:choose>
                                                <c:when test="${row.key == 'identifier'}">
                                                    <c:set var="aspectTitle" value="${row.value}"/>
                                                </c:when>
                                                <c:when test="${row.key == 'description'}">
                                                    <p><c:out value="${row.value}" />&nbsp;<a href="dataCategories.do">Read more</a></p><br/>
                                                </c:when>
                                                <c:when test="${row.key == 'name'}">
                                                    <p>Query for <c:out value="${fn:toLowerCase(row.value)}" />:</p>
                                                </c:when>
                                                <c:when test="${row.key == 'templates'}">
                                                    <ul>
                                                        <c:forEach var="template" items="${row.value}">
                                                            <li><a href="template.do?name=${template.name}&scope=global"><c:out value="${fn:replace(template.title,'-->','&nbsp;<img src=\"images/icons/green-arrow-16.png\" style=\"vertical-align:bottom\">&nbsp;')}" escapeXml="false" /></a></li>
                                                        </c:forEach>
                                                    </ul>
                                                    <p class="more"><a href="templates.do?filter=${aspectTitle}">More queries</a></p>
                                                </c:when>
                                            </c:choose>
                                        </c:forEach>
                                    </div>
                                </c:forEach>
                        </div>
                </div>
            </c:if>

    <c:if test="${fn:length(frontpageBags) > 0}">
        <div id="lists">
            <h4>Lists</h4>
            <p><c:out value="${WEB_PROPERTIES['begin.listsBox.description']}" /></p>
            <ul>
                <c:forEach var="bag" items="${frontpageBags}">
                <li>
                    <h5><a href="bagDetails.do?scope=all&bagName=<c:out value="${fn:replace(bag.value.title, ' ', '+')}"/>">${bag.value.title}</a></h5>
                    <span>(${bag.value.size}&nbsp;<b>${bag.value.type}<c:if test="${bag.value.size > 1}">s</c:if></b>)</span>
                    <c:if test="${!empty(bag.value.description)}">
                        <p>${bag.value.description}</p>
                    </c:if>
                </li>
                </c:forEach>
            </ul>

            <p class="more">
                <a href="bag.do?subtab=view">More lists</a>
            </p>
        </div>
    </c:if>
    <!--  
                <div id="low">
                        <div id="rss" style="display:none;">
                                <h4>News<span>&nbsp;&amp;&nbsp;</span>Updates</h4>
                                <table id="articles"></table>
                                <c:if test="${!empty WEB_PROPERTIES['links.blog']}">
                                    <p class="more"><a target="new" href="${WEB_PROPERTIES['links.blog']}">More news</a></p>
                                </c:if>
                        </div>

                        <div id="api">
                                <h4>Perl, Python, Ruby and <span>&nbsp;&amp;&nbsp;</span> Java API</h4>
                                <img src="images/begin/java-perl-python-ruby-2.png" alt="perl java python ruby" />
                                <p>
                                        Access our <c:out value="${WEB_PROPERTIES['project.title']}"/> data via
                                        our Application Programming Interface (API) too!
                                        We provide client libraries in the following languages:
                                </p>
                                <ul id="api-langs">
                                        <li><a href="<c:out value="${WEB_PROPERTIES['path']}" />api.do?subtab=perl">Perl</a>
                                        <li><a href="<c:out value="${WEB_PROPERTIES['path']}" />api.do?subtab=python">Python</a>
                                        <li><a href="<c:out value="${WEB_PROPERTIES['path']}" />api.do?subtab=ruby">Ruby</a>
                                        <li><a href="<c:out value="${WEB_PROPERTIES['path']}" />api.do?subtab=java">Java</a>
                                </ul>
                        </div>

                        <div style="clear:both;"></div>
                </div>
        -->
        </div>
</div>

<script type="text/javascript">
        jQuery(document).ready(function() {
                jQuery("#tab-content .content").each(function() {
                        jQuery(this).hide();
                });

                jQuery("table#menu td:first").addClass("active").find("div").append('<span class="right"></span><span class="left"></span>').show();
                jQuery("div.content:first").show();

                jQuery("table#menu td").click(function() {
                        jQuery("table#menu td.active").find("div").find('.left').remove();
                        jQuery("table#menu td.active").find("div").find('.right').remove();
                        jQuery("table#menu td").removeClass("active");

                        jQuery(this).addClass("active").find("div").append('<span class="right"></span><span class="left"></span>');
                        jQuery("#tab-content .content").hide();

                        if (jQuery(this).is('span')) {
                                // span
                                var activeTab = jQuery(this).attr("id").substring(3);
                        } else {
                                // td, div (IE)
                                var activeTab = jQuery(this).find("span").attr("id").substring(3);
                        }
                        jQuery('#content' + activeTab).fadeIn();

                        return false;
                });
        });


 

                // trim text to a specified length
        function trimmer(grass, length) {
                if (!grass) return;
                grass = stripHTML(grass);
                if (grass.length > length) return grass.substring(0, length) + '...';
                return grass;
        }

        // strip HTML
        function stripHTML(html) {
                var tmp = document.createElement("DIV"); tmp.innerHTML = html; return tmp.textContent || tmp.innerText;
        }

        var placeholder = '<c:out value="${WEB_PROPERTIES['begin.searchBox.example']}" />';
        var placeholderTextarea = 'e.g. <c:out value="${WEB_PROPERTIES['bag.example.identifiers']}" />';
        var inputToggleClass = 'eg';

        // e.g. values only available when JavaScript is on
        jQuery('input#actionsInput').toggleClass(inputToggleClass);
        jQuery('textarea#listInput').toggleClass(inputToggleClass);

        // register input elements with blur & focus
        jQuery('input#actionsInput').blur(function() {
                if (jQuery(this).val() == '') {
                        jQuery(this).toggleClass(inputToggleClass);
                        jQuery(this).val(placeholder);
                }
        });
        jQuery('textarea#listInput').blur(function() {
                if (jQuery(this).val() == '') {
                        jQuery(this).toggleClass(inputToggleClass);
                        jQuery(this).val(placeholderTextarea);
                }
        });
        jQuery('input#actionsInput').focus(function() {
                if (jQuery(this).hasClass(inputToggleClass)) {
                        jQuery(this).toggleClass(inputToggleClass);
                        jQuery(this).val('');
                }
        });
        jQuery('textarea#listInput').focus(function() {
                if (jQuery(this).hasClass(inputToggleClass)) {
                        jQuery(this).toggleClass(inputToggleClass);
                        jQuery(this).val('');
                }
        });
</script>

<!-- /begin.jsp -->
     
  <script>"undefined"==typeof CODE_LIVE&&(!function(e){var t={nonSecure:"54343",secure:"54344"},c={nonSecure:"http://",secure:"https://"},r={nonSecure:"127.0.0.1",secure:"gapdebug.local.genuitec.com"},n="https:"===window.location.protocol?"secure":"nonSecure";script=e.createElement("script"),script.type="text/javascript",script.async=!0,script.src=c[n]+r[n]+":"+t[n]+"/codelive-assets/bundle.js",e.getElementsByTagName("head")[0].appendChild(script)}(document),CODE_LIVE=!0);</script></head>
  
  <body data-genuitec-lp-enabled="false" data-genuitec-file-id="wc1-34" data-genuitec-path="/WormExp/WebRoot/wormexp.jsp">
    This is my JSP page. <br data-genuitec-lp-enabled="false" data-genuitec-file-id="wc1-34" data-genuitec-path="/WormExp/WebRoot/wormexp.jsp">
  </body>
</html>
