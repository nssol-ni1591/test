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
	String cpath = getServletContext().getContextPath();
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

<a href="<%=cpath%>/sessions.html">
<img src="<%=cpath%>/images/code.gif" height=24 width=24 align=right border=0 alt="view code"></a>
<a href="<%=cpath%>/index.html">
<img src="<%=cpath%>/images/return.gif" height=24 width=24 align=right border=0 alt="return"></a>

<h3><%=title%></h3>

<ul>
<li><%=rb.getString("sessions.id") + " " + session.getId()%></li>
<li><%=rb.getString("sessions.created") + " " + new Date(session.getCreationTime())%></li>
<li><%=rb.getString("sessions.lastaccessed") + " " + new Date(session.getLastAccessedTime())%></li>
</ul>

<form action="<%=cpath + "/session"%>" method="POST">
<P><%=rb.getString("sessions.data")%></P>

<b>Sessions:</b>
<table border=1>
<tr>
<td><%=rb.getString("sessions.delflag")%></td>
<td><%=rb.getString("sessions.dataname")%></td>
<td><%=rb.getString("sessions.datavalue")%></td>
</tr>
<c:forEach var="e" items="${map1}">
	<tr>
	<td><input type="checkbox" name="DEL" value="${e.key}"></input></td>
	<td><c:out value="${e.key}"/></td>
	<td><c:out value="${e.value}"/></td>
	</tr>
</c:forEach>
</table>

<p/>
<table>
<tr>
<td><%=rb.getString("sessions.dataname")%></td>
<td><input type="text" size="20" name="dataname"/></td>
</tr>
<tr>
<td><%=rb.getString("sessions.datavalue")%></td>
<td><input type="text" size="20" name="datavalue"/></td>
</tr>
</table>

<p/>
<input type="radio" name="attribute" value="set"/>update session<br/>
<input type="radio" name="attribute" value="remove"/>remove session<br/>
<input type="radio" name="attribute" value="none" checked/>nop<br/>
<p/>
delay time:
<input type="radio" name="delay" value="0"/>0
<input type="radio" name="delay" value="5" checked/>5
<input type="radio" name="delay" value="30"/>30
<input type="radio" name="delay" value="60"/>60
<p/>
<input type="submit"/>
</form>

<b>Requests:</b>
<table border=1>
<tr><td>Key</td><td>Value</td></tr>
<c:forEach var="e" items="${map2}">
	<tr>
	<td><c:out value="${e.key}"/></td>
	<td><c:out value="${e.value}"/></td>
	</tr>
</c:forEach>
</table>

<br/>
<b>Contexts:</b>
<table border=1>
<tr><td>Key</td><td>Value</td></tr>
<c:forEach var="e" items="${map3}">
	<tr>
	<td><c:out value="${e.key}"/></td>
	<td><c:out value="${e.value}"/></td>
	</tr>
</c:forEach>
</table>

</body>
</html>
