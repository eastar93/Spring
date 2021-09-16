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
	<a href="/board/list">목록으로</a>	
</body>
</html>