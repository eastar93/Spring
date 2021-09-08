<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>온도 체크</h1>
	<p>현재 온도 입력</p>
	<form action = "/cToF" method="post">
		온도 : <input type="number" name = "Cel" required><br/>
			  <input type="submit" value="입력">
	</form>
</body>
</html>