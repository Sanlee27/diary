<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%
	// 파라미터 요청값 유효성 검사
	// storeNo가 null이나 공백 그외일때
	if(request.getParameter("noticeNo") == null){
		response.sendRedirect("./noticeList.jsp"); //noticeList로 이동
		return ;
	}

	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	
	String sql = 
			"select notice_no, notice_title, notice_content, notice_writer, createdate, updatedate from notice where notice_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1,noticeNo); //stmt의 첫번째 ? 를 noticeNo로 변경
	System.out.println(stmt + " <--stmt");
	ResultSet rs = stmt.executeQuery();
	
	rs.next();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>updateNoticeForm</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<h1>공지 수정</h1>
	<div>
		<%
			if(request.getParameter("msg") != null) {
		%>
				<%=request.getParameter("msg")%>
		<%
			}
		%>
	</div>
  <form action="./updateNoticeAction.jsp" method="post">
      <table class ="table table-striped">
         <tr>
            <td>공지 번호</td>
            <td>
               <input type="number" name="noticeNo" 
                  value="<%=rs.getInt("notice_no")%>" readonly="readonly"> 
            </td>
         </tr>
         <tr>
            <td>비밀번호</td>
            <td>
               <input type="password" name="noticePw"> 
            </td>
         </tr>
         <tr>
            <td>공지 제목</td>
            <td>
               <input type="text" name="noticeTitle" 
                  value="<%=rs.getString("notice_title")%>"> 
            </td>
         </tr>
         <tr>
            <td>공지 내용</td>
            <td>
               <textarea rows="5" cols="80" name="noticeContent">
                  <%=rs.getString("notice_content")%>
               </textarea>
            </td>
         </tr>
         <tr>
            <td>작성자</td>
            <td>
               <%=rs.getString("notice_writer")%>
            </td>
         </tr>
         <tr>
            <td>작성일자</td>
            <td>
               <%=rs.getString("createdate")%>
            </td>
         </tr>
         <tr>
            <td>수정일자</td>
            <td>
               <%=rs.getString("updatedate")%>
            </td>
         </tr>
      </table>
      <div>
         <button type="submit">수정</button>
         <!-- 버튼 누를 시 name값들이 form action 위치로 post 방식으로, utf-8방식으로 넘어감 
         	  여기서는 notice_no / pw / title / content -->
      </div>
   </form>
</body>
</html>