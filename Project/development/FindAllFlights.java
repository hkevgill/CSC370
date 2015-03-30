import java.io.*;
import java.net.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;


public class FindAllFlights extends HttpServlet {
    
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
                        "SELECT flightID " +
                        "FROM( " +
                            "SELECT * " +
                            "FROM AIRLINES JOIN OPERATES ON AIRLINES.airlineCode = OPERATES.airlineCode " +
                            "WHERE AIRLINES.name = '" + airline + "')");
            out.println("<table>");
            out.println("<tr>");
            out.println("<th>Flight ID</th>");
            out.println("</tr>");
            while (rset.next()) {
                out.println("<tr>");
                out.print (
                    "<td>"+rset.getString("flightID")+"</td>");
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
