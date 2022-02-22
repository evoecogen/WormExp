<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@ page import="com.dem.test.ResultTable" %>
<%@ page import="java.lang.*" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
   int cutcount=2;
   double pcut=0.1, fdr=pcut, pval=2.0, benj=2.0;
   String thres="fdr";
 	if(request.getParameter("pcut")!=null) pcut=Double.parseDouble(request.getParameter("pcut"));
 	fdr=pcut;
	if(request.getParameter("count")!=null) cutcount=Integer.parseInt(request.getParameter("count"));
	if(request.getParameter("threshold")!=null) thres=(String)request.getParameter("threshold");
	if(thres.equals("bonferroni"))
	{
	 fdr=pval=2.0;
	 benj=pcut;
	}
	if(thres.equals("pvalue"))
	{
	 fdr=benj=2.0;
	 pval=pcut;
	}
	request.setAttribute("cutcount", cutcount);
	request.setAttribute("pcut", pcut);
	request.setAttribute("threshold", thres);
%>
<form id="headerform" action="ResTable.do" method="get">
<table id="resheader">
<tr>
     <td><label>Thresholds:</label></td>
     <td><label>Count</label> </td>
     <td><input class='options' type='text' name="count" value="${cutcount}" /></td>
     <td><label>Probability</label> </td>
     <td>
        <select name="threshold">
  		<option value="fdr">FDR</option>
  		<c:choose>
          <c:when test="${threshold.equals('bonferroni')}">
            <option value="bonferroni" selected="selected">Bonferroni</option>
          </c:when>
          <c:otherwise>
            <option value="bonferroni">Bonferroni</option>
          </c:otherwise>
        </c:choose>
  		<c:choose>
          <c:when test="${threshold.equals('pvalue')}">
            <option value="pvalue" selected="selected">P-value</option>
          </c:when>
          <c:otherwise>
            <option value="pvalue">P-value</option>
          </c:otherwise>
        </c:choose>  		
		</select> 
     </td>
     <td><input class='options' type='text' name='pcut' value="${pcut}" /></td>
     <td><input type="submit" value="Refresh the results"/> will update the result as below!</td>
</tr>
</table>
</form>
<%
   if(request.getSession().getAttribute("listerror")!=null)
   {
     out.println("<p class=error> Error:"+request.getSession().getAttribute("listerror") +"Might be removed due to a long time!</p>");
     request.getSession().removeAttribute("listerror");
   }
   else if(request.getSession().getAttribute("ResultsTable")==null)
   {
    out.println("<p class=error> There is no result! It might be deleted due to a long time! Please upload list and run the analysis again! </p>");
   }else
   {
	ResultTable rt=(ResultTable)request.getSession().getAttribute("ResultsTable");
	Integer[] index=rt.getIndex();
	String [] setname=rt.getSetname();
	String [] catename=rt.getCategory();
	String [] reflink=rt.getRefs();
	Integer[] counts=rt.getCounts();
	Integer[] sizeofset=rt.getSizeofSet();
	int popsize=rt.getPopsize();
	int setsize=rt.getSetsize();
	Double[] pvalue=rt.getPvalue();
	Double[] bf=rt.getBonferroni();
	Double[] bh=rt.getBH();
	Integer sszie=rt.getTestSize();
	
	out.println("<table"+" id="+"tabbody >");


    out.println("<tr>");
	 out.println("<td colspan=6>"+"Total of Dataset: "+setsize+"</td><td colspan=3>"+"<a href="+"Download.do?input=enrich"+">"+"Download this table..."+"</a>"+"</td>");
	out.println("</tr>");

	out.println("<tr"+" class="+"title"+">");
	out.println("<td>"+"Category"+"</td><td>"+"Term"+"</td><td>"+"Counts"+"</td><td>"+"ListSize"+"</td><td>"+"PopHit"+"</td><td>"+"Pop Size"+"</td><td>"+"Pvalue"+"</td><td>"+"Bonferroni"+"</td><td>"+"FDR"+"</td>");
	out.println("</tr>");
	for (int j=0; j<index.length; ++j) {
	    int i=index[j];
	    if(pvalue[i]<pval && counts[i]>=cutcount && bf[i]<benj && bh[i]<fdr)
	    {
	    if(j%2==0) out.println("<tr class="+"even"+">");
	    else out.println("<tr class="+"odd"+">");
	    
    	out.println("<td>"+catename[i]+"</td>"+"<td>"+"<a href="+reflink[i]+" target=_blank>"+setname[i]+"</a></td><td>"+counts[i]+"</td><td>"+sszie+"</td><td>"+sizeofset[i]+"</td><td>"+popsize+"</td><td>"+String.format("%.2g",pvalue[i])+"</td><td>"+String.format("%.2g",bf[i])+"</td><td>"+String.format("%.2g",bh[i])+"</td>");
    	out.println("</tr>" );
		}
		}

out.println("</table>");
}
 %>


