import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class ex5c extends HttpServlet {
    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        // Get user input
        String artist = req.getParameter("artist");

        // Create and add cookie
        Cookie cookie = new Cookie("favArtist", artist);
        res.addCookie(cookie);

        out.println("<html><body>");
        out.println("<h3>Cookie saved!</h3>");
        out.println("<p>Your favorite artist: <b>" + artist + "</b></p>");
        out.println("<a href='Ex5c'>View Cookie</a>");
        out.println("</body></html>");
    }

    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        String artist = "Not Found";
        Cookie[] cookies = req.getCookies();

        if (cookies != null) {
            for (Cookie c : cookies) {
                if (c.getName().equals("favArtist")) {
                    artist = c.getValue();
                }
            }
        }

        out.println("<html><body>");
        out.println("<h2>Saved Cookie Data</h2>");
        out.println("<p>Favorite Artist: <b>" + artist + "</b></p>");
        out.println("</body></html>");
    }
}
