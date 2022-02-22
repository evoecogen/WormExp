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
<div align="center" id="headercontainer">

  <!-- Header -->
  <c:set value="${WEB_PROPERTIES['header.links']}" var="headerLinks"/>

  <c:if test="${fn:length(headerLinks) > 0}">
    <%-- Menu appearing at the top right (about, etc..) --%>
    <div id="topnav">
      <c:forEach var="entry" items="${headerLinks}" varStatus="status">
        <c:if test="${status.count != 1}">&nbsp;|&nbsp;</c:if>
        <c:set value="header.links.${entry}" var="linkProp"/>
        <c:choose>
          <c:when test="${!empty WEB_PROPERTIES[linkProp]}">
                  <a href="${WEB_PROPERTIES[linkProp]}">${entry}</a>
          </c:when>
          <c:otherwise>
            <a href="${WEB_PROPERTIES['project.sitePrefix']}/${entry}.shtml">${entry}</a>
          </c:otherwise>
        </c:choose>
      </c:forEach>
    </div>
  </c:if>
  <div id="header">
    <a href="${WEB_PROPERTIES['project.sitePrefix']}" alt="Home" rel="NOFOLLOW"><img id="logo" src="model/images/logo.png" width="45px" height="43px" alt="Logo" /></a>
    <h1><html:link href="${WEB_PROPERTIES['project.sitePrefix']}/"><c:out value="${WEB_PROPERTIES['project.title']}" escapeXml="false"/></html:link></h1>
    <p id="version"><fmt:message key="header.version"/> <c:out value="${WEB_PROPERTIES['project.releaseVersion']}" escapeXml="false"/></span>
    <p><c:out value="${WEB_PROPERTIES['project.subTitle']}" escapeXml="false"/></p>
  </div>

    <!-- Tab Menu -->
  <fmt:message key="${pageName}.tab" var="tab" />
  <div id="menucontainer">
    <ul id="nav">
      <li id="home" <c:if test="${tab == 'begin'}">class="activelink"</c:if>>
        <a href="/${WEB_PROPERTIES['webapp.path']}/begin.do">
          <fmt:message key="menu.begin"/>
        </a>
      </li>
      
    </ul>
  

</div>
<!-- /headMenu.jsp -->
