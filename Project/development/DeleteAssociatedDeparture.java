import java.io.*;
import java.net.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class DeleteAssociatedDeparture extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        String passID = request.getParameter("passID");
        String departureGate = request.getParameter("departureGate");
        String departureDate = request.getParameter("departureDate");
        
        
        String statementString = "DELETE FROM ASSOCIATEDDEPARTURE " +
                                 "WHERE passID = " + passID + " AND departureGate = '" + departureGate + "' AND departureDate = TO_DATE('" + departureDate + "','yyyy-mm-dd hh24:mi:ss')";
        Connection conn = ConnectionManager.getInstance().getConnection();
        
        try {
            Statement stmt = conn.createStatement();
            stmt.executeUpdate(statementString);
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

