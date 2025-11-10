import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class ex5a extends HttpServlet {
    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        String musician = req.getParameter("musician");
        String instrument = req.getParameter("instrument");

        out.println("<html><body>");
        out.println("<h2>Musician Details</h2>");
        out.println("<p>Name: " + musician + "</p>");
        out.println("<p>Instrument: " + instrument + "</p>");
        out.println("</body></html>");
    }
}
