import java.io.*;
import java.net.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class InsertArrival extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        String arrivalGate = request.getParameter("arrivalGate");
        String arrivalDate = request.getParameter("arrivalDate");
        String arrivalStatus = request.getParameter("arrivalStatus");
        
        
        String statementString = "INSERT INTO ARRIVALS(arrivalGate, arrivalDate, arrivalStatus)" +
                                 "VALUES('" + arrivalGate + "'," + "TO_DATE('" + arrivalDate + "','yyyy-mm-dd hh24:mi:ss')" + ",'" + arrivalStatus + "')";
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

