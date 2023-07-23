<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%	
	// 파라미터 요청값 유효성 검사
	if(request.getParameter("noticeNo") == null){
		response.sendRedirect("./noticeList.jsp"); // noticeList로 이동
		return; // 코드진행종료
	}

	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	System.out.println(noticeNo + "deleteNoticeForm parameter noticeNo"); // << 디버깅
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>deleteNoticeForm</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<h1>공지 삭제</h1>
	<form action="./deleteNoticeAction.jsp" method="post">
		<table class ="table table-striped" >
			<tr>
				<td>공지 번호</td>
				<td>
					<!-- 수정불가하게 하는 ... 방법 1) 안보이게 2) 읽기만 -->
					<%--<input type="text" name="noticeNo" value="<%=noticeNo--%>
					<input type="text" name="noticeNo" value="<%=noticeNo%>" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td>비밀번호</td>
				<td>
					<input type="password" name="noticePw">
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