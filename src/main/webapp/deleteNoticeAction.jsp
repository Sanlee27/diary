<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.PreparedStatement"%>
<%
	//파라미터 요청값 유효성 검사
	if(request.getParameter("noticeNo") == null
		|| request.getParameter("noticePw") == null
		|| request.getParameter("noticeNo").equals("")
		|| request.getParameter("noticePw").equals("")) {
		// 아이디 비번에 null 값 / 공백값이 들오온다면
	
		response.sendRedirect("./noticeList.jsp");
		return; 
		// 1) 코드진행종료 2) 반환값을 남길때
	}

	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticePw = request.getParameter("noticePw");
	
	// 디버깅
	System.out.println(noticeNo + "deleteNoticeAction param noticeNo");
	System.out.println(noticePw + "deleteNoticeAction param noticePw");

	// delete from notice where notice_no = ? and notice_pw = ? << 삭제쿼리문
		
	// DB 테이블 입력		
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	
	// 쿼리문
	String sql = "delete from notice where notice_no=? and notice_pw=?"; 
	PreparedStatement stmt =conn.prepareStatement(sql);
	stmt.setInt(1, noticeNo);
	stmt.setString(2, noticePw);
	
	// 디버깅
	System.out.println(stmt + "<--deleteNoticeAction sql"); 
	
	int row = stmt.executeUpdate();
	
	//디버깅
	System.out.println(row + "<-- deleteNoticeAction row");
	
	// row: 영향받는 행 / 비밀번호 틀려서 삭제행이 0행이면
	if(row == 0) { 
		response.sendRedirect("./deleteNoticeForm.jsp?noticeNo="+noticeNo);
	//	response.sendRedirect("./noticeOne.jsp?noticeNo="+noticeNo);	
	} else { 
		response.sendRedirect("./noticeList.jsp");
	} 
%>
