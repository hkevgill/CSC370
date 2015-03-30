import java.io.*;
import java.net.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.*;
import java.text.*;


public class AllPassengerInfo extends HttpServlet {
    
   protected void processRequest(HttpServletRequest request, 
                    HttpServletResponse response)
    throws ServletException, IOException {
    response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        String gate = request.getParameter("gate");
        String date1 = request.getParameter("date1");


        Connection conn = ConnectionManager.getInstance().getConnection();

        try {
            Statement stmt = conn.createStatement();
            ResultSet rset = stmt.executeQuery(
                        "SELECT passID, name, dateOfBirth, placeOfBirth, citizenship " +
                        "FROM ASSOCIATEDDEPARTURE JOIN PASSENGERS USING(passID) " +
                        "WHERE ('" + gate + "' = departureGate) AND (TO_DATE('" + date1 + "', 'yyyy-mm-dd hh24:mi:ss') = departureDate) " +
                        "    UNION ALL " +
                        "SELECT passID, name, dateOfBirth, placeOfBirth, citizenship " +
                        "FROM ASSOCIATEDARRIVAL JOIN PASSENGERS USING(passID) " +
                        "WHERE ('" + gate + "' = arrivalGate) AND (TO_DATE('" + date1 + "', 'yyyy-mm-dd hh24:mi:ss') = arrivalDate)");
            out.println("<table>");
            out.println("<tr>");
            out.println("<th>passID</th>");
            out.println("<th>name</th>");
            out.println("<th>dateOfBirth</th>");
            out.println("<th>placeOfBirth</th>");
            out.println("<th>citizenship</th>");
            out.println("</tr>");
            while (rset.next()) {
                out.println("<tr>");
                out.print ("<td>"+rset.getString("passID")+"</td>");
                out.print ("<td>"+rset.getString("name")+"</td>");
                out.print ("<td>"+rset.getString("dateOfBirth")+"</td>");
                out.print ("<td>"+rset.getString("placeOfBirth")+"</td>");
                out.print ("<td>"+rset.getString("citizenship")+"</td>");
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
