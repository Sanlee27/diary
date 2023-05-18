<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%	
	// 한국어 인코딩
	request.setCharacterEncoding("utf-8");
	
	// 들어오는 값 유효한가
	
	// null이나 공백이면
	if(request.getParameter("scheduleDate") == null || request.getParameter("scheduleDate").equals("")
		|| request.getParameter("scheduleTime") == null || request.getParameter("scheduleTime").equals("")
		|| request.getParameter("scheduleColor") == null || request.getParameter("scheduleColor").equals("")
		|| request.getParameter("scheduleMemo") == null || request.getParameter("scheduleMemo").equals("")
		|| request.getParameter("schedulePw") == null || request.getParameter("schedulePw").equals("")){
			// 일로 다시 보내고
			response.sendRedirect("./scheduleList.jsp");
			return; // 끝
	}
		
	// 값 변수에 저장
	String scheduleDate = request.getParameter("scheduleDate");
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleColor = request.getParameter("scheduleColor");
	String scheduleMemo = request.getParameter("scheduleMemo");
	int schedulePw = Integer.parseInt(request.getParameter("schedulePw"));
	
	// 확인) 값 변수 저장
	System.out.println(scheduleDate + " <-- insertScheduleAction.jsp ScheduleDate");
	System.out.println(scheduleTime + " <-- insertScheduleAction.jsp scheduleTime");
	System.out.println(scheduleColor + " <-- insertScheduleAction.jsp scheduleColor");
	System.out.println(scheduleMemo + " <-- insertScheduleAction.jsp scheduleMemo");
	System.out.println(schedulePw + " <-- insertScheduleAction.jsp schedulePw");
	
	// db
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	
	// 쿼리
	String sql = "INSERT INTO schedule(schedule_date, schedule_time, schedule_color, schedule_memo, schedule_pw, createdate, updatedate) values (?, ?, ?, ?, ?, now(), now())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	// ? 값 4개
	stmt.setString(1, scheduleDate);
	stmt.setString(2, scheduleTime);
	stmt.setString(3, scheduleColor);
	stmt.setString(4, scheduleMemo);
	stmt.setInt(5, schedulePw);
	
	// 확인) stmt
	System.out.println(stmt + " << stmt/쿼리");
	
	// 실행 >> 디버깅용도/
	int row = stmt.executeUpdate();
	
	
	// 날짜 변수 저장
	String y = scheduleDate.substring(0,4);
	int m = Integer.parseInt(scheduleDate.substring(5,7))-1 ;
	String d = scheduleDate.substring(8);
	
	// 확인) 날짜 변수
	System.out.println(y + " <-- insertScheduleAction.jsp y");
	System.out.println(m + " <-- insertScheduleAction.jsp m");
	System.out.println(d + " <-- insertScheduleAction.jsp d");
	
	// 결과 별 반환
	if(row==0) {
		response.sendRedirect("./scheduleListByDate.jsp?y="+y+"&m="+m+"&d="+d);
		System.out.println("ERROR row" + row);
	} else if(row==1){
		response.sendRedirect("./scheduleList.jsp");
		System.out.println("정상입력");
	}
	
	
%>