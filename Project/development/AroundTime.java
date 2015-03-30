import java.io.*;
import java.net.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.*;
import java.text.*;


public class AroundTime extends HttpServlet {
    
   protected void processRequest(HttpServletRequest request, 
                    HttpServletResponse response)
    throws ServletException, IOException {
    response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        String time1 = request.getParameter("time1");

        Calendar currentDate = Calendar.getInstance();
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

        String dateNow = formatter.format(currentDate.getTime());

        String timeOfDay = dateNow + " " + time1;

        Connection conn = ConnectionManager.getInstance().getConnection();

        try {
            Statement stmt = conn.createStatement();
            ResultSet rset = stmt.executeQuery(
                        "SELECT * " +
                        "FROM " +
                          "((SELECT departureGate, departureDate, departureStatus AS Status " +
                          "FROM DEPARTURES " +
                          "WHERE (TO_DATE('" + timeOfDay + "', 'yyyy-mm-dd hh24:mi:ss') - departureDate) < (1/24) AND (TO_DATE('" + timeOfDay + "', 'yyyy-mm-dd hh24:mi:ss') - departureDate) > (-1/24)) " +
                            "NATURAL FULL OUTER JOIN " +
                          "(SELECT arrivalGate, arrivalDate, arrivalStatus AS Status " +
                          "FROM ARRIVALS " +
                          "WHERE ((arrivalDate - TO_DATE('" + timeOfDay + "', 'yyyy-mm-dd hh24:mi:ss')) < (1/24) AND (arrivalDate - TO_DATE('" + timeOfDay + "', 'yyyy-mm-dd hh24:mi:ss')) > (-1/24))))");
            out.println("<table>");
            out.println("<tr>");
            out.println("<th>departureGate</th>");
            out.println("<th>departureDate</th>");
            out.println("<th>arrivalGate</th>");
            out.println("<th>arrivalDate</th>");
            out.println("<th>Status</th>");
            out.println("</tr>");
            while (rset.next()) {
                out.println("<tr>");
                out.print ("<td>"+rset.getString("departureGate")+"</td>");
                out.print ("<td>"+rset.getString("departureDate")+"</td>");
                out.print ("<td>"+rset.getString("arrivalGate")+"</td>");
                out.print ("<td>"+rset.getString("arrivalDate")+"</td>");
                out.print ("<td>"+rset.getString("Status")+"</td>");
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
