<%@ tag import="java.util.*" %>
<%@ tag import="org.apache.struts.util.LabelValueBean" %>
<%@ tag import="com.AMD.util.*" %>

<%
      String [] ESTIMATE_CD=com.AMD.util.Collection.value;
      ESTIMATE_CD[0]="${WEB_PROPERTIES['begin.tabs.1.id']}";
      Vector vecESTIMATE_CD=new Vector();
      vecESTIMATE_CD.add(new org.apache.struts.util.LabelValueBean("",""));
      for(int i=0;i<ESTIMATE_CD.length;i++)
      {
        vecESTIMATE_CD.add(new LabelValueBean(ESTIMATE_CD[i],String.valueOf(i)));
      }
      request.setAttribute("ESTIMATE_CD",vecESTIMATE_CD);
     %>
