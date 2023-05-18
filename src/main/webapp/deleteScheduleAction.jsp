<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>    
<%
	// 삭제버튼 눌러스 들어온 스케줄no가 제대로 인지 아니면 다시 response하고 이하 코드는 진행시키지않는다
	if(request.getParameter("scheduleNo")==null || request.getParameter("scheduleNo").equals("")){
			response.sendRedirect("./scheduleList.jsp");
			return;
	}
	
	// no를 정수값에 넣음
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	System.out.println(scheduleNo + " << scheduleNo");
	
	// 다른 표시값 확인  pw
	// 값이 입력이 안되면 수정전페이지 > 새로고침
	if(request.getParameter("schedulePw")==null || request.getParameter("schedulePw").equals("")){		
			response.sendRedirect("./deleteScheduleForm.jsp?scheduleNo="+scheduleNo);
			return;
	}	
	// 스케줄 Pw
	String schedulePw = request.getParameter("schedulePw");
	System.out.println(schedulePw + " << schedulePw");
	
	
	// DB,,,		
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
		
	// 데이터 가져오는 쿼리 >> 리다이렉션 나중에 값 삭제하고 나서 다시 원래 페이지 보여주기 위한 날짜값 구해야되니까 일단 가져오는거
	String sql = "SELECT * FROM schedule where schedule_no = ? ";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, scheduleNo);
	System.out.println(stmt + " << scheduleNo 가져온값");
	
	// 날짜
	/* ResultSet.next() 메소드는 커서의 다음 행이 존재할 경우 true를 리턴하고 커서를 그 행으로 이동시킨다.
	next() 메소드는 커서의 다음 행이 존재할 경우 true를 리턴하고 커서를 그 행으로 이동시킨다.
	next() 메소드를 계속해서 호출하면 커서는 순차적으로 다음 행으로 이동하게 된다.
	마지막 행에 커서가 도달하면 next()메소드는 false를 리턴한다. 230425 출처)구글링 */

	ResultSet rs = stmt.executeQuery();
	String scheduleDate = null;
	if(rs.next()){
		scheduleDate = rs.getString("schedule_date"); //getString > 지정컬럼값을 String으로 읽어온다.
	}
	System.out.println(scheduleDate + " << scheduleDate");
	
	//년 월 일 값 각각 저장 > 페이지 주소에 입력 2023 04 25
	String y = scheduleDate.substring(0, 4);
	int m = Integer.parseInt(scheduleDate.substring(5, 7)) - 1;
	String d = scheduleDate.substring(8); 
	
	//  삭제 쿼리
	String sql2 = "DELETE FROM schedule where schedule_no=? and schedule_pw=?";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	stmt2.setInt(1, scheduleNo);
	stmt2.setString(2, schedulePw);
	
	// 확인) stmt2 삭제쿼리
	System.out.println(stmt2 + " << stmt2");
	
	// 영향받은 행	execute~ 실행해라 / 업데이트를
	int row = stmt2.executeUpdate();
	
	// 확인) row
	System.out.println(row + " <<<row");
	
	// 영향받은 행 별 이동방향
	if(row == 0){ // 영향x
		response.sendRedirect("./deleteScheduleForm.jsp?scheduleNo="+scheduleNo);
		System.out.println("다시 시도하십시오");
	} else if(row == 1){ // 영향o
		response.sendRedirect("./scheduleListByDate.jsp?y="+y+"&m="+m+"&d="+d);
	} else { // 에러 : 아예 실행 취소
		System.out.println("error row값 :" + row);
	}
%>