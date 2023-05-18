<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>    
<%
	// 값 확인 입력받은 스케줄no가 null이면 스케줄리스트로 보내고 코드종료 
	if(request.getParameter("scheduleNo") == null || request.getParameter("scheduleNo").equals("")){
		response.sendRedirect("./scheduleList.jsp");
		return;
	}
	
	// 값 저장
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	
	// 확인) 값 저장
	System.out.println(scheduleNo + " <<scheduleNo");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>deleteScheduleForm</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<h2>일정 삭제</h2>
	<form action="./deleteScheduleAction.jsp" method="post">
		<table class ="table table-striped" >
			<tr>
				<th>대상번호</th>
				<td>
					<input type = "text" name = "scheduleNo" value="<%=scheduleNo%>" readonly="readonly">
				</td>
			</tr>
			<tr>
				<th>비밀번호</th>
				<td>
					<input type = "password" name = "schedulePw">
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<button type="submit">삭제</button>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>