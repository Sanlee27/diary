<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	
	// 1. request 인코딩 설정
	request.setCharacterEncoding("utf-8");

	// 2. updateNoticeForm.jsp 에서 받은 4개의 값 확인
	System.out.println(request.getParameter("noticeNo")+"<<<<<<no");
	System.out.println(request.getParameter("noticePw")+"<<<<<password");
	System.out.println(request.getParameter("noticeTitle")+"<<<<<title");
	System.out.println(request.getParameter("noticeContent")+"<<<<<Content");
	
	// 3. 2번에 대한 유효성 검사 > 잘못되면 > 분기 
	// > 리다이렉션(updateNoticeForm.jsp?noticeNo=&msg=
	// || 연산자 >> 앞에꺼 참이면 뒤에꺼 실행안함
	String msg = null;
	if(request.getParameter("noticeNo")==null
			|| request.getParameter("noticeNo").equals("")) {
		response.sendRedirect("./noticeList.jsp");
		return;
	}
	
	if(request.getParameter("noticeTitle")==null
		|| request.getParameter("noticeTitle").equals("")) {
			msg = "noticeTitle is required";
			
	} else if(request.getParameter("noticeContent")==null
		|| request.getParameter("noticeContent").equals("")) {
			msg = "noticeContent is required";
			
	} else if(request.getParameter("noticePw")==null
		|| request.getParameter("noticePw").equals("")) {
			msg = "noticePw is required";
	}
	
	if(msg !=null) { // 위 if else 문에 하나라도 해당된다면
		response.sendRedirect("./updateNoticeForm.jsp?noticeNo="
								+request.getParameter("noticeNo")
								+"&msg=" + msg);
		return;
	}
	
	// 4. 요청값을 변수에 할당 및 형변환
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticeTitle = request.getParameter("noticeTitle");
	String noticeContent = request.getParameter("noticeContent");
	String noticePw = request.getParameter("noticePw");
	
	// 변수 디버깅
	System.out.println(noticeNo + "<<<updateNoticeAction noticeNo");
	System.out.println(noticePw + "<<<updateNoticeAction noticePw");
	System.out.println(noticeTitle + "<<<updateNoticeAction noticeTitle");
	System.out.println(noticeContent + "<<<updateNoticeAction noticeContent");

	
	// 5. mariadb RDBMS에 update문을 전송한다.
	// DB연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	
	// 쿼리문
	String sql = "update notice set notice_title = ?, notice_content = ?, updatedate = now() where notice_no = ? and notice_pw = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1,noticeTitle); //stmt의 첫번째 ? 를 noticeTitle로
	stmt.setString(2,noticeContent); //stmt의 두번째 ? 를 noticeContent로
	stmt.setInt(3,noticeNo); //stmt의 두번째 ? 를 notice_no로
	stmt.setString(4,noticePw); //stmt의 두번째 ? 를 notice_pw로
			
	// 쿼리 디버깅	
	System.out.println(stmt + " <--stmt");
	
	// 영향 받는 행
	// excuteSelect < select를 실행해라
	int row = stmt.executeUpdate();
	
	
	// 6. 5번의 결과에 페이지(View)를 분기한다.
	if(row == 0) {
		response.sendRedirect("./updateNoticeForm.jsp?noticeNo="+request.getParameter("noticeNo")+"&msg= incorrect noticePw");
	} else if (row == 1) {
		response.sendRedirect("./noticeOne.jsp?noticeNo="+noticeNo);
	} else {
		// update문 실행을 취소(롤백)해야 한다.
		System.out.println("error row값 :"+row);
	}		
%>	
