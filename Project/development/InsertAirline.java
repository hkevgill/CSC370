import java.io.*;
import java.net.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class InsertAirline extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        String airlineCode = request.getParameter("airlineCode");
        String name = request.getParameter("name");
        String website = request.getParameter("website");
        
        
        String statementString = "INSERT INTO AIRLINES(airlineCode, name, website) " +
                                 "VALUES( '" + airlineCode + "','" + name + "','" + website + "')";
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

