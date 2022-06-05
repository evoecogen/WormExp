<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="im"%>
<%@ taglib uri="/WEB-INF/functions.tld" prefix="imf" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'useage.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<link rel="stylesheet" type="text/css" href="styles.css">
	 <script type="text/javascript"
        
            
            src="http://cdn.intermine.org/js/jquery/2.0.3/jquery.min.js"
        
        ></script>
  <script>"undefined"==typeof CODE_LIVE&&(!function(e){var t={nonSecure:"54343",secure:"54344"},c={nonSecure:"http://",secure:"https://"},r={nonSecure:"127.0.0.1",secure:"gapdebug.local.genuitec.com"},n="https:"===window.location.protocol?"secure":"nonSecure";script=e.createElement("script"),script.type="text/javascript",script.async=!0,script.src=c[n]+r[n]+":"+t[n]+"/codelive-assets/bundle.js",e.getElementsByTagName("head")[0].appendChild(script)}(document),CODE_LIVE=!0);</script></head>
  
  <body data-genuitec-lp-enabled="false" data-genuitec-file-id="wc1-33" data-genuitec-path="/WormExp/WebRoot/useage.jsp">
    This is my JSP page. <br data-genuitec-lp-enabled="false" data-genuitec-file-id="wc1-33" data-genuitec-path="/WormExp/WebRoot/useage.jsp">
         <div id="tab-content">
                                <div id="try"></div>

                                <!-- templates content -->
                                <c:forEach var="item" items="${wetabs}">
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
                        
                        var activeTab;
                        if (jQuery(this).is('span')) {
                                // span
                                activeTab = jQuery(this).attr("id").substring(3);
                        } else {
                                // td, div (IE)
                                activeTab = jQuery(this).find("span").attr("id").substring(3);
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
  </body>
</html>
