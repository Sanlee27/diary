<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.PreparedStatement"%>
<%
	// post 방식 인코딩 처리
	request.setCharacterEncoding("utf-8");

	// validation (요청 파라미터값 유효성 검사)
	if (request.getParameter("noticeTitle") == null || request.getParameter("noticeContent") == null
			|| request.getParameter("noticeWriter") == null || request.getParameter("noticePw") == null
			|| request.getParameter("noticeTitle").equals("") || request.getParameter("noticeContent").equals("")
			|| request.getParameter("noticeWriter").equals("") || request.getParameter("noticePw").equals("")) {
	
		response.sendRedirect("./insertNoticeForm.jsp");
		System.out.println("문제발생");
		return;
	}
	String noitceTitle = request.getParameter("noticeTitle");
	String noticeContent = request.getParameter("noticeContent");
	String noticeWriter = request.getParameter("noticeWriter");
	String noticePw = request.getParameter("noticePw");
	
	// 값들을 DB 테이블 입력
	/* insert into notice(
			notice_title, notice_content, notice_writer, notice_pw, createdate, updatedate
	 ) values (?,?,?,?,now(),now());
	*/

	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	
	String sql = "insert into notice(notice_title, notice_content, notice_writer, notice_pw, createdate, updatedate) values (?,?,?,?,now(),now())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	// ? 4개(1~4)
	stmt.setString(1, noitceTitle);
	stmt.setString(2, noticeContent);
	stmt.setString(3, noticeWriter);
	stmt.setString(4, noticePw);
	int row = stmt.executeUpdate(); // 디버깅 1이면 1행 입력성공 / 0이면 입력값 없음
	// row 값을 이용한 디버깅
	
	/* conn.commit(); conn.setAutoCommit(true); 디폴트 값이 true 라 자동커밋 -> commit 생략 가능*/
	
	// redirection
	response.sendRedirect("./noticeList.jsp");
%>