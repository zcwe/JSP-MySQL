//
// Java class created by Zachary Weaver & Dylan 
// Bellevue University
// Week 6
//


// imports for servlet
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;

// URL to access at: i.e http://localhost:7070/
@WebServlet("/form-complete")
public class index extends HttpServlet {
	// generated variable
	private static final long serialVersionUID = 1L;

	String dbPassword = "pass";
	
    // contstructor, initial assignment
    public index() {
        super();
    }


    // GET REQUEST HANDLER
	public void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		PrintWriter page = response.getWriter();
		System.out.println("GET page");
	}

	
	// POST REQUEST HANDLER
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		PrintWriter page = response.getWriter();
		
		// GET DATA
        String username = request.getParameter("username");
        String avatar = request.getParameter("avatar");
        String message = request.getParameter("message");
        String timestamp = request.getParameter("timestamp");
		System.out.println("POST page");
		System.out.println("message posted"+timestamp);
		request.getRequestDispatcher("/").forward(request, response);
		
		try {
			connectDB();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	protected void connectDB() throws SQLException{
		Connection conn = null;
        Statement stmt = null;

        try {
        	Class.forName("com.mysql.cj.jdbc.Driver");
        	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/" +  "user=student1&password=pass");
        	stmt = conn.createStatement();
        	
        } catch(Exception e) {
        	e.printStackTrace();
        }
        
        try {
        	stmt.close();
        	conn.close();
        	
        } catch(Exception e) {
        	e.printStackTrace();
        }
                
    
//    	stmt.execute("drop table javaTest");
//    	stmt.execute("create table javaTest(FirstName VARCHAR(25), LastName  VARCHAR(25), PhoneNum  NUMERIC(10))");
//      stmt.executeUpdate("INSERT INTO JAVATEST(FirstName, LastName, PhoneNum)VALUES("+"'"+ fname +"'"+","+"'"+ lname +"'"+","+"'"+ pnum+"'"+")");
//      stmt.executeUpdate("INSERT INTO JAVATEST(FirstName, LastName, PhoneNum)VALUES("+"'"+ fname2+"'"+","+"'"+ lname2+"'"+","+"'"+ pnum2+"'"+")");
//      stmt.executeUpdate("INSERT INTO JAVATEST(FirstName, LastName, PhoneNum)VALUES("+"'"+ fname3+"'"+","+"'"+ lname3+"'"+","+"'"+ pnum3+"'"+")");

        System.out.println("<b>Complete</b><br />");
	}

}