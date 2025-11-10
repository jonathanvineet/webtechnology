import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class ex5e extends HttpServlet {
    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        String song = req.getParameter("song");
        String artist = req.getParameter("artist");
        
        // Get current date and time
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");
        Date now = new Date();
        String currentDate = dateFormat.format(now);
        String currentTime = timeFormat.format(now);

        out.println("<html><body>");
        out.println("<h2>Confirm Song Details</h2>");
        out.println("<form action='Ex5e' method='get'>");
        out.println("<p>Song: <b>" + song + "</b></p>");
        out.println("<p>Artist: <b>" + artist + "</b></p>");
        out.println("<p>Submitted on: <b>" + currentDate + " at " + currentTime + "</b></p>");
        out.println("<input type='hidden' name='song' value='" + song + "'>");
        out.println("<input type='hidden' name='artist' value='" + artist + "'>");
        out.println("<input type='hidden' name='date' value='" + currentDate + "'>");
        out.println("<input type='hidden' name='time' value='" + currentTime + "'>");
        out.println("<input type='submit' value='View Final Details'>");
        out.println("</form>");
        out.println("</body></html>");
    }

    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        String song = req.getParameter("song");
        String artist = req.getParameter("artist");
        String date = req.getParameter("date");
        String time = req.getParameter("time");

        out.println("<html><body>");
        out.println("<h2>Final Song Details</h2>");
        out.println("<p>Song: <b>" + song + "</b></p>");
        out.println("<p>Artist: <b>" + artist + "</b></p>");
        out.println("<p>Submission Date: <b>" + date + "</b></p>");
        out.println("<p>Submission Time: <b>" + time + "</b></p>");
        out.println("<hr>");
        out.println("<p><i>(Data passed using Hidden Form Fields)</i></p>");
        out.println("</body></html>");
    }
}
