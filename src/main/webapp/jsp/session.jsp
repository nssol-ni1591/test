<%@ page contentType="text/html; charset=UTF-8" %>

<%@ page import="java.util.Date"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.ResourceBundle" %>
<%@ page import="util.HTMLFilter" %>

<%
	ResourceBundle rb = ResourceBundle.getBundle("LocalStrings",request.getLocale());
	String title = rb.getString("sessions.title");
	String session_id = rb.getString("sessions.id") + " " + session.getId();
	String session_created = rb.getString("sessions.created") + " " + new Date(session.getCreationTime());
	String session_lastaccessed = rb.getString("sessions.lastaccessed") + " " + new Date(session.getLastAccessedTime());

	@SuppressWarnings("unchecked")
	Map<String, String> map = (Map<String,String>)session.getAttribute("map");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title><%=title%></title>
</head>
<body bgcolor="white">

<a href="/test/sessions.html">
<img src="/test/images/code.gif" height=24 width=24 align=right border=0 alt="view code"></a>
<a href="/test/index.html">
<img src="/test/images/return.gif" height=24 width=24 align=right border=0 alt="return"></a>

<h3><%=title%></h3>

<%=rb.getString("sessions.id") + " " + session.getId()%>
<br>
<%=rb.getString("sessions.created") + " " + new Date(session.getCreationTime())%>
<br>
<%=rb.getString("sessions.lastaccessed") + " " + new Date(session.getLastAccessedTime())%>
<br>
<P>
<form action="<%=response.encodeURL("/test/session")%>" method="POST">
<P>
<%=rb.getString("sessions.data")%><br>

<table border=1>
<tr>
<th><%=rb.getString("sessions.delflag")%></th>
<th><%=rb.getString("sessions.dataname")%></th>
<th><%=rb.getString("sessions.datavalue")%></th>
</tr>
<% 
	if (map == null) { }
	else for (String key : map.keySet()) {
		String val = map.get(key);
%>
<tr>
<td><input type="checkbox" name="DEL" value="<%=key%>"></input></td>
<td><%=key%></td>
<td><%=val%></td>
</tr>
<%
	}
%>
</table>

<p>
<%=rb.getString("sessions.dataname")%>
<input type=text size=20 name="dataname">
<br/>
<%=rb.getString("sessions.datavalue")%>
<input type=text size=20 name="datavalue"
><br/>
<input type="radio" name="attribute" value="set"/>update session<br/>
<input type="radio" name="attribute" value="remove"/>remove session<br/>
<input type="radio" name="attribute" value="none" checked/>nop
</p>
<input type=submit>
</form>
</body>
</html>
