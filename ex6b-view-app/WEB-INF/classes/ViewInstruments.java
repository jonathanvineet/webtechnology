import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class ViewInstruments extends HttpServlet {
    public void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/musicdb", "root", "");

            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM instruments");

            out.println("<html><body>");
            out.println("<h3>Registered Instruments</h3>");
            out.println("<table border='1' cellpadding='5'>");
            out.println("<tr><th>ID</th><th>Name</th><th>Email</th><th>Type</th></tr>");

            while (rs.next()) {
                out.println("<tr><td>" + rs.getInt("id") + "</td>"
                        + "<td>" + rs.getString("name") + "</td>"
                        + "<td>" + rs.getString("email") + "</td>"
                        + "<td>" + rs.getString("type") + "</td></tr>");
            }

            out.println("</table>");
            out.println("<br><a href='view.html'>Back</a>");
            out.println("</body></html>");
            con.close();
        } catch (Exception e) {
            out.println("<h3>Error: " + e.getMessage() + "</h3>");
        }
    }
}
