<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@ page import="java.lang.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:choose>
<c:when test="${!empty TestList}">
<div id="list">
  <div class="listbox">
   <h3>Known list: <c:out value="${TestList.get(1).size()}"/></h3>
   <c:if test="${TestList.get(0).size()!=0}"><a href="Download.do?input=rid">save as a file..</a></c:if>
   <table>
    <c:forEach var="item" items="${TestList.get(1)}" varStatus="status">
     <c:choose>
      <c:when test="${status.count < 100}">
      <tr>
       <td>
         <c:out value="${item}"/>
       </td>
      </tr>
      </c:when>
      <c:when test="${(status.count == TestList.get(1).size()) && (status.count >100) }">
      <tr>
       <td>
       <c:out value="More...see the file!"/>
       </td>
       </tr>
      </c:when>
      <c:otherwise>
      </c:otherwise>
     </c:choose>
    </c:forEach>
   </table>
  </div>
  <div class="listbox">
    <h3>Unknown list: <c:out value="${TestList.get(2).size()}"/></h3>
    <c:if test="${TestList.get(2).size()!=0}"><a href="Download.do?input=wid">save as a file..</a></c:if>
  <table>
    <c:forEach var="item" items="${TestList.get(2)}" varStatus="status">
     <c:choose>
      <c:when test="${status.count < 100}">
      <tr>
       <td>
         <c:out value="${item}"/>
       </td>
      </tr>
      </c:when>
      <c:when test="${(status.count == TestList.get(2).size()) && (status.count >100) }">
      <tr>
       <td>
       <c:out value="More...see the file!"/>
       </td>
       </tr>
      </c:when>
      <c:otherwise>
      </c:otherwise>
     </c:choose>
    </c:forEach>
   </table>
  </div>
</div>
</c:when>
<c:otherwise>
	<p class="error"> There is no id! It might be deleted due to a long time! Please upload a list! </p>
</c:otherwise>
</c:choose>




