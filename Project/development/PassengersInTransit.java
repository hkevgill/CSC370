import java.io.*;
import java.net.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.*;
import java.text.*;


public class PassengersInTransit extends HttpServlet {
    
   protected void processRequest(HttpServletRequest request, 
                    HttpServletResponse response)
    throws ServletException, IOException {
    response.setContentType("text/html");
        PrintWriter out = response.getWriter();


        Connection conn = ConnectionManager.getInstance().getConnection();

        try {
            Statement stmt = conn.createStatement();
            ResultSet rset = stmt.executeQuery(
                        "SELECT passID " +
                        "FROM BOARDS " +
                                "NATURAL JOIN " +
                            "(SELECT * " +
                            "FROM (FLIGHTS JOIN INCOMING USING(flightID)) " +
                            "WHERE SYSDATE < plannedArrivalTime AND SYSDATE > plannedArrivalTime - duration) " +
                                "UNION ALL " +
                            "(SELECT * " +
                            "FROM (FLIGHTS JOIN OUTGOING USING(flightID)) " +
                            "WHERE SYSDATE > plannedDepartureTime AND SYSDATE < plannedDepartureTime + duration)");
            out.println("<table>");
            out.println("<tr>");
            out.println("<th>passID</th>");
            out.println("</tr>");
            while (rset.next()) {
                out.println("<tr>");
                out.print ("<td>"+rset.getString("passID")+"</td>");
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
