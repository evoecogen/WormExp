<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@ page import="com.dem.test.ResultTable" %>
<%@ page import="java.lang.*" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
 

<%
   	int topcount=10,restsize=0; 
   	double pcut=0.2;
 	if(request.getParameter("escore")!=null) pcut=Double.parseDouble(request.getParameter("escore"));
	if(request.getParameter("top")!=null) topcount=Integer.parseInt(request.getParameter("top"));
	request.setAttribute("topcount", topcount);
	request.setAttribute("pcut", pcut);
	String [] tfsetname=null;
		//String [] tfcatename=rts.getCategory();
	String [] tfreflink=null;
	Integer[] tfcounts=null;
	Integer[] tfinds=null;
		//Double[] tfbf=rts.getBonferroni();
	Double[] tfbh=null;
	String[] pns={"Positive","Negative"};
	LinkedHashMap<String, ResultTable> rtc=null;
	ResultTable clustab =null, rts=null;
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
   	rtc=(LinkedHashMap<String, ResultTable>)request.getSession().getAttribute("ResultsTable");
   	clustab=(ResultTable) request.getSession().getServletContext().getAttribute("clustabs");
   	rts=rtc.get("tfs");
	if(rts!=null)
	{
        tfsetname=rts.getSetname();
		//String [] tfcatename=rts.getCategory();
        tfreflink=rts.getRefs();
		tfcounts=rts.getCounts();
		tfinds=rts.getIndex();
		//Double[] tfbf=rts.getBonferroni();
		tfbh=rts.getBH();
		restsize=tfbh.length;
	}else{
	 out.println("<p class=error> Error:"+"transcription factor results might be removed due to a long time!</p>");
	}
  }
   String varMC="<graphml><key id="+"\"label\""+" for="+"\"all\""+" attr.name="+"\"label\""+" attr.type="+"\"string\""+"/>"
				+ "<key id="+"\"weight\""+" for="+"\"node\""+" attr.name="+"\"weight\""+" attr.type="+"\"double\""+"/>"
				+ "<key id="+"\"d1\""+" for="+"\"node\""+" attr.name="+"\"shape\""+" attr.type="+"\"string\""+"/>"
				+ "<key id="+"\"d0\""+" for="+"\"all\""+" attr.name="+"\"color\""+" attr.type="+"\"string\""+"/>"
				+"<graph edgedefault="+"\"directed\">"
				+"<node id="+"\"1\""+">"
				+"<data key="+"\"label\""+">Input</data>"+"<data key="+"\"weight\""+">2.5</data>"+"<data key="+"\"d0\""+">3</data>"+"<data key="+"\"d1\""+">2</data>"
				+"</node>";
		String nod="",edg="";
	for(int j=0;j<restsize;j++)
	{
	    if(Math.abs(tfbh[j])<pcut) continue;
		String stats=tfreflink[j];
		String signf="1";
		if(stats.equals("")) signf="2";
		nod=nod+"<node id="+"\""+(j+2)+"\""+">"
			+"<data key="+"\"label\""+">"+tfsetname[j]+"</data>"+"<data key="+"\"weight\""+">1</data>"+"<data key="+"\"d0\""+">"+signf+"</data>"+"<data key="+"\"d1\""+">1</data>"
			+"</node>";
		signf="1";
		if(tfcounts[j]==1) signf="2";
		edg=edg+"<edge source="+"\"1\""+" target="+"\""+(j+2)+"\""+">"+"<data key="+"\"d0\""+">"+signf+"</data>"+
				"</edge>";
	}
	varMC=varMC+nod+edg+"</graph>"+"</graphml>";

%>
 <head data-genuitec-lp-enabled="false" data-genuitec-file-id="wc1-17" data-genuitec-path="/WormExp/WebRoot/tfstable.jsp">
        <title>Cytoscape TFs</title>
        <script type="text/javascript" src="http://code.jquery.com/jquery-1.7.1.min.js"></script>

        <script type="text/javascript" src="js/min/json2.min.js"></script>
        <script type="text/javascript" src="js/min/AC_OETags.min.js"></script>
        <script type="text/javascript" src="js/min/cytoscapeweb.min.js"></script>
        
        
        <script type="text/javascript">
            window.onload = function() 
            {
               
               var div_id = "cytoscapeweb";
               var visual_style = {
                    global: {
                        backgroundColor: "#F8F8F8"
                    },
                    nodes: {
                        shape: {
                        discreteMapper: {
                                attrName: "shape",
                                entries: [
                                    { attrValue: 1, value: "ELLIPSE" },
                                    { attrValue: 2, value: "OCTAGON" },
                                    { attrValue: 3, value: "HEXAGON" }
                                ]
                            }
                        },
                        borderWidth: 3,
                        borderColor: "#ffffff",
                        size: {
                            defaultValue: 45,
                            continuousMapper: { attrName: "weight", minValue: 45, maxValue: 85 }
                        },
                      color: {
                            discreteMapper: {
                                attrName: "color",
                                entries: [
                                    { attrValue: 1, value: "#9A0B0B" },
                                    { attrValue: 2, value: "#0B94B1" },
                                    { attrValue: 3, value: "#dddd00" }
                                ]
                            }
                        },
                        labelHorizontalAnchor: "center",
                        labelFontWeight: "bold"
                    },
                    edges: {
                        width: 3,
                        color: {
                            discreteMapper: {
                                attrName: "color",
                                entries: [
                                    { attrValue: 1, value: "#9A0B0B" },
                                    { attrValue: 2, value: "#0B94B1" },
                                    { attrValue: 3, value: "#dddd00" }
                                ]
                            }
                        }
                    }
                };
               var xml = '<%=varMC%>';
               
               var options =
               {
                    swfPath: "swf/CytoscapeWeb",
                    flashInstallerPath: "swf/playerProductInstall"
                };
                
                var vis = new org.cytoscapeweb.Visualization(div_id, options);
                vis.draw({ network: xml,
                     edgeLabelsVisible: true,
                     layout: "CompoundSpringEmbedder",
                     visualStyle: visual_style,
                     // hide pan zoom
                     panZoomControlVisible: false 
                     });
              };
        </script>
        
        <style>
            /* The Cytoscape Web container must have its dimensions set. */
            html, body { height: 100%; width: 100%; padding: 0; margin: 0; }
            #cytoscapeweb {width: 630px;float: left;margin-right: 0px; position: relative;padding: 0 0px;}
        </style>
    <script>"undefined"==typeof CODE_LIVE&&(!function(e){var t={nonSecure:"54343",secure:"54344"},c={nonSecure:"http://",secure:"https://"},r={nonSecure:"127.0.0.1",secure:"gapdebug.local.genuitec.com"},n="https:"===window.location.protocol?"secure":"nonSecure";script=e.createElement("script"),script.type="text/javascript",script.async=!0,script.src=c[n]+r[n]+":"+t[n]+"/codelive-assets/bundle.js",e.getElementsByTagName("head")[0].appendChild(script)}(document),CODE_LIVE=!0);</script></head> 

<form id="headerform" action="TFsTable.do" method="get">

<table id="resheader">
<tr>
     <td><label>Top</label> </td>
     <td><input class='options' type='text' name="top" value="${topcount}" /></td>
     <td><label>EnrichScore</label> </td>
     <td><input class='options' type='text' name="escore" value="${pcut}" /></td>
     <td><input type="submit" value="Refresh the results"/> will update the result as below!</td>
</tr>
</table>
</form>
<%	
	if(rts!=null)
	{
		out.println("<div"+" id="+"cytoscap >");
		out.println("<div"+" id="+"tablef >");
		out.println("<table"+" id="+"tabbody >");
		
		out.println("<tr>");
		out.println("<td colspan=2>"+"Top of enriched TFs: "+topcount+"</td><form action='Download.do' method='POST'><td colspan=2>"+"<input id='idselect' name='input'  type='submit' value='DownloadTFs'/>"+"</form></td>");
	    out.println("</tr>");


		out.println("<tr"+" class="+"title"+">");
		out.print("<td>"+"TF name"+"</td>");
		out.println("<td>Regulation"+"</td><td>"+"Realdata"+"</td><td>"+"EnrichScore"+"</td>");
		out.println("</tr>");
		int bufcount=0;
		for (int i=0; i<tfsetname.length; ++i) {
		    if(Math.abs(tfbh[i])>pcut)
		    {
			bufcount++;
	    	if(bufcount%2==0) out.println("<tr class="+"even"+">");
	   	    else out.println("<tr class="+"odd"+">");
    		out.print("<td>"+tfsetname[i]+"</td>");
    		out.print("<td>"+pns[tfcounts[i]]+"</td>");
    		out.print("<td>"+tfreflink[i]+"</td>");
    		out.print("<td>"+String.format("%.2g",tfbh[i])+"</td>");
    		out.println("</tr>" );
    		if(bufcount>topcount) break;
    		}
		}
	out.println("<tr>");
	out.println("<td colspan=2>"+"Total of Clusters: "+tfinds.length+"</td><form target='_blank' action='ShowCluster.do' method='POST'><td colspan=2>"+"<input id='idselect' name='input'  type='submit' value='Showdetails'/>"+"</td>");
	out.println("</tr>");
    out.println("<tr"+" class="+"title"+">");
	out.print("<td><input type='checkbox' id='checkAll' checked>Cluster</td>");
	out.println("<td>TF family"+"</td><td>"+"TF in Worm"+"</td><td>"+"Ref function"+"</td>");
	out.println("</tr>");
	String [] ccate=clustab.getCategory();
	String [] cnam=clustab.getSetname();
	String [] cfunc=clustab.getRefs();
	for (int j=0; j<tfinds.length; ++j) {
	    int i=tfinds[j];
	    String clinks="ShowCluster.do?Clusselect="+Integer.toString(i);
	    if(j%2==0) out.println("<tr class="+"even"+">");
	    else out.println("<tr class="+"odd"+">");
    	out.print("<td><input type='checkbox' name='Clusselect' class='set-element' value='"+i+"' checked><a href="+clinks+" target=_blank>C"+Integer.toString(i+1)+"</a></td>");
    	out.println("<td>"+cnam[i]+"</td><td>"+ccate[i]+"</td><td>"+cfunc[i]+"</td>");
    	out.println("</tr>" );
	}
	out.println("</form></table></div>");
	out.println("<div id="+"cytoscapeweb"+"> </div></div>");
	}
 %>
<script type="text/javascript">
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
