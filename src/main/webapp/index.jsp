<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Week 6 | Bellevue University</title>
<link href='https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta3/dist/css/bootstrap.min.css' rel='stylesheet'>
</head>
<body>
<div class="container">
	<%
	// Show form on GET request
	if(request.getMethod().equals("GET")) {
	%>
	
	<!-- GET form -->
	<form class='row g-3' action='.' method='POST'>"
		<div class='form-text'>Create a new message.</div>
		<div class='col-6'>
			<label class='form-label'>username</label>
			<input type='text' class='form-control' name='username'>
		</div>
		<div class="col-6">
			<label class='form-label'>image url</label>
			<input type='text' class='form-control' name='avatar'>
		</div>
		<div class='col-12'>
		    <label class='form-label'>message</label>
	      	<textarea class="form-control" name="message" rows="3"></textarea>
		</div>
		<div class='col-12 visually-hidden'>
		    <input type='date' class='form-control' name='timestamp' value="<%= new java.util.Date().toLocaleString() %>">
		</div>
		<button type='submit' class='btn btn-primary col-6 col-sm-12'>Submit</button>
	</form>
	
	<%
	} 
	
	// POST Handler
	if(request.getMethod().equals("POST")) {
		
		// database connection
		java.sql.Connection con;
		java.sql.Statement stmt;
		java.sql.ResultSet results;
		
		// secrets 🤫
		String url = "jdbc:mysql://localhost:3306";
		String uname = "student1";
		String pword = "pass";
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			String mysqlPath = java.lang.String.format("%s/user=%s&password=%s", url, uname, pword);
			con = java.sql.DriverManager.getConnection(mysqlPath);
			stmt = con.createStatement();
		}
		catch(Exception e) {
			out.println(e);
		}
		
		// Incoming form data
        String username = request.getParameter("username");
        String avatar = request.getParameter("avatar");
        String message = request.getParameter("message");
        String timestamp = request.getParameter("timestamp");
	%>
	
	<h1>Thanks for submitting!</h1>
	
	<%
		// output results
		out.print("<img src='"+avatar+"'>");
		out.print(username);
		out.print(message);
		out.print("Submitted on: " + timestamp);
	}
	%>
	
</div>

</body>
</html>