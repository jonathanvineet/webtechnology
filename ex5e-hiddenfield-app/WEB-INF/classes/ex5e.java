import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class ex5e extends HttpServlet {
    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        String song = req.getParameter("song");
        String artist = req.getParameter("artist");

        out.println("<html><body>");
        out.println("<h2>Confirm Song Details</h2>");
        out.println("<form action='Ex5e' method='get'>");
        out.println("<p>Song: <b>" + song + "</b></p>");
        out.println("<p>Artist: <b>" + artist + "</b></p>");
        out.println("<input type='hidden' name='song' value='" + song + "'>");
        out.println("<input type='hidden' name='artist' value='" + artist + "'>");
        out.println("<input type='submit' value='View Final Details'>");
        out.println("</form>");
        out.println("</body></html>");
    }

    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        String song = req.getParameter("song");
        String artist = req.getParameter("artist");

        out.println("<html><body>");
        out.println("<h2>Final Song Details</h2>");
        out.println("<p>Song: <b>" + song + "</b></p>");
        out.println("<p>Artist: <b>" + artist + "</b></p>");
        out.println("<p>(Data passed using Hidden Form Fields)</p>");
        out.println("</body></html>");
    }
}
