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
	${vo}<br/>
	페이지번호 : ${param.pageNum}<br/>
	검색조건 : ${param.searchType}<br/>
	키워드 : ${param.keyword}<br/>
	<!-- 수정을 하면서 결과페이지에 페이지번호, 검색조건, 키워드를 넘겨야함 
	수정로직은 post이기 때문에 어쩔수 없이 컨트롤러를 경유해서 데이터를 전달합니다.
	controller내부의 modify메서드에 위의 3가지 정보를 모두 처리할 수 있는
	SearchCriteria를 추가로 선언해서 받아줍니다. -->
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
			<tr>
				<td><input type="hidden" name="pageNum" value="${param.pageNum}"></td>
			</tr>
			<tr>
				<td><input type="hidden" name="searchType" value="${param.searchType}"></td>
			</tr>
			<tr>
				<td><input type="hidden" name="keyword" value="${param.keyword}"></td>
			</tr>
		</table>
			<input type="submit" value="글수정"/>
			<input type="reset" value="초기화"/>	
	</form>	
</body>
</html>