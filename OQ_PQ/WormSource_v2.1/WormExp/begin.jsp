<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
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
<div id="up-wrap">
  <p><c:out value="${WE_PROPERTIES['we.header.description']}" escapeXml="false" /></p>
</div>
        <div id="boxes">
               <div id="welcome-bochs">
                  <img class="title" src="img/upload.png" title="lists"/>
                        <div class="inner">
                          <h3><c:out value="${WE_PROPERTIES['we.thirdBox.visitedTitle']}" /></h3>
                          <span class="ugly-hack">&nbsp;</span>
                          <p><c:out value="${WE_PROPERTIES['we.thirdBox.description']}" escapeXml="false" /></p>
                          
                                <html:form action="/uploadAction" method="post" enctype="multipart/form-data">
                                <fmt:message key="upload.help"/>
                                       <table>
                                          <tr>
                                           <td class="label">
                                           	 <label>
                                           	 	<fmt:message key="upload.text"/>
                                           	 </label>
                                            </td>
                                            <td>
                                          	<html:textarea styleId="pasteInput" property="text" rows="4" value=""/>
                                          	</td>
                                          </tr>
                                          <tr>
                                          	<td class="label">
                                          		<label><fmt:message key="upload.file"/></label>
                                          	</td>
                                          	<td>
                                          		<html:file styleId="fileInput" property="file"/>
                                            </td>
                                          </tr>
                                          <tr>
                                          	<td class="label">
                                          		<label><fmt:message key="upload.type"/></label>                                             
                                          	</td>
                                          	<td>
                                          		<html:select property="type" >
              										<html:options  collection="weinputtabs" property="value" labelProperty="label"></html:options>
          							 	  		</html:select>
          							 	  	</td>
          							 	  </tr>
          							 	  </table>
          								 <table id="resheader">
											<tr>
												<td class="statistic" colspan=3>Uploading statistics: </td>
											</tr>
											<tr>
     											<td><label>Validate ID: </label></td>
     											<td class="statistic">
     		 									<c:choose>
     		  										<c:when test="${!empty TestList}">
     		 										 <c:out value="${TestList.get(0).size()}"/>
     		 									    </c:when>
     		  									<c:otherwise>
     		 										  
     		 									 </c:otherwise>
     		 									</c:choose>
     		 									</td>
     											<c:if test="${!empty TestList}">
     												<td><a href="javascript:void(0)" onclick="openWindow();"> See details</a></td>
     											</c:if>
     		 									</tr>
     		 									<tr>
     												<td><label>Unknown ID:</label> </td>
     												<td class="statistic">
     		 										<c:choose>
     		  											<c:when test="${!empty TestList}">
     		  												<c:out value="${TestList.get(2).size()}"/> 
     		  											</c:when>
     		  											<c:otherwise>
     		   												
     		 											 </c:otherwise>
     		 										</c:choose>
     												</td>
     												<c:if test="${!empty TestList}">
     													<td>or <a href="Remove.do?input=testid"> Delete</a></td>
     												</c:if>
     											</tr>
     											<tr>
     												<td><label>Background:</label> </td>
     												<td class="statistic">
     		  										<c:choose>
     		 											 <c:when test="${!empty Background}">
     		  												<c:out value="${Background.get(0).size()}"/> 
     		  											</c:when>
     		  										<c:otherwise>
     		   											Default
     		  										</c:otherwise>
     		 										</c:choose>
     												</td>
     												<c:if test="${!empty Background}">
     													<td><a href="Remove.do?input=background"> Reset</a></td>
     												</c:if>
												</tr>

		 									</table>
                                       <div class="bottom">
                                                <center>
                                                        <input id="uploadButton" name="searchSubmit" class="button dark" type="submit" value="Upload"/>
                                                </center>
                                        </div>
                                </html:form>
                                <div style="clear:both;"></div>
                        </div>
                </div>
                
                
                <div id="lists-bochs">
                        <img class="title" src="img/lists-64.png" title="lists"/>
                        <div class="inner">
                                <h3><c:out value="${WE_PROPERTIES['we.listBox.title']}" /></h3>
                                <span class="ugly-hack">&nbsp;</span>
                                <p><c:out value="${WE_PROPERTIES['we.listBox.description']}" escapeXml="false" /></p>

                                 <html:form  method="post" action="/AnalysisAction" onsubmit="analysisSubmit(this)">
                                <table id="tabbody">  
                                <tr class="titlec">
                                <td>Category</td><td>Number</td>
                                </tr>      
                                 <c:set var="sumup" value="${0}"/>              
                                 <c:forEach var="item" items="${wetabs}">
                                        <tr>
                                        <td>
                                         <c:set var="row" value="${wetabs.get(item.key)}"/>
                                            <input type="checkbox" name="dataset" value="${row.get('identifier')}" ><c:out value="${row.get('name')}"/>
                                            
                                        </td>
                                        <td>#<c:out value="${row.get('number')}"/> </td>
                                        <c:set var="sumup" value="${sumup + row.get('number')}"/>
                                        </tr>
                                    </c:forEach>
                                    <tr class="titlec"><td>In total</td><td>#<c:out value="${sumup}"/></td></tr>
                                 </table>
                                 <div class="bottom">
                                      <center>
                                         <input class="button dark" type="submit" value="analyse"/>
                                      </center>
                                 </div>
                                </html:form>
                        </div>
                </div>
                <div id="search-bochs">
                        <div class="inner">
                           <div class="partu">
                           <img class="title" src="img/search-ico-right.png" title="search"/>
                                <h3><c:out value="${WE_PROPERTIES['we.searchBox.title']}" /></h3>
                                <span class="ugly-hack">&nbsp;</span>
                                <p><c:out value="${WE_PROPERTIES['we.searchBox.description']}" escapeXml="false" /></p>

                                <form action="<c:url value="/KeywordsSearch.do" />" method="get" onsubmit="analysisSubmit(this)">
                                        <div class="input"><input id="actionsInput" name="searchTerm" class="input" type="text" value="e.g. ${WE_PROPERTIES['we.searchBox.example']}"></div>
                                        <div class="bottom1">
                                                <center>                  
                                         				<input id="mainSearchButton" name="searchSubmit" class="button dark" type="submit" value="search"/>
                                                </center>
                                        </div>
                                </form>
                                <div style="clear:both;"></div>
                            </div>
                                <h3><c:out value="${WE_PROPERTIES['we.download.title']}" /></h3>
                                <p><c:out value="${WE_PROPERTIES['we.download.description']}" escapeXml="false" /></p>

                                <form action="<c:url value="/Download.do" />" name="search" method="get">
                                        <div class="bottom">
                                                <center>
                                                        <input id="downloadButton" name="input" class="button dark" type="submit" value="dataset"/>
                                                </center>
                                        </div>
                                </form>
                                <div style="clear:both;"></div>
                        </div>
                  
                </div>

        </div>

        <div style="clear:both"></div>
        
        <div id="bottom-wrap">
		 <c:choose>
			  		      <c:when test="${!empty uploadingerror}"> 						
          							 	    <p class="error">Error:&nbsp${uploadingerror} </p>
          							 	    <%
          							 	      request.getSession().removeAttribute("uploadingerror");
          							 	     %>
          				  </c:when>
          				  <c:when test="${!empty listerror}"> 						
          							 	    <p class="error">Error:&nbsp${listerror} </p>
          							 	    <%
          							 	      request.getSession().removeAttribute("listerror");
          							 	     %>
          				  </c:when>
          				  <c:when test="${!empty removeerror}"> 						
          							 	    <p class="error">Error:&nbsp ${removeerror} </p>
          							 	    <%
          							 	      request.getSession().removeAttribute("removeerror");
          							 	     %>
          				  </c:when>
          				  <c:when test="${!empty downloadingingerror}"> 						
          							 	    <p class="error">Error:&nbsp ${downloadingingerror} </p>
          							 	    <%
          							 	      request.getSession().removeAttribute("downloadingingerror");
          							 	     %>
          				  </c:when>
          				    <c:when test="${!empty searcherror}"> 						
          							 	    <p class="error">Error:&nbsp ${searcherror} </p>
          							 	    <%
          							 	      request.getSession().removeAttribute("searcherror");
          							 	     %>
          				  </c:when>
          				  <c:otherwise>
          				  <p class="error">&nbsp</p>
          				  </c:otherwise>
         </c:choose>
        </div>
        <div id="bottom-wrap">
            <c:if test="${!empty wetabs}">
                <div id="templates">
                        <table id="menu" border="0" cellspacing="0">
                                <tr>
                                    <!-- templates tabs -->
                                    <c:forEach var="item" items="${wetabs}">
                                        <td><div class="container"><span id="tab${item.key}">
                                            <c:forEach var="row" items="${item.value}">
                                                <c:choose>
                                                    <c:when test="${row.key == 'template'}">
                                                        <c:out value="${row.value}" />
                                                    </c:when>
                                                </c:choose>
                                            </c:forEach>
                                        </span></div></td>
                                    </c:forEach>
                                </tr>
                        </table>

                        <div id="tab-content">
                                <div id="ribbon"></div>
                                <div id="try"></div>

                                <!-- templates content -->
             
                                <c:forEach var="item" items="${wetabs}">
                                    <c:set var="refs" value="null"/>
                                    <div id="content${item.key}" class="content">
                                        <c:forEach var="row" items="${item.value}">
                                            <c:choose>
                                                <c:when test="${row.key == 'name'}">
                                                    <p><strong><c:out value="${row.value}" /></strong></p>
                                                    <c:if test="${row.value == 'Kim Mountains'}">
                                                       <c:set var="refs" value="true"/>
                                                    </c:if>
                                                </c:when>
                                                <c:when test="${row.key == 'description'}">
                                                    <p>${row.value}
                                                      <c:if test="${refs == 'true'}">
                                                       <c:set var="refs" value="null"/>
                                                       <a href="http://www.ncbi.nlm.nih.gov/pubmed/11557892"> Kim et al., 2001. Science</a>.
                                                      </c:if>
                                                    </p><br/>
                                                </c:when>
                                            </c:choose>
                                        </c:forEach>
                                    </div>
                                </c:forEach>
                        </div>
                </div>
            </c:if>



        </div>
</div>

<script type="text/javascript">
        jQuery(document).ready(function() {
                jQuery("#tab-content .content").each(function() {
                        jQuery(this).hide();
                });
                jQuery("input#mainSearchButton").attr("disabled","disabled");
                  $("input#actionsInput").keyup(function(){
       					 if($(this).val().length !=0)
            			 $('input#mainSearchButton').attr('disabled', false);            
        				 else
            				$('input#mainSearchButton').attr('disabled',true);
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
  

        // register input elements with blur & focus
        jQuery('input#actionsInput').blur(function() {
                if (jQuery(this).val() == '') {
                        jQuery(this).toggleClass(inputToggleClass);
                        jQuery(this).val(placeholder);
                }
        });
        
        jQuery('input#actionsInput').focus(function() {
                if (jQuery(this).hasClass(inputToggleClass)) {
                        jQuery(this).toggleClass(inputToggleClass);
                        jQuery(this).val('');
                }
        });
        
</script>

<!-- /begin.jsp -->
