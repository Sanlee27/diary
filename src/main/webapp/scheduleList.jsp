<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %> 
<%@ page import = "java.util.*" %> 
<%@ page import = "vo.*" %> <!-- >>  패키지 -->
<%
	// 날짜 먼저 넘기기
	int targetYear = 0;
	int targetMonth = 0;
	
	// 년 or 월이 안넘어오면(null) 오늘 날짜의 년과 월로 설정한다.
	if(request.getParameter("targetYear") == null || request.getParameter("targetYear") == null) {
		
		Calendar c = Calendar.getInstance();
		
		targetYear = c.get(Calendar.YEAR);
		targetMonth = c.get(Calendar.MONTH);
		
	} else {
		// 아니면 입력값을 받아오고.
		targetYear = Integer.parseInt(request.getParameter("targetYear"));
		targetMonth = Integer.parseInt(request.getParameter("targetMonth"));
	}
	// 확인) targetYear / targetMonth
	System.out.println(targetYear + " << scheduleList param targetYear");
	System.out.println(targetMonth + " << scheduleList param targetMonth");
	
	// 오늘 날짜
	
	Calendar today = Calendar.getInstance();
	int todayDate = today.get(Calendar.DATE);
	
	// 확인) 오늘날짜 - todayDate
	System.out.println(todayDate + " << todayDate");
	
	// targetMonth 1일
	Calendar firstDay = Calendar.getInstance(); // 2023 04 24
	firstDay.set(Calendar.YEAR, targetYear);  // 2023 ↓
	firstDay.set(Calendar.MONTH, targetMonth); // 2023 04 ↓ 
	firstDay.set(Calendar.DATE, 1); 		  // 2023 04 01 
	
	// 년 23 / 월 12 입력 > Calendar API 년 24 / 월 01 입력
	// 년 23 / 월 -1 입력 > Calendar API 년 22 / 월 12 입력
	targetYear = firstDay.get(Calendar.YEAR);
	targetMonth = firstDay.get(Calendar.MONTH);
	
	// 확인) targetYear/Month
	System.out.println(targetYear + " <-- api적용 후 targetYear");
	System.out.println(targetMonth + " <-- api적용 후 targetMonth");
	
	int firstYoil = firstDay.get(Calendar.DAY_OF_WEEK); // 2023 04 01 몇번째 요일인지? ) 일1, 월2, ... ,토7
	
	// 1일 앞의 공백수(이전달)
	int startBlank = firstYoil - 1;
	
	// 확인) 월초 공백수
	System.out.println(startBlank + " << startBlank");
	
	// targetMonth 막일
	int lastDate = firstDay.getActualMaximum(Calendar.DATE);
	
	// 전체 TD의 7로 나눈 나머지값은 0
	// 막일 뒤의 공백수(다음달)
	int endBlank = 0;
	if((startBlank + lastDate) % 7 != 0 ){
		endBlank = 7 - (startBlank + lastDate)%7;
	}
	// 확인) 월말 공백수
	System.out.println(endBlank + " < 막일 뒤의 공백수");
			
	// 전체 TD의 개수
	int totalTD = startBlank + lastDate + endBlank;
	
	// 확인) 전체 TD 개수
	System.out.println(totalTD + " < 전체 TD 개수");
	
	// db data를 가져오는 알고리즘
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	
	/* 	select 
			schedule_no scheduleNo,
			month(schedule_date) scheduelDate,
			substr(schedule_memo, 1, 5) scheduleMemo, 
			schedule_color scheduleColor
		from schedule
		where year(schedule_date) = ? and month(schedule_date) = ?
		order by month(schedule_date) asc;          >> schedule_date의 month가 작은것부터 정렬.
	*/
	
	// select schedule_no scheduleNo, ,,,  >> as 생략; a (as) b >> a를 b로 변환한다
	PreparedStatement stmt = conn.prepareStatement(
			"select schedule_no scheduleNo, day(schedule_date) scheduleDate, substr(schedule_memo, 1, 5) scheduleMemo, schedule_color scheduleColor from schedule where year(schedule_date) = ? and month(schedule_date) = ? order by month(schedule_date) asc");
	stmt.setInt(1, targetYear);
	stmt.setInt(2, targetMonth + 1);
	System.out.println(stmt + " <-- stmt");
	ResultSet rs = stmt.executeQuery();
	
	// ResultSet > ArrayList<Schedule>
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	
	while(rs.next()){
		Schedule s = new Schedule();
		s.scheduleNo = rs.getInt("scheduleNo");
		s.scheduleDate = rs.getString("scheduleDate"); // 전체 날짜가 아닌 일(day)만
		s.scheduleMemo = rs.getString("scheduleMemo"); // 전체 메모가 아닌 5글자만 > substr(...)
		s.scheduleColor = rs.getString("scheduleColor");
		scheduleList.add(s);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>scheduleList.jsp</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>

<style>
	th {text-align: center;}
	td {
		width:100px; height: 100px;
	}
</style>
</head>
<body>
	<h2><%=targetYear%>년 <%=targetMonth+1%>월</h2>
	<div>
		<a class="btn btn-danger" href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth-1%>">이전달</a>
		<a class="btn btn-danger" href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth+1%>">다음달</a>
	</div>
	<table class ="table table-striped" style="width: 80%; height: 60%;">
		<tr>
			<th>일</th>
			<th>월</th>
			<th>화</th>
			<th>수</th>
			<th>목</th>
			<th>금</th>
			<th>토</th>
		</tr>
		<tr>
			<%
				for(int i=0; i<totalTD; i++){
					int num = i-startBlank+1;
					
					if(i!=0 && i%7 == 0){
			%>
						</tr><tr>
			<%		
					}
					String tdStyle = "";
					if(num > 0 && num <= lastDate ) {
						// 오늘 날짜이면(년 월 일 다 같으면)
						if(today.get(Calendar.YEAR) == targetYear && today.get(Calendar.MONTH) == targetMonth && today.get(Calendar.DATE) == num){
							tdStyle = "background-color : orange;";
						}
			%>
						<td style="<%=tdStyle%>">
							<div><!-- 날짜 숫자 -->
								<a href="./scheduleListByDate.jsp?y=<%=targetYear%>&m=<%=targetMonth%>&d=<%=num%>"><%=num%></a>
							</div>	
							<div><!-- 일정 메모(5글자) -->
								<%
									for(Schedule s : scheduleList){
										if(num == Integer.parseInt(s.scheduleDate)){
								%>
										<div style="color:<%=s.scheduleColor%>"><%=s.scheduleMemo%></div>
								<%
										}
									}
								%>
							</div>
						</td>
			<%
					} else {
			%>
						<td>&nbsp;</td>
			<%		
					}		
				}
			%>
		</tr>
	</table>
	<div ><!-- 메인메뉴 -->
		<a class="btn btn-danger" href="./home.jsp">홈으로</a>
		<a class="btn btn-danger" href="./noticeList.jsp">공지 리스트</a>
		<a class="btn btn-danger" href="./scheduleList.jsp">일정 리스트</a>
	</div>
</body>
</html>