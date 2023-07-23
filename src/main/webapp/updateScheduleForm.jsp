<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %> 
<%@ page import = "java.util.*" %> 
<%@ page import = "vo.*" %>
<%
	// 들어온 date 값이 null이나 공백이면 밑에 진행안하고(return) 돌려보낸다.(sendRedirect)
	if(request.getParameter("scheduleNo")== null || request.getParameter("scheduleNo").equals("")){
		response.sendRedirect("./scheduleList.jsp");
		return;
	}
	
	// 변수저장
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo")); 
	
	// 확인) 변수저장
	System.out.println(scheduleNo + " << scheduleNo");
	
	// DB~~~
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	
	// 저장된 값을 가져오는 쿼리
	String sql = "SELECT schedule_date, schedule_time, schedule_memo, schedule_color, schedule_pw FROM schedule WHERE schedule_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1,scheduleNo);
	
	// 확인) stmt
	System.out.println(stmt + " << stmt");
			
	ResultSet rs = stmt.executeQuery();
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>일정 수정</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<h2>일정 수정</h2>
	<form action="./updateScheduleAction.jsp" method="post">
		<table class ="table table-striped" >
	<%
			if(rs.next()){
	%>			
				<tr>
					<th>일정 번호</th>
					<td>
						<input type="text" name="scheduleNo" value="<%=scheduleNo%>" readonly="readonly"> 
					</td>
				</tr>
				<tr>
					<th>날짜</th>
					<td>
						<input type="date" name="scheduleDate" value="<%=rs.getString("schedule_date")%>">
					</td>
				</tr>
				<tr>
					<th>시간</th>
					<td>
						<input type="time" name="scheduleTime" value="<%=rs.getString("schedule_time")%>">
					</td>
				</tr>
				<tr>
					<th>색상</th>
					<td>
						<input type="color" name="scheduleColor" value="<%=rs.getString("schedule_color")%>">
					</td>
				</tr>
				<tr>
					<th>메모사항</th>
					<td>
						<textarea rows="3" cols="80" name="scheduleMemo"><%=rs.getString("schedule_memo")%></textarea>
					</td>
				</tr>
				<tr>
					<th>비밀번호</th>
					<td>
						<input type="password" name="schedulePw">
					</td>
				</tr>
		<%
			}
		%>
		</table>
		<div>
	        <button type="submit">수정</button>
	        <!-- 버튼 누를 시 name값들이 form action 위치로 post 방식으로, utf-8방식으로 넘어감 -->
	    </div>
	</form>
</body>
</html>