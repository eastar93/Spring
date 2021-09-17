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
	<a href="/board/list"><button>목록으로</button></a>	
	<!-- 글 삭제용 버튼
	글 삭제가 되면, 리스트페이지로 넘어가는데, 삭제로 넘어오는 경우는
	alert()창을 띄워서 "글이 삭제되었습니다"가 출력되도록 로직을 짜주세요. -->
	<form action = "/board/boardmodify" method="post">
		<input type="hidden" name="bno" value="${detail.bno}">
		<input type="submit" value="글수정">
	</form>
	<form action ="/board/remove" method="post">
		<input type="hidden" name="bno" value="${detail.bno}">
		<input type="submit" value="글삭제">
	</form>
</body>
</html>