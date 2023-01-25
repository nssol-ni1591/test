<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ page import="java.util.Date"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.ResourceBundle" %>
<%@ page import="util.HTMLFilter" %>

<%
	ResourceBundle rb = ResourceBundle.getBundle("LocalStrings",request.getLocale());
	String title = rb.getString("sessions.title");

	@SuppressWarnings("unchecked")
	Map<String, String> map = (Map<String,String>)session.getAttribute("map");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title><%=title%></title>
<style>
	table {
		border-collapse: collapse;
	}
	table th, table td {
		border: solid 1px black;
	}
</style>
</head>
<body bgcolor="white">

<a href="/test/sessions.html">
<img src="/test/images/code.gif" height=24 width=24 align=right border=0 alt="view code"></a>
<a href="/test/index.html">
<img src="/test/images/return.gif" height=24 width=24 align=right border=0 alt="return"></a>

<h3><%=title%></h3>

<ul>
<li><%=rb.getString("sessions.id") + " " + session.getId()%></li>
<li><%=rb.getString("sessions.created") + " " + new Date(session.getCreationTime())%></li>
<li><%=rb.getString("sessions.lastaccessed") + " " + new Date(session.getLastAccessedTime())%></li>
</ul>

<form action="<%=response.encodeURL("/test/session")%>" method="POST">
<P><%=rb.getString("sessions.data")%></P>

<table border=1>
<tr>
<td><%=rb.getString("sessions.delflag")%></td>
<td><%=rb.getString("sessions.dataname")%></td>
<td><%=rb.getString("sessions.datavalue")%></td>
</tr>
<c:forEach var="elm" items="${map}">
	<tr>
	<td><input type="checkbox" name="DEL" value="${elm.key}"></input></td>
	<td><c:out value="${elm.key}"/></td>
	<td><c:out value="${elm.value}"/></td>
	</tr>
</c:forEach>
</table>

<p/>
<table>
<tr>
<td><%=rb.getString("sessions.dataname")%></td>
<td><input type=text size=20 name="dataname"/></td>
</tr>
<tr>
<td><%=rb.getString("sessions.datavalue")%></td>
<td><input type=text size=20 name="datavalue"/></td>
</tr>
</table>

<p/>
<input type="radio" name="attribute" value="set"/>update session<br/>
<input type="radio" name="attribute" value="remove"/>remove session<br/>
<input type="radio" name="attribute" value="none" checked/>nop<br/>
<p/>
<input type="submit"/>
</form>
</body>
</html>
