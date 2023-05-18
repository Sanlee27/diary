<%@ page import="java.sql.PreparedStatement"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import = "java.sql.PreparedStatement" %>
<%@ page import = "java.sql.ResultSet" %>
<%
	
	
	// 1) mariaDB 프로그램 사용가능하도록 장치드라이버를 로딩	
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버로딩성공");
	
	// 2) mariaDB에 로그인 후 접속정보 반환받아야 한다.
	Connection conn = null; // 접속 정보 타입
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	System.out.println("접속성공"+conn);
	
	// 3) 쿼리생성 후 실행
	String sql = "SELECT * FROM student";
	PreparedStatement stmt = conn.prepareStatement(sql);
	ResultSet rs = stmt.executeQuery();
	System.out.println("쿼리실행 성공"+rs);
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>student.jsp</title>
<style>
	table, td, th {
		border: 1px solid #000000;
		border-collapse:collapse;
		text-align: center;
	}
</style>
</head>
<body>
	<table>
		<tr>
			<th>no</th>
			<th>name</th>
			<th>age</th>
		</tr>
		
		<%
			while(rs.next()){
		%>
			<tr>
				<td><%=rs.getInt("st_no")%></td>
				<td><%=rs.getString("st_name")%></td>
				<td><%=rs.getInt("st_age")%></td>
			</tr>
		<%
			}
		%>
	</table>
</body>
</html>