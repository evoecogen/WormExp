<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@ page import="com.dem.test.ResultTable" %>
<%@ page import="java.lang.*" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
 
<%
   ResultTable clustab=(ResultTable) request.getSession().getServletContext().getAttribute("clustabs");
   String [] input= request.getParameterValues("Clusselect");
   if(request.getParameterValues("Clusselect")==null)
   {
     out.println("<p class=error> Error: Cluster ID is empty!</p>");
     request.getSession().removeAttribute("listerror");
   }else
   {
	Integer[] sts=clustab.getIndex();
	String [] setname=clustab.getSetname();
	String [] catename=clustab.getCategory();
	String [] reflink=clustab.getRefs();
	String [] infos=clustab.getInfos();
	Integer[] ends=clustab.getCounts();

	out.println("<table"+" id="+"tabbody >");
    out.println("<tr"+" class="+"title"+">");
	out.print("<td>Cluster</td>");
	out.println("<td>TF family"+"</td><td>"+"TF in Worm"+"</td>"+"</td><td>"+"Inferred function"+"</td>"+"</td><td>"+"GO terms"+"</td><td  colspan=5>"+"Logos"+"</td>");
	out.println("</tr>");
	for (int j=0; j<input.length; ++j) {
	    int i=Integer.parseInt(input[j]);
	    if(j%2==0) out.println("<tr class="+"even"+">");
	    else out.println("<tr class="+"odd"+">");
	    String snm="C"+Integer.toString(i+1);
    	out.println("<td>"+"C_"+Integer.toString(i+1)+"</td><td>"+setname[i]+"</td><td>"+catename[i]+"</td><td>"+reflink[i]+"</td><td>"+infos[i]+"</td>");
    	String[] lineVariables = setname[i].split("/");
    	int colsp=lineVariables.length;
    	out.println("<td colspan=5>");
    	for(String s:lineVariables)
    	{
    		if(!s.equals("NA")) out.println("<div class=limg>"+"<img class=limg src=logo/"+snm+"_"+s+".jpg"+" alt="+s+" /><span>"+s+"</span></div>");
    	}
    	out.println("</td>");
    	out.println("</tr>" );
	}
	out.println("</table>");

}
 %>

