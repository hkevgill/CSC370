import java.io.*;
import java.net.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class InsertOutgoing extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        String flightID = request.getParameter("flightID");
        String plannedDepartureTime = request.getParameter("plannedDepartureTime");
        String plannedDepartureGate = request.getParameter("plannedDepartureGate");
        
        
        String statementString = "INSERT INTO OUTGOING(flightID, plannedDepartureTime, plannedDepartureGate)" +
                                 "VALUES( " + flightID + "," + "TO_DATE('" + plannedDepartureTime + "','yyyy-mm-dd hh24:mi:ss')" + ",'" + plannedDepartureGate + "')";
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

