<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- footer.jsp -->


<div class="body" align="center" style="clear:both">
    <!-- contact -->
    <c:if test="${pageName != 'contact'}">
        <div id="contactFormDivButton">
            <div class="contactButton">
                <a href="mailto:wyang@zoologie.uni-kiel.de" target="_top">
                    <b><fmt:message key="feedback.title"/></b>
                </a>
            </div>
        </div>
    </c:if>
    <br/>

        <!-- powered -->
        <p>Powered by</p>
        <a target="new" href="http://intermine.org" title="InterMine">
            <img src="/WormExp/img/intermine-footer-logo.png" alt="InterMine logo" />
        </a>
    </div>

</div>

<div class="body bottom-footer">

    <ul class="footer-links">
        <!-- contact us form link -->
        <li><a href="mailto:wyang@zoologie.uni-kiel.de" target="_top">Contact Us</a></li>
    </ul>

    <!-- mines -->
    <ul class="footer-links">
        <li><a href="http://www.intermine.org" target="_blank">InterMine</a></li>
        <li><a href="http://www.uni-kiel.de/zoologie/evoecogen/" target="_blank">EvoEcoGen</a></li>
    </ul>


    <div style="clear:both"></div>
</div>
<!-- /footer.jsp -->