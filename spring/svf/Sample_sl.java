/*
 * Sample_ja.java 2013/04/18
 * SVF for Excel
 * Sample Program
 */

//import jp.co.fit.vfreport.Vrw32;
import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name="sample", urlPatterns = { "/sample" })
public class Sample_sl extends HttpServlet {

  public void doGet(HttpServletRequest req,
                      HttpServletResponse res)
                      throws ServletException, IOException {
    try {
      Sample_ja.run();

      res.setContentType("text/html; charset=utf8");

        // HttpServletResponse 型のインスタンスから Writer を取り出し
        // Writer に HTML を書き出す
        PrintWriter out = res.getWriter();
        out.println("<html>");
        out.println("<head>");
        out.println("<title>LoopServlet</title>");
        out.println("</head>");
        out.println("<body>");

        out.println("request ... done");


        out.println("</body>");
        out.println("</html>");
    }
    catch (Exception ex) {
      res.setContentType("text/plain; charset=utf8");
      PrintWriter out = res.getWriter();
      ex.printStackTrace(out);
    }
  }

}
