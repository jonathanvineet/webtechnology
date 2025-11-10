import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class ex5d extends HttpServlet {
    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        // Get artist name
        String artist = req.getParameter("artist");

        // Encode data in the URL
        String nextURL = "Ex5d?artist=" + artist;

        out.println("<html><body>");
        out.println("<h2>Welcome, music fan!</h2>");
        out.println("<p>Click below to view artist details.</p>");
        out.println("<a href='" + nextURL + "'>View " + artist + "</a>");
        out.println("</body></html>");
    }

    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        // Retrieve artist from URL
        String artist = req.getParameter("artist");

        out.println("<html><body>");
        out.println("<h2>Artist Details</h2>");
        out.println("<p>Artist Name: <b>" + artist + "</b></p>");
        out.println("</body></html>");
    }
}
