import java.io.*;
import java.net.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.*;
import java.text.*;


public class MostDelays extends HttpServlet {
    
   protected void processRequest(HttpServletRequest request, 
                    HttpServletResponse response)
    throws ServletException, IOException {
    response.setContentType("text/html");
        PrintWriter out = response.getWriter();


        Connection conn = ConnectionManager.getInstance().getConnection();

        try {
            Statement stmt = conn.createStatement();
            ResultSet rset = stmt.executeQuery(
                        "SELECT source, destination, MAX(name) as airlineName, MAX(numDelays) as maxDelays " +
                        "FROM ROUTEDELAYS " +
                        "GROUP BY source, destination");
            out.println("<table>");
            out.println("<tr>");
            out.println("<th>source</th>");
            out.println("<th>destination</th>");
            out.println("<th>airlineName</th>");
            out.println("<th>maxDelays</th>");
            out.println("</tr>");
            while (rset.next()) {
                out.println("<tr>");
                out.print ("<td>"+rset.getString("source")+"</td>");
                out.print ("<td>"+rset.getString("destination")+"</td>");
                out.print ("<td>"+rset.getString("airlineName")+"</td>");
                out.print ("<td>"+rset.getString("maxDelays")+"</td>");
                out.println("</tr>");
            }
            out.println("</table>");
            stmt.close();
        }
        catch(SQLException e) {
           out.println(e);
        }
        

        ConnectionManager.getInstance().returnConnection(conn);
    }

   protected void doGet(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
        processRequest(request, response);
    }
   protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }
   public String getServletInfo() {  return "Short description"; }
}
