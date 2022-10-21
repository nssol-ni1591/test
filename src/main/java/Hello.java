

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class Hello
 */
//@WebServlet({ "/hello", "/hello/*" })	... ok
//@WebServlet({ "/*" })					... ok
//@WebServlet({ "*" })					... サーブレットマッピング中に無効な <url-pattern> [*] があります
//@WebServlet({ "hello/*" })			... サーブレットマッピング中に無効な <url-pattern> [hello/*] があります
@WebServlet({ "/hello/*" })				//  ok
public class Hello extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void hello(PrintWriter out, HttpServletRequest request) {
		out.println();
//		out.println("<html><body>");
//		out.println("<h1>Hello</h1>");
		out.println("ContextPath: " + request.getContextPath());
		out.println("RequestURI: " + request.getRequestURI());
//		out.println("</body></html>");
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
		
		PrintWriter out = response.getWriter();
		hello(out, request);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
