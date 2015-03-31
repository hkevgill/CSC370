import java.io.*;
import java.net.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;


public class BestPassenger extends HttpServlet {
    
   protected void processRequest(HttpServletRequest request, 
                    HttpServletResponse response)
    throws ServletException, IOException {
    response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        String airline = request.getParameter("airline");

        Connection conn = ConnectionManager.getInstance().getConnection();

        try {
            Statement stmt = conn.createStatement();
            ResultSet rset = stmt.executeQuery(
                        "SELECT passID, name, timesFlown " +
                        "FROM(SELECT * " +
                            "FROM( " +
                                "(SELECT passID, COUNT(passID) AS timesFlown " +
                                "FROM ((SELECT * " +
                                    "FROM AIRLINES JOIN OPERATES USING(airlineCode) " +
                                    "WHERE AIRLINES.name = '" + airline + "') " +
                                        "JOIN " +
                                    "(SELECT * " +
                                    "FROM PASSENGERS JOIN BOARDS USING(passID)) " +
                                        "USING(flightID)) " +
                                "GROUP BY passID) " +
                                    "JOIN PASSENGERS USING(passID) " +
                                ") " +
                            "ORDER BY timesFlown DESC) " +
                        "WHERE ROWNUM <= 1");
            out.println("<table>");
            out.println("<tr>");
            out.println("<th>passID</th>");
            out.println("<th>name</th>");
            out.println("<th>timesFlown</th>");
            out.println("</tr>");
            while (rset.next()) {
                out.println("<tr>");
                out.print ("<td>"+rset.getString("passID")+"</td>");
                out.print ("<td>"+rset.getString("name")+"</td>");
                out.print ("<td>"+rset.getString("timesFlown")+"</td>");
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
