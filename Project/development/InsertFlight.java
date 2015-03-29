import java.io.*;
import java.net.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class InsertFlight extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        String flightID = request.getParameter("flightID");
        String flightNumber = request.getParameter("flightNumber");
        String source = request.getParameter("source");
        String destination = request.getParameter("destination");
        
        
        String statementString = "INSERT INTO FLIGHTS(flightID, flightNumber, source, destination) " +
                                 "VALUES( " + flightID + ",'" + flightNumber + "','" + source + "','" + destination + "')";
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

