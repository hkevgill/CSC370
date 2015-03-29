import java.io.*;
import java.net.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class InsertFirstClass extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        String classID = request.getParameter("classID");
        String dessert = request.getParameter("dessert");
        String mealChoice = request.getParameter("mealChoice");
        String partyFavors = request.getParameter("partyFavors");
        String numberOfPillows = request.getParameter("numberOfPillows");
        String winePreference = request.getParameter("winePreference");
        
        
        String statementString = "INSERT INTO FirstClass(classID, dessert, mealChoice, partyFavors, numberOfPillows, winePreference)" +
                                 "VALUES(" + classID + ",'" + dessert + "','" + mealChoice + "','" + partyFavors + "'," + numberOfPillows + ",'" + winePreference + "')";
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

