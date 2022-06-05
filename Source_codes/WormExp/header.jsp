<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="im"%>

<!-- headMenu.jsp -->
<html:xhtml/>

<tiles:importAttribute name="fixedLayout" ignore="true" />

<!-- Header container -->
<div align="center" id="headercontainer" data-genuitec-lp-enabled="false" data-genuitec-file-id="wc1-9" data-genuitec-path="/WormExp/WebRoot/header.jsp">

  <!-- Header -->

  <div id="header">
    <a href="/" alt="Home" rel="NOFOLLOW"><img id="logo" src="img/logo.png" width="45px" height="43px" alt="Logo" /></a>
    <h1><html:link href="${WE_PROPERTIES['project.sitePrefix']}"><c:out value="${WE_PROPERTIES['project.title']}" escapeXml="false"/></html:link></h1>
    <p id="version"><fmt:message key="header.version"/> <c:out value="${WE_PROPERTIES['project.ver']}" escapeXml="false"/>
    <p><c:out value="${WE_PROPERTIES['project.subTitle']}" escapeXml="false"/></p>
  </div>

    <!-- Tab Menu -->
  <fmt:message key="${pageName}.tab" var="tab" />
  <div id="menucontainer">
    <ul id="nav">
      <li id="home" <c:if test="${tab == 'begin'}">class="activelink"</c:if>>
        <a href="/">
          <fmt:message key="menu.begin"/>
        </a>
      </li>
      
    </ul>
  

</div>

<!-- /headMenu.jsp -->
