<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import = "vo.*" %>
    
<%
	if(request.getParameter("noticeNo") == null
		||request.getParameter("noticeNo").equals("")){
		response.sendRedirect("./home.jsp");
		return; // 1) 코드진행종료 2) 반환값을 남길때
	}

	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	
	Class.forName("org.mariadb.jdbc.Driver");
	java.sql.Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	
	/*
	select notice_no, notice_title, notice_content, notice_writer, createdate, updatedate 
	from notice 
	where notice_no = ?
	*/
	
	String sql = 
			"select notice_no, notice_title, notice_content, notice_writer, createdate, updatedate from notice where notice_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1,noticeNo); //stmt의 첫번째 ? 를 noticeNo로 변경
	System.out.println(stmt + " <--stmt");
	ResultSet rs = stmt.executeQuery();
	
	
	//초기화 밑에서 반복되니까 위에서 담아서 밑에다 쓰게/ 한번만 반복되니까 여기에 이렇게하고, 여러번 반복될 경우 ArrayList에 담음. 페이지 import 해주기
	// int totalCnt; ArrayList<Notice> list
	// Notice notice = new Notice();
	Notice notice = null; 
	if(rs.next()) {
		notice = new Notice();
		notice.noticeNo = rs.getInt("notice_no");
		notice.noticeTitle = rs.getString("notice_title");
		notice.noticeContent = rs.getString("notice_content");
		notice.noticeWriter = rs.getString("notice_writer");
		notice.createdate = rs.getString("createdate");
		notice.updatedate = rs.getString("updatedate");
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>noticeOne</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<h1>공지 상세</h1>
		<table class ="table table-striped" >
			<tr>
				<th>공지 번호</th>
				<td><%=notice.noticeNo%></td>
			</tr>
			<tr>
				<th>공지 제목</th>
				<td><%=notice.noticeTitle%></td>
			</tr>
			<tr>
				<th>공지 내용</th>
				<td><%=notice.noticeContent%></td>
			</tr>
			<tr>
				<th>작성자</th>
				<td><%=notice.noticeWriter%></td>
			</tr>
			<tr>
				<th>작성일자</th>
				<td><%=notice.createdate%></td>
			</tr>
			<tr>
				<th>수정일자</th>
				<td><%=notice.updatedate%></td>
			</tr>
		</table>
	<div>
		<a class="btn btn-primary" href="./updateNoticeForm.jsp?noticeNo=<%=noticeNo%>">수정</a>
		<a class="btn btn-primary" href="./deleteNoticeForm.jsp?noticeNo=<%=noticeNo%>">삭제</a>
	</div>
	<br>
	<div><!-- 메인메뉴 -->
		<a class="btn btn-danger" href="./home.jsp">홈으로</a>
		<a class="btn btn-danger" href="./noticeList.jsp">공지 리스트</a>
		<a class="btn btn-danger" href="./scheduleList.jsp">일정 리스트</a>
	</div>
</body>
</html>