<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@ page import="com.dem.test.ResultTable" %>
<%@ page import="java.lang.*" %>

<%
   if(request.getSession().getAttribute("searcherror")!=null)
   {
      out.println("<p class=error> Error: "+request.getSession().getAttribute("searcherror")+"</p>");
      request.getSession().removeAttribute("searcherror");
   }
   else if(request.getSession().getAttribute("SearchTable")==null)
   {
    if(request.getSession().getAttribute("searchtablenull")!=null)
    {
      out.println("<p class=error> There is no result! Please check the key words and input gene ids! </p>");
      request.getSession().removeAttribute("searchtablenull");
    }else{
    out.println("<p class=error> There is no result! It might be deleted due to a long time! Please upload list and run the search again! </p>");
    }
   }else
   {
	ResultTable rt=(ResultTable)request.getSession().getAttribute("SearchTable");
	ArrayList <String> colnames=rt.getColnames();
	ArrayList <String> rownames=rt.getRownames();
	Integer[][] indicators=rt.getIndicator();
	int setsize=colnames.size(),gsize=rownames.size();
	out.println("<table"+" id="+"tabbody >");


    out.println("<tr>");
	out.println("<td colspan=6>"+"Total of Dataset: "+setsize+"</td><td colspan=3>"+"<a href="+"Download.do?input=search"+">"+"Download this table..."+"</a>"+"</td>");
	out.println("</tr>");

	out.println("<tr"+" class="+"title"+">");
	out.println("<td>GeneID</td>");
	int pcol=setsize>6?6:setsize, prow=gsize>100?100:gsize;
	for(int i=0;i<pcol;i++) out.println("<td>"+colnames.get(i)+"</td>");
	if(pcol!=setsize) out.println("<td> More in file...</td>");
	out.println("</tr>");
	
	for (int j=0; j<prow; ++j) {
	    if(j%2==0) out.println("<tr class="+"even"+">");
	    else out.println("<tr class="+"odd"+">");
	    out.println("<td>"+rownames.get(j)+"</td>");
	    for(int i=0;i<pcol;i++)
	    {
	     out.println("<td>"+indicators[j][i]+"</td>");
	    }
	    if(pcol!=setsize) out.println("<td>...</td>");
    	out.println("</tr>" );
		}
	if(gsize!=prow){
	    out.println("<td>"+"More in file..."+"</td>");
	    for(int i=0;i<pcol;i++)
	    {
	     out.println("<td>"+"..."+"</td>");
	    }
	    if(pcol!=setsize) out.println("<td>...</td>");
	}
	
out.println("</table>");
}
 %>


