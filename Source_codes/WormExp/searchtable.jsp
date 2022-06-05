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
    out.println("<p class=error> There is no result! It might be deleted due to a long time or wrong kewwords! Please upload list and run the search again! </p>");
    }
   }else
   {
	ResultTable rt=(ResultTable)request.getSession().getAttribute("SearchTable");
	Boolean vterm=rt.getVterms();
	if(vterm)
	{
	  ArrayList <String> colnames=rt.getColnames();
	  Integer[] counts=rt.getCounts();
	  int setsize=colnames.size();
	  out.println("<form action='Download.do' method='POST'>");
	  out.println("<table"+" id="+"tabbody >");


      out.println("<tr>");
	  out.println("<td colspan=1>"+"Total of Dataset: "+setsize+"</td><td colspan=1>"+"<input id='idselect' name='input'  type='submit' value='DownloadSet'/>"+"</td>");
	  out.println("</tr>");

	  out.println("<tr"+" class="+"title"+">");
	  out.print("<td><input type='checkbox' id='checkAll' checked>");
	  out.println("SetID(select/unselect all)</td><td>Setsize</td>");
	  out.println("</tr>");
	
	  for (int j=0; j<setsize; ++j) {
	    if(j%2==0) out.println("<tr class="+"even"+">");
	    else out.println("<tr class="+"odd"+">");
	    out.print("<td><input type='checkbox' name='Setselect' class='set-element' value='"+colnames.get(j)+"' checked>");
	    out.println(colnames.get(j)+"</td><td>"+counts[j]+"</td>");
    	out.println("</tr>" );
		}
	out.println("</table></form>");
	}else{
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
}
 %>

<script type="text/javascript" data-genuitec-lp-enabled="false" data-genuitec-file-id="wc1-13" data-genuitec-path="/WormExp/WebRoot/searchtable.jsp">
$("#checkAll").change(function () {
    $("input:checkbox.set-element").prop('checked', $(this).prop("checked"));
});
$(".set-element").change(function () {
		_tot = $(".set-element").length						  
		_tot_checked = $(".set-element:checked").length;
		
		if(_tot != _tot_checked){
			$("#checkAll").prop('checked',false);
		}
});
</script>
