<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.stream.*"%>

<%
	ServletContext context = request.getServletContext();
	String url = context.getContextPath() + "/jsp/session.jsp";
	String delay = request.getAttribute("delay") == null ? "5" : request.getAttribute("delay").toString();

	HashMap<String, String> headers = new HashMap<>();
	Collections.list(request.getHeaderNames())
		.forEach(key -> 
			headers.put(key, Collections.list(request.getHeaders(key)).stream()
				.collect(Collectors.joining(","))));

	HashMap<String, String> params = new HashMap<>();
	request.getParameterMap().keySet().stream()
		.forEach(key -> 
			params.put(key, String.join(",", request.getParameterValues(key)))
		);

	HashMap<String, String> sessions = new HashMap<>();
	Collections.list(session.getAttributeNames())
		.forEach(key ->
			sessions.put(key, request.getSession().getAttribute(key).toString())
		);

	HashMap<String, String> contexts = new HashMap<>();
	Collections.list(context.getAttributeNames())
		.forEach(key ->
			contexts.put(key, context.getAttribute(key).toString())
		);

	HashMap<String, String> requests = new HashMap<>();
	Collections.list(request.getAttributeNames())
		.forEach(key ->
			requests.put(key, request.getAttribute(key).toString())
		);
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
<td nowrap><c:out value="${e.key}"/></td>
<td><c:out value="${e.value}"/></td>
</tr>
</c:forEach>
</table>

<h1>Sessions:</h1>
<table>
<c:forEach var="e" items="<%=sessions%>">
<tr>
<td nowrap><c:out value="${e.key}"/></td>
<td><c:out value="${e.value}"/></td>
</tr>
</c:forEach>
</table>

<h1>Requests:</h1>
<table>
<c:forEach var="e" items="<%=requests%>">
<tr>
<td nowrap><c:out value="${e.key}"/></td>
<td><c:out value="${e.value}"/></td>
</tr>
</c:forEach>
</table>

<h1>Contexts:</h1>
<table>
<c:forEach var="e" items="<%=contexts%>">
<tr>
<td nowrap><c:out value="${e.key}"/></td>
<td><c:out value="${e.value}"/></td>
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
<td nowrap><c:out value="${e.key}"/></td>
<td><c:out value="${e.value}"/></td>
</tr>
</c:forEach>
</table>

</body>
</html>
