<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>체질량 지수 측정</h1>
	<p>키와 몸무게 입력</p>
	<form action = "/bmi" method="post">
		height : <input type="number" name = "height" placeholder="키(cm)" required> cm<br/> 
		weight : <input type="number" name = "weight" placeholder="몸무게(kg)"required> kg<br/> 
				 <input type="submit" value="입력">
	</form>
</body>
</html>