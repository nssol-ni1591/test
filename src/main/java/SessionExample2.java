/*
* Licensed to the Apache Software Foundation (ASF) under one or more
* contributor license agreements.  See the NOTICE file distributed with
* this work for additional information regarding copyright ownership.
* The ASF licenses this file to You under the Apache License, Version 2.0
* (the "License"); you may not use this file except in compliance with
* the License.  You may obtain a copy of the License at
*
*	 http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.ResourceBundle;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import util.HTMLFilter;

/**
 * Example servlet showing request headers
 *
 * @author James Duncan Davidson <duncan@eng.sun.com>
 * 
 * 注意： tomcat-cluster-redis-session-manager
 *  JavaEE9(javax..)で実装されているのでtomcat9までしか使用できない
 *  
 */
@WebServlet(name="session2", urlPatterns = { "/session2" })
public class SessionExample2 extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	public void doGet(HttpServletRequest request,
					  HttpServletResponse response)
		throws IOException, ServletException
	{
		ResourceBundle rb = ResourceBundle.getBundle("LocalStrings",request.getLocale());

		response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");

		PrintWriter out = response.getWriter();
		out.println("<!DOCTYPE html><html>");
		out.println("<head>");
		out.println("<meta charset=\"UTF-8\" />");


		String title = rb.getString("sessions.title");
		out.println("<title>" + title + "</title>");
		out.println("</head>");
		out.println("<body bgcolor=\"white\">");

		// img stuff not req'd for source code HTML showing
		// relative links everywhere!

		// XXX
		// making these absolute till we work out the
		// addition of a PathInfo issue

		out.println("<a href=\"sessions.html\">");
		out.println("<img src=\"images/code.gif\" height=24 " +
					"width=24 align=right border=0 alt=\"view code\"></a>");
		out.println("<a href=\"index.html\">");
		out.println("<img src=\"images/return.gif\" height=24 " +
					"width=24 align=right border=0 alt=\"return\"></a>");

		out.println("<h3>" + title + "</h3>");

		String clear = request.getParameter("clear");
		out.println("clear: " + (clear == null));
		out.println("<br>");
		HttpSession session = request.getSession(clear == null);

		out.println(rb.getString("sessions.id") + " " + session.getId());
		out.println("<br>");
		out.println(rb.getString("sessions.created") + " ");
		out.println(new Date(session.getCreationTime()) + "<br>");
		out.println(rb.getString("sessions.lastaccessed") + " ");
		out.println(new Date(session.getLastAccessedTime()));

		@SuppressWarnings("unchecked")
		Map<String, String> map = (Map<String,String>)session.getAttribute("map");
		if (map == null) {
			map = new HashMap<>();
		}
		for (int ix = 1; ix <= 5; ix++) {
			String dataName = request.getParameter("dataname" + ix);
			String dataValue = request.getParameter("datavalue" + ix);
			if (dataName != null && dataValue != null && !dataName.isEmpty() && !dataValue.isEmpty()) {
				map.put(dataName, dataValue);
			}
		}

		String setattribute = request.getParameter("setattribute");
		if (setattribute != null) {
			session.setAttribute("map",  map);
		}

		out.println("<P>");
		out.println(rb.getString("sessions.data") + "<br>");
		/*
		Enumeration<String> names = session.getAttributeNames();
		while (names.hasMoreElements()) {
			String name = names.nextElement();
			String value = session.getAttribute(name).toString();
			out.println(HTMLFilter.filter(name) + " = "
						+ HTMLFilter.filter(value) + "<br>");
		}
		*/
		for (String key : map.keySet()) {
			String value = map.get(key);
			out.println(HTMLFilter.filter(key) + " = "
						+ HTMLFilter.filter(value) + "<br>");
		}

		out.println("<P>");
		out.print("<form action=\"");
//		out.print(response.encodeURL("SessionExample"));
		out.print(response.encodeURL("session2"));
		out.print("\" ");
		out.println("method=POST>");

		out.println("<table>");
		out.println("<tr>");
		out.println("<th>" + rb.getString("sessions.dataname") + "</th>");
		out.println("<th>" + rb.getString("sessions.datavalue") + "</th>");
		out.println("</tr>");
		
		int ix = 1;
		for (String key : map.keySet()) {
			String val = map.get(key);
			out.println("<tr>");
			out.println("<td>" + "<input type=text size=20 name=dataname"  + ix + " value=" + key  + ">" + "</td>");
			out.println("<td>" + "<input type=text size=20 name=datavalue" + ix + " value=" + val + ">" + "</td>");
			out.println("</tr>");
			ix++;
		}
		for (; ix <= 5; ix++) {
			out.println("<tr>");
			out.println("<td>" + "<input type=text size=20 name=dataname"  + ix + " value=\"\">" + "</td>");
			out.println("<td>" + "<input type=text size=20 name=datavalue" + ix + " value=\"\">" + "</td>");
			out.println("</tr>");
		}
		out.println("</table>");

		out.println("<p>");
		out.println("<input type=checkbox name=setattribute checked>setAttribute</input>");
		out.println("<input type=checkbox name=\"clear\">clear session</input>");
		out.println("</p>");

		out.println("<input type=submit>");
		out.println("</form>");

		out.println("<P>GET based form:<br>");
		out.print("<form action=\"");
//		out.print(response.encodeURL("SessionExample"));
		out.print(response.encodeURL("session2"));
		out.print("\" ");
		out.println("method=GET>");
		out.println(rb.getString("sessions.dataname"));
		out.println("<input type=text size=20 name=dataname>");
		out.println("<br>");
		out.println(rb.getString("sessions.datavalue"));
		out.println("<input type=text size=20 name=datavalue>");
		out.println("<br>");
		out.println("<input type=submit>");
		out.println("</form>");

		out.print("<p><a href=\"");
		out.print(HTMLFilter.filter(response.encodeURL("SessionExample?dataname=foo&datavalue=bar")));
		out.println("\" >URL encoded </a>");

		out.println("</body>");
		out.println("</html>");
	}

	@Override
	public void doPost(HttpServletRequest request,
					  HttpServletResponse response)
		throws IOException, ServletException
	{
		doGet(request, response);
	}

}
