<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>

    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>home.jsp</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<!-- 날짜순 최근 공지 5개 / 오늘 일정 5개 -->
	<%	
		// 1)
		Class.forName("org.mariadb.jdbc.Driver");
		// 2)
		java.sql.Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
		
		// 날짜 최근순 공지 5개 
		// select notice_no, notice_title, createdate from notice 
		// order by createdate desc // 역순  
		// limit 0, 5
		String sql1 = "select notice_no, notice_title, createdate from notice order by createdate desc limit 0, 5";
		PreparedStatement stmt1 = conn.prepareStatement(sql1);
		System.out.println(stmt1);
		ResultSet rs1 = stmt1.executeQuery();
		
		// 날짜 오늘 일정 5개
		/* SELECT schedule_no,schedule_date, schedule_time, SUBSTR(schedule_memo,1,10) memo  << memo : substr(schedule_memo,1,10)를 memo 로 줄여서 쓰겠다.
		FROM SCHEDULE
		WHERE schedule_date = CURDATE()
		ORDER BY schedule_time asc; */
		
		String sql2 = "select schedule_no, schedule_date, schedule_time, substr(schedule_memo,1,10) memo from schedule where schedule_date = curdate() order by schedule_time asc";
		PreparedStatement stmt2 = conn.prepareStatement(sql2);
		System.out.println(stmt2 + "<<<< stmt2");
		ResultSet rs2 = stmt2.executeQuery();
		
	%>
	<div class="p-4 bg-dark text-white text-center">
	  <h1>다이어리 프로젝트</h1>
	  <p>
		달력 / 공지사항<br>
	  	기간 : 23.04.19 - 23.04.25 / 	인원 : 1명<br>
	  	개발환경 : Tool_Eclipse / HeidiSQL DB_MariaDB(3.1.3) Tomcat (10.1.7 > 9.0.75)<br> 
	  	개발(구현) 내용<br>
	  	mariaDB 이용 테이블 만들기<br>
	  	DML 이용, 공지사항 / 일정 조회/입력/수정/삭제 가능 Form, Action 생성<br>
	  	Calendar API 이용 달력 출력<br>
	  	달력에 DB연결, 날짜별 데이터 출력<br>
	  	Bootstrap5 이용 CSS적용
	  </p> 
	</div>
	
	<h2>최근순 일정 5개</h2>
		
	<table class ="table table-striped">
		<tr>
			<th>공지 제목</th>
			<th>작성일자</th>
		</tr>
		<%
			while(rs1.next()){
		%>
			<tr>
				<td>
					<a href="./noticeOne.jsp?noticeNo=<%=rs1.getInt("notice_no")%>">
						<%=rs1.getString("notice_title")%>
					</a>			
				</td>
				<td><%=rs1.getString("createdate").substring(0, 10)%>
				</td>
			</tr>
		<%
			}
		%>				
	</table>
	
	
	<h2>오늘 일정 5개</h2>
	<table class ="table table-striped">
		<tr>
			<th>날짜</th>
			<th>시간</th>
			<th>메모사항</th>
		</tr>
		<%
			while(rs2.next()){
		%>
			<tr>
				<td>
					<a href="./scheduleList.jsp">
						<%=rs2.getString("schedule_date")%>
					</a>			
				</td>
				<td><%=rs2.getString("schedule_time")%></td>
				<td><%=rs2.getString("memo")%></td>
			</tr>
		<%
			}
		%>				
	</table>
	<div><!-- 메인메뉴 -->
		<a class="btn btn-danger" href="./home.jsp">홈으로</a>
		<a class="btn btn-danger" href="./noticeList.jsp">공지 리스트</a>
		<a class="btn btn-danger" href="./scheduleList.jsp">일정 리스트</a>
	</div>
</body>
</html>