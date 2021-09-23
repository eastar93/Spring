<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-F3w7mX95PdgyTmZZMECAngseQB83DfGTowi0iMjiWaeVhAn4FJkqJByhZMI3AhiU" crossorigin="anonymous">
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1 class="text text-primary">게시물 목록</h1>
	
	
	<table class="table table-hover">
		<tr>
			<th>글번호</th>
			<th>글제목</th>
			<th>글쓴이</th>
			<th>작성일</th>
			<th>수정일</th>			
		</tr>
		<c:forEach var="board" items="${list}">
			<tr>
				<td>${board.bno}</td>
				<td><a href="/board/get?bno=${board.bno}">${board.title}</a></td>
				<td>${board.writer}</td>
				<td>${board.regdate}</td>
				<td>${board.updatedate}</td>
			</tr>
		</c:forEach>
		
		
	</table>
	<a href="/board/register"><button>글쓰기</button></a>
	<form action="/board/list" method="get">
		<input type="text" name="keyword" 
		placeholder="검색어" value="${keyword}">
		<input type="submit" value="검색">
	</form>
	
	<!-- 모달 코드는 작성이 안 되어있는게 아니고
	작성은 해뒀지만 css의 display옵션을 none으로 평상시에 두고
	특정한 요건을 만족했을때만 display를 허용하도록 설계되어있습니다.
	그래서 아래와 같이 모달 예시코드를 붙여넣어도 
	일반 화면에서는 보이지 않습니다.-->
	<div class="modal" id="myModal" tabindex="-1">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="글 작성 완료"></h5>
	        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	      </div>
	      <div class="modal-body">
	        <p>${bno}번 글 작성을 완료했습니다.</p>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
	      </div>
	    </div>
	  </div>
	</div>
	 <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-/bQdsTh/da6pkI1MST/rWKFNjaCP5gBSY4sEBT38Q/9RBh9AH40zEOg7Hlq2THRZ" crossorigin="anonymous"></script>
	<script>
	// 컨트롤러에서 success라는 이름으로 날린 자료가 들어오는지 확인
	// 그냥 lsit페이지 접근시는 success를 날려주지 않아서
	// 아무것도 들어오지 않고 
	// remove 로직의 결과로 넘어왔을때만 데이터가 전달됨
	var result = "${success}";
	var bno = "${bno}";
	// 모달 사용을 위한 변수 선언
	// 모달 공식문서의 자바스크립트 관련 실행 코드를 복사합니다.
	var myModal = new bootstrap.Modal(document.getElementById('myModal'), focus)
	console.log(myModal);
	
	
	if(result === "success") {
		alert(bno + "번글이 삭제되었습니다");
	} else if(result === "register") {
		// 공식문서 하단의 modal.show()를 응용합니다.
		myModal.show();
	}
	</script>	
	
</body>
</html>