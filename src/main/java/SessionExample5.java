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
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Example servlet showing request headers
 *
 * @author James Duncan Davidson <duncan@eng.sun.com>
 * 
 * 注意： tomcat-cluster-redis-session-manager
 *  JavaEE9(javax..)で実装されているのでtomcat9までしか使用できない
 *  
 */
@WebServlet(name="session5", urlPatterns = { "/session", "/servlet/SessionExample5" })
public class SessionExample5 extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	public void doPost(HttpServletRequest request,
					  HttpServletResponse response)
		throws IOException, ServletException
	{
//		response.setContentType("text/html; charset=UTF-8");
//		PrintWriter out = response.getWriter();
//		request.setCharacterEncoding("UTF-8");

//		for (String key : request.getParameterMap().keySet()) {
//			System.out.println(key + ": " + String.join(",", request.getParameterValues(key)));
//		}
		request.getParameterMap().keySet().stream()
			.map(key -> key + ": " + String.join(",", request.getParameterValues(key)))
			.forEach(System.out::println);

		HttpSession session = request.getSession(true);
		ServletContext context = getServletConfig().getServletContext();

		@SuppressWarnings("unchecked")
		Map<String, String> map1 = (Map<String,String>)session.getAttribute("map1");
		if (map1 == null) {
			map1 = new HashMap<>();
		}
		@SuppressWarnings("unchecked")
		Map<String, String> map2 = (Map<String,String>)request.getAttribute("map2");
		if (map2 == null) {
			map2 = new HashMap<>();
		}
		@SuppressWarnings("unchecked")
		Map<String, String> map3 = (Map<String,String>)context.getAttribute("map3");
		if (map3 == null) {
			map3 = new HashMap<>();
		}

		String name = request.getParameter("dataname");
		String value = request.getParameter("datavalue");
		if (name != null && value != null && !name.isEmpty() && !value.isEmpty()) {
			map1.put(name, value);
			map2.put(name, value);
			map3.put(name, value);
		}

		String[] vals = request.getParameterValues("DEL");
		if (vals == null) { }
		else for (String val : vals) {
			map1.remove(val);
			map2.remove(val);
			map3.remove(val);
		}

		String attribute = request.getParameter("attribute");
		if (attribute == null) { }
		else if (attribute.equals("set")) {
			session.setAttribute("map1",  map1);
			request.setAttribute("map2",  map2);
			context.setAttribute("map3",  map3);
		}
		else if (attribute.equals("remove")) {
			session.invalidate();
			Collections.list(request.getAttributeNames())
				.forEach(key -> request.removeAttribute(key));
			Collections.list(context.getAttributeNames())
				.forEach(key -> context.removeAttribute(key));
		}

		String delay = request.getParameter("delay");
		if (delay == null) {
			delay = "5";
		}
		request.setAttribute("delay", delay);

		//フォワード先の指定
		RequestDispatcher dispatcher =  request.getRequestDispatcher("/jsp/redirect.jsp");
		//フォワードの実行
		dispatcher.forward(request, response);
	}

	@Override
	public void doGet(HttpServletRequest request,
					  HttpServletResponse response)
		throws IOException, ServletException
	{
//		doPost(request, response);

		//フォワード先の指定
		RequestDispatcher dispatcher =  request.getRequestDispatcher("/jsp/redirect.jsp");
		//フォワードの実行
		dispatcher.forward(request, response);
	}

}
