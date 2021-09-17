<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>${vo.bno}번글 수정 페이지</h1>
	<form action="/board/modify" method="post">
		<input type="hidden" name="bno" value="${vo.bno}">
		<table>
			<tr>
				<th>제 목</th>
				<td><input type="text" name="title" value="${vo.title}"></td>
			</tr>
			<tr>
				<th>작성자 </th>
				<td><input type="text" name="writer" value="${vo.writer}" readonly></td>
			</tr>
			<tr>
				<th>내용</th>
				<td><textarea rows="20" cols="50" name="content">${vo.content}</textarea></td>
			</tr>
		</table>
			<input type="submit" value="글수정"/>
			<input type="reset" value="초기화"/>	
	</form>	
</body>
</html>