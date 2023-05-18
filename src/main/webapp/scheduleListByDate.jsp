<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import = "vo.*" %>
<%
	// y, m, d 값이 null or "" -> redirection scheduleList.jsp
	
	int y = Integer.parseInt(request.getParameter("y"));
	// 자바API에서 12월 11, 마리아DB에서 12월 12
	int m = Integer.parseInt(request.getParameter("m")) + 1;
	int d = Integer.parseInt(request.getParameter("d"));
	
	System.out.println(y + " <-- scheduleListByDate param y");
	System.out.println(m + " <-- scheduleListByDate param m");
	System.out.println(d + " <-- scheduleListByDate param d");
	
	//""을 붙혀 int를 문자로 변환
	String strM = m+""; 
	if(m<10){
		strM = "0"+strM;
	}
	
	String strD = d+"";
	if(d<10){
		strD = "0"+strD;
	}
	
	// 일별 스케줄 리스트
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	String sql = "SELECT * FROM schedule WHERE schedule_date = ? ORDER BY schedule_time ASC";
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	stmt.setString(1, y+"-"+strM+"-"+strD);
	System.out.println(stmt + " <<< 쿼리실행문");
	
	ResultSet rs = stmt.executeQuery();
	
	//초기화 밑에서 반복되니까 위에서 담아서 밑에다 쓰게/ 한번만 반복되니까 여기에 이렇게하고, 여러번 반복될 경우 ArrayList에 담음. 페이지 import 해주기
	// int totalCnt; ArrayList<Schedule> list
	//  schedule = new Schedule();
	Schedule schedule = null; 
	if(rs.next()) {
		schedule = new Schedule();
		schedule.scheduleNo = rs.getInt("schedule_no");
		schedule.scheduleTime = rs.getString("schedule_time");
		schedule.scheduleMemo = rs.getString("schedule_memo");
		schedule.createdate = rs.getString("createdate");
		schedule.updatedate = rs.getString("updatedate");
	}
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>scheduleListByDate</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<h2>스케줄 입력</h2>
	<form action="./insertScheduleAction.jsp" method="post">
		<table class ="table table-striped">
			<tr>
				<th>날짜</th>
				<td><input type = "date" name = "scheduleDate" value = "<%=y%>-<%=strM%>-<%=strD%>" readonly="readonly"></td>
			</tr>
			<tr>
				<th>시간</th>
				<td><input type = "time" name = "scheduleTime"></td>
			</tr>
			<tr>
				<th>지정 색상</th>
				<td><input type = "color" name = "scheduleColor" value = "#000000"></td>
			</tr>
			<tr>
				<th>내용</th>
				<td><textarea rows="3" cols="80" name="scheduleMemo"></textarea></td>
			</tr>
			<tr>
				<th>비밀번호</th>
				<td><input type="password" name="schedulePw"></td>
			</tr>
		</table>
		<button type = "submit">등록</button>
		<button type = "button" onclick="location.href='./scheduleList.jsp'">이전으로</button>
	</form>
	<h2><%=y%>년 <%=m%>월 <%=d%>일 스케줄 목록</h2>
	<table class ="table table-striped">
		<tr>
			<th>시간</th>
			<th>내용</th>
			<th>생성일자</th>
			<th>수정일자</th>
			<th>수정</th>
			<th>삭제</th>
		</tr>
			<tr>
				<td><%=schedule.scheduleTime%></td>
				<td><%=schedule.scheduleMemo%></td>
				<td><%=schedule.createdate%></td>
				<td><%=schedule.updatedate%></td>
				<td><a href="./updateScheduleForm.jsp?scheduleNo=<%=schedule.scheduleNo%>">수정</a></td>
				<td><a href="./deleteScheduleForm.jsp?scheduleNo=<%=schedule.scheduleNo%>">삭제</a></td>
			</tr>
	</table>
</body>
</html>