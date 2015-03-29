import java.io.*;
import java.net.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class InsertDeparture extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        String departureGate = request.getParameter("departureGate");
        String departureDate = request.getParameter("departureDate");
        String departureStatus = request.getParameter("departureStatus");
        
        
        String statementString = "INSERT INTO DEPARTURES(departureGate, departureDate, departureStatus)" +
                                 "VALUES('" + departureGate + "'," + "TO_DATE('" + departureDate + "','yyyy-mm-dd hh24:mi:ss')" + ",'" + departureStatus + "')";
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

