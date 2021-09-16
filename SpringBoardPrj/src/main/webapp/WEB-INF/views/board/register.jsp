<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>게시물 입력 창</h1>
	<form action="/board/register" method="post">
		<table>
			<tr>
				<th>제 목</th>
				<td><input type="text" name="title"></td>
			</tr>
			<tr>
				<th>작성자 </th>
				<td><input type="text" name="writer"></td>
			</tr>
			<tr>
				<th>내용 </th>
				<td><textarea rows="20" cols="50" name="content"></textarea></td>
			</tr>
		</table>
			<input type="submit" value="글제출"/>
			<input type="reset" value="초기화"/>	
	</form>

</body>
</html>