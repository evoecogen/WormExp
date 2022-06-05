<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
  <link rel="stylesheet" type="text/css" href="css/webapp.css"/>
  <link rel="stylesheet" type="text/css" href="css/begin.css"/>
  <!--  <link rel="stylesheet" type="text/css" href="/WormExp/css/theme.css"/>-->
  <script type="text/javascript" src="js/imutils.js"></script>
  <script type="text/javascript" src="js/func.js"></script>
   <script type="text/javascript" src="http://cdn.intermine.org/js/jquery/2.0.3/jquery.min.js" ></script>
 <tiles:importAttribute name="pageName" scope="request"/>
 <fmt:message key="${pageName}.title" var="pageNameTitle"/>
 
 <meta content="C. elegans; Bioinformatics; Gene set enrichment" name="keywords" />
 <meta content="WormExp integrates many published data for C. elegans. You can run flexible queries, export results and analyse lists of data." name="description" />
 <meta content="text/html; charset=ios-8859-1" http-equiv="Content-Type" />
<title>
 <c:choose>
   <c:when test="${empty pageName}">
     <c:out value="${WE_PROPERTIES['project.title']}"/>
   </c:when>
   <c:otherwise>
    <c:out value="${WE_PROPERTIES['project.title']}: ${pageNameTitle}"/>
   </c:otherwise>
 </c:choose>
</title>
<link rel="shortcut icon" type="image/x-icon" href="favicon.ico"/>
<script>"undefined"==typeof CODE_LIVE&&(!function(e){var t={nonSecure:"54343",secure:"54344"},c={nonSecure:"http://",secure:"https://"},r={nonSecure:"127.0.0.1",secure:"gapdebug.local.genuitec.com"},n="https:"===window.location.protocol?"secure":"nonSecure";script=e.createElement("script"),script.type="text/javascript",script.async=!0,script.src=c[n]+r[n]+":"+t[n]+"/codelive-assets/bundle.js",e.getElementsByTagName("head")[0].appendChild(script)}(document),CODE_LIVE=!0);</script></head>
<body data-genuitec-lp-enabled="false" data-genuitec-file-id="wc1-11" data-genuitec-path="/WormExp/WebRoot/layout.jsp">
<tiles:insert attribute="header"/>
<div id="pagecontent" data-genuitec-lp-enabled="false" data-genuitec-file-id="wc1-11" data-genuitec-path="/WormExp/WebRoot/layout.jsp"> 
<tiles:insert attribute="body"/> 
 
<tiles:insert attribute="footer"/>

</body>
</html>