<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>글 본문 페이지</h1>
	글 번호 : ${detail.bno} <br>
	글 제목 : ${detail.title} <br>
	글 쓴이 : ${detail.writer} <br>
	글 내용 : ${detail.content} <br>
	글 작성일 : ${detail.regdate} <br>
	글 수정일 : ${detail.updatedate} <br>
	<a href="/board/list?pageNum=${param.pageNum}&searchType=${param.searchType}&keyword=${param.keyword}"><button>목록으로</button></a><br/>
		
	<%-- pageNum, searchType, keyword 들어오는지 여부 디버깅
	EL의 ${param.파라미터명}을 이용해 확인가능 
	get 파라미터에 SearchCriteria를 선언해서 처리해도 되지만
	pageNum, searchType, keyword가 DB에 연계된 작업을 하지 않으므로
	굳이 두 군데를 고치지 않고 get.jsp에서 바로 받아 쓸 수 있도록
	아래와 같이 활용하는게 효율적입니다.--%>
	페이지번호 : ${param.pageNum}<br/>
	검색조건 : ${param.searchType}<br/>
	키워드 : ${param.keyword}<br/>	
	
	<!-- 글 삭제용 버튼
	글 삭제가 되면, 리스트페이지로 넘어가는데, 삭제로 넘어오는 경우는
	alert()창을 띄워서 "글이 삭제되었습니다"가 출력되도록 로직을 짜주세요. -->
	<form action = "/board/boardmodify" method="post">
		<input type="hidden" name="bno" value="${detail.bno}">
		<input type="hidden" name="pageNum" value="${param.pageNum}">
		<input type="hidden" name="searchType" value="${param.searchType}">
		<input type="hidden" name="keyword" value="${param.keyword}">
		<input type="submit" value="글수정">
	</form>
	<form action ="/board/remove" method="post">
		<input type="hidden" name="bno" value="${detail.bno}">
		<input type="hidden" name="page" value="${param.page}">
		<input type="hidden" name="searchType" value="${param.searchType}">
		<input type="hidden" name="keyword" value="${param.keyword}">
		<input type="submit" value="글삭제">
	</form>
</body>
</html>