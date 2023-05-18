<%@ page import="org.apache.catalina.ha.backend.Sender"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	// 한국말로 값을 받을때 쓰는 인코딩 ex) value="홍길동"
	request.setCharacterEncoding("utf-8");

	// scheduleNo 값이 null이나 공백이면 밑에 진행안하고(return) 돌려보낸다.(sendRedirect)
	if(request.getParameter("scheduleNo") == null || request.getParameter("scheduleNo").equals("")){
		response.sendRedirect("./scheduleList.jsp");
		return;
	}
	
	// 스케줄no값 변환해서 넣음
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	System.out.println(scheduleNo + " << 스케줄No");
	
	// 수정값들 null/공백이면 메세지 표시
	/* msg에 한국말 넣는거는 복잡해서 영어로 적기. 
		한국말 적었을시 오류 메세지 : ~~~인 HTTP 응답 헤더 [Location](이)가 유효하지 않은 값이므로 응답에서 제거되었습니다.
		code point [45,236]에 위치한 유니코드 문자 [내]은(는), 0에서 255까지의 허용 범위 바깥에 있으므로 인코딩될 수 없습니다.
	*/
	String msg = null;
	if(request.getParameter("scheduleDate")==null || request.getParameter("scheduleDate").equals("")){
		msg = "Date Required";
	} else if(request.getParameter("scheduleTime")==null || request.getParameter("scheduleTime").equals("")){
		msg = "Time Required";
	} else if(request.getParameter("scheduleColor")==null || request.getParameter("scheduleColor").equals("")){
		msg = "Color Required";
	} else if(request.getParameter("scheduleMemo")==null || request.getParameter("scheduleMemo").equals("")){
		msg = "Memo Required";
	} else if(request.getParameter("schedulePw")==null || request.getParameter("schedulePw").equals("")){
		msg = "Password Required";
	}
	
	// msg가 null이 아니면 (= 오류가 있으면) 수정폼을 메세지 표시와 함께 다시표시(response)하고 진행안함(return)
	if(msg != null){
		response.sendRedirect("./updateScheduleForm.jsp?scheduleNo="+scheduleNo+"&msg=" + msg);
		return;
	}
	
	// 값 변수에 저장
	String scheduleDate = request.getParameter("scheduleDate");
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleColor = request.getParameter("scheduleColor");
	String scheduleMemo = request.getParameter("scheduleMemo");
	String schedulePw = request.getParameter("schedulePw");
	
	// 확인) 변수 저장
	System.out.println(scheduleDate + " << Date");
	System.out.println(scheduleTime + " << Time");
	System.out.println(scheduleColor + " << Color");
	System.out.println(scheduleMemo + " << Memo");
	System.out.println(schedulePw + " << Pw");

	// db
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	
	// 쿼리
	String sql = "UPDATE schedule SET schedule_date = ?, schedule_time = ?, schedule_color = ?, schedule_memo = ?, updatedate = now() WHERE schedule_no = ? AND schedule_pw = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1,scheduleDate);
	stmt.setString(2,scheduleTime);
	stmt.setString(3,scheduleColor);
	stmt.setString(4,scheduleMemo);
	stmt.setInt(5,scheduleNo);
	stmt.setString(6,schedulePw);
	
	// 확인) 쿼리_stmt
	System.out.println(stmt + " <<< stmt");

	//년 월 일 값 각각 저장
	String y = scheduleDate.substring(0, 4);
	int m = Integer.parseInt(scheduleDate.substring(5, 7)) - 1;
	String d = scheduleDate.substring(8);
	
	// 영향받는 행
	int row = stmt.executeUpdate();
	
	// 결과 분기
	if(row == 0){
		response.sendRedirect("./updateScheduleForm.jsp?scheduleNo="+scheduleNo+ "&msg = schedulePw is incorrect");
	} else {
		response.sendRedirect("./scheduleListByDate.jsp?y="+y+"&m="+m+"&d="+d);
	}
 
%>