<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.stream.*"%>
<%@ page import="util.Attribute" %>

<%
	ServletContext context = request.getServletContext();
	HttpSession session0 = request.getSession();
	String url = request.getAttribute("url") == null 
		? context.getContextPath() + "/jsp/session.jsp"
		: request.getAttribute("url").toString();
	String delay = request.getAttribute("delay") == null 
		? "5" 
		: request.getAttribute("delay").toString();

	List<Attribute> headers = new ArrayList<>();
	Collections.list(request.getHeaderNames())
		.forEach(key -> headers.add(new Attribute(key, request.getHeaders(key))));

	List<Attribute> params = new ArrayList<>();
	Collections.list(request.getParameterNames())
		.forEach(key -> params.add(new Attribute(key, request.getParameterValues(key))));

	List<Attribute> sessions = new ArrayList<>();
	Collections.list(session0.getAttributeNames())
		.forEach(key -> sessions.add(new Attribute(key, session0.getAttribute(key))));

	List<Attribute> contexts = new ArrayList<>();
	Collections.list(context.getAttributeNames())
		.forEach(key -> contexts.add(new Attribute(key, context.getAttribute(key))));

	List<Attribute> requests = new ArrayList<>();
	Collections.list(request.getAttributeNames())
		.forEach(key -> requests.add(new Attribute(key, request.getAttribute(key))));
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<meta http-equiv="refresh" content="<%=delay%>;URL='<%=url%>'" />
<title>Redirect</title>
</head>

<body>
<h1>Parameters:</h1>
<table>
<c:forEach var="e" items="<%=params%>">
<tr>
<td nowrap>${e.key}</td>
<td>${e.value}</td>
</tr>
</c:forEach>
</table>

<h1>Sessions:</h1>
<table>
<c:forEach var="e" items="<%=sessions%>">
<tr>
<td nowrap>${e.key}</td>
<td>${e.value}</td>
</tr>
</c:forEach>
</table>

<h1>Requests:</h1>
<table>
<c:forEach var="e" items="<%=requests%>">
<tr>
<td nowrap>${e.key}</td>
<td>${e.value}</td>
</tr>
</c:forEach>
</table>

<h1>Contexts:</h1>
<table>
<c:forEach var="e" items="<%=contexts%>">
<tr>
<td nowrap>${e.key}</td>
<td>${e.value}</td>
</tr>
</c:forEach>
</table>

<h1>HttpServletRequest:</h1>
<table>
<tr><td>getContextPath()</td><td><%=request.getContextPath()%></td></tr>
<tr><td>getLocalName()</td><td><%=request.getLocalName()%></td></tr>
<tr><td>getLocalPort()</td><td><%=request.getLocalPort()%></td></tr>
<tr><td>getMethod()</td><td><%=request.getMethod()%></td></tr>
<tr><td>getPathInfo()</td><td><%=request.getPathInfo()%></td></tr>
<tr><td>getProtocol()</td><td><%=request.getProtocol()%></td></tr>
<tr><td>getQueryString()</td><td><%=request.getQueryString()%></td></tr>
<tr><td>getRemoteAddr()</td><td><%=request.getRemoteAddr()%></td></tr>
<tr><td>getRemoteHost()</td><td><%=request.getRemoteHost()%></td></tr>
<tr><td>getRequestedSessionId()</td><td><%=request.getRequestedSessionId()%></td></tr>
<tr><td>getRequestURI()</td><td><%=request.getRequestURI()%></td></tr>
<tr><td>getRequestURL()</td><td><%=request.getRequestURL()%></td></tr>
<tr><td>getScheme()</td><td><%=request.getScheme()%></td></tr>
<tr><td>getServletPath()</td><td><%=request.getServletPath()%></td></tr>
<tr><td>getServerName()</td><td><%=request.getServerName()%></td></tr>
</table>

<h1>ServletContext:</h1>
<table>
<tr><td>getContextPath()</td><td><%=context.getContextPath()%></td></tr>
<tr><td>getServletContextName()</td><td><%=context.getServletContextName()%></td></tr>
</table>

<h1>Headers:</h1>
<table>
<c:forEach var="e" items="<%=headers%>">
<tr>
<td nowrap>${e.key}</td>
<td>${e.value}</td>
</tr>
</c:forEach>
</table>

<h1>Cookies:</h1>
<table>
<c:forEach var="e" items="<%=request.getCookies()%>">
<tr>
<td nowrap>${e.name}</td>
<td>${e.value}</td>
</tr>
</c:forEach>
</table>

</body>
</html>
