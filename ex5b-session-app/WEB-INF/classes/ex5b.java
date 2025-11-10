import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class ex5b extends HttpServlet {
    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        // get data
        String musician = req.getParameter("musician");
        String instrument = req.getParameter("instrument");

        // create session
        HttpSession session = req.getSession();
        session.setAttribute("musician", musician);
        session.setAttribute("instrument", instrument);

        out.println("<html><body>");
        out.println("<h2>Welcome " + musician + "!</h2>");
        out.println("<p>Your instrument: " + instrument + "</p>");
        out.println("<a href='Ex5b'>View Session Info</a>");
        out.println("</body></html>");
    }

    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        HttpSession session = req.getSession(false);
        out.println("<html><body>");
        if (session != null) {
            String musician = (String) session.getAttribute("musician");
            String instrument = (String) session.getAttribute("instrument");
            out.println("<h2>Session Data</h2>");
            out.println("<p>Musician: " + musician + "</p>");
            out.println("<p>Instrument: " + instrument + "</p>");
        } else {
            out.println("<p>No active session found!</p>");
        }
        out.println("</body></html>");
    }
}
