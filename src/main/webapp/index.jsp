<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Week 6 | Bellevue University</title>
<link href='https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta3/dist/css/bootstrap.min.css' rel='stylesheet'>
<%!

// database connection
java.sql.Connection con = null;
java.sql.Statement stmt = null;
java.sql.ResultSet results = null;
// secrets 🤫
String url = "jdbc:mysql://localhost:3306/STUDENT1?";
String uname = "student1";
String pword = "pass";

void openDB() {
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		String path = java.lang.String.format("%suser=%s&password=%s", url, uname, pword);
		con = java.sql.DriverManager.getConnection(path);
		stmt = con.createStatement();
	}
	catch(Exception e) {
		e.printStackTrace();
	}
}

void clearTable() {
    try{
        stmt.executeUpdate("DROP TABLE IF EXISTS messages");
        System.out.println("MESSAGES Table DROPPED");
    }
    catch(java.sql.SQLException e){                
        System.out.println("Could not drop MESSAGES, 'does not exist'");
    }
}

void initTable() {
    try{
        stmt.executeUpdate("CREATE TABLE messages(id INT primary key AUTO_INCREMENT, username CHAR(20) NOT NULL, image VARCHAR(2048) NOT NULL, message CHAR(50), timestamp TIMESTAMP NOT NULL)");
        System.out.println("'messages' created");
    }
    catch(java.sql.SQLException e){
        System.out.println("Could not create 'messages' table");
    }
}

void insertData(String uname, String url, String message, java.sql.Timestamp timestamp) {
	
	String query = String.format("INSERT INTO messages(username, image, message, timestamp)VALUES('%s', '%s', '%s', '%s')", uname, url, message, timestamp);
	try {
		stmt.executeUpdate(query);
		System.out.println("New Data Stored!");
	}      
    catch(java.sql.SQLException e){
    	// not best practice but for basic implementation clear than retry
    	System.out.println("error inserting data, trying to create table...");
 		clearTable();
    	initTable();
    	insertData(uname, url, message, timestamp);
    }
	            
}

void getData() {
    try{
        results = stmt.executeQuery("SELECT * FROM messages");
    }
    catch(java.sql.SQLException e){
        e.printStackTrace();
    }
}

void closeDB() {
    try{
        stmt.close();
        con.close();
        System.out.println("Database connections closed");
    }
    catch(java.sql.SQLException e){
        System.out.println("Could not close connection!");
    }
}

%>

<style>
.user_img{
	height: 70px;
	width: 70px;
	border:1.5px solid #f5f6fa;
}
.user_img_msg{
	height: 40px;
	width: 40px;
	border:1.5px solid #f5f6fa;
}
.img_cont{
	position: relative;
	height: 70px;
	width: 70px;
}
.img_cont_msg{
	height: 40px;
	width: 40px;
}
.msg_container{
	margin-top: auto;
	margin-bottom: auto;
	margin-left: 10px;
	border-radius: 25px;
	padding: 10px;
	position: relative;
}
.old-message {
	background-color: #70caff;
}
.new-message {
	background-color: #acf99e;
}
</style>
</head>
<body>

<!-- Start of HTML structure -->
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
			<input type='text' class='form-control' name='imageURL'>
		</div>
		<div class='col-12'>
		    <label class='form-label'>message</label>
	      	<textarea class="form-control" name="message" rows="3"></textarea>
		</div>
		<button type='submit' class='btn btn-primary col-6 col-sm-12'>Send</button>
	</form>
	<%
	}
	// POST Handler
	if(request.getMethod().equals("POST")) {
		
		openDB(); // establish db connection
		
		// Incoming form data
        String username = request.getParameter("username");
        String image = request.getParameter("imageURL");
        String message = request.getParameter("message");
        java.sql.Timestamp timestamp = new java.sql.Timestamp(System.currentTimeMillis());
        
        insertData(username, image, message, timestamp);
        getData();
    try {
       	while(results.next()) {
       		// display newest message or messages by the same username on one side
       		if(results.isLast() || results.getString("username").equals(username)){
       			%>
   				<!-- recent message -->
				<div class="card-body msg_card_body align-items-center">
					<div class="d-flex justify-content-end mb-4 align-items-center">
						<div class="msg_container new-message">
							<% out.print(results.getString("message")); %>
							<br>
							<span class="msg_time"><% out.print(results.getString("timestamp")); %></span>
						</div>
						<div class="img_cont_msg">
							<img src="<% out.print(results.getString("image")); %>" class="rounded-circle user_img_msg">
						</div>
					</div>
				</div>
       			<%
       		} else {
    			%>
   				<!-- List Messages -->
				<div class="card-body msg_card_body align-items-center">
					<div class="d-flex justify-content-start mb-4 align-items-center">
						<div class="img_cont_msg">
							<img src="<% out.print(results.getString("image")); %>" class="rounded-circle user_img_msg">
						</div>
						<div class="msg_container old-message">
							<% out.print(results.getString("message")); %>
							<br>
							<span class="msg_time"><% out.print(results.getString("timestamp")); %></span>
					</div>
					</div>
				</div>
	     		<%
       		}
      	}
  	}
  	catch(Exception e){
		e.printStackTrace();
  	}
		// close connection 
		closeDB();
	}
	%>
</div>
</body>
</html>