<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-F3w7mX95PdgyTmZZMECAngseQB83DfGTowi0iMjiWaeVhAn4FJkqJByhZMI3AhiU" crossorigin="anonymous">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<h1 class="text text-primary">게시물 목록</h1>

	<table class="table table-hover">
		<tr>
			<th>글번호</th>
			<th>제목</th>
			<th>글쓴이</th>
			<th>날짜</th>
			<th>최종수정일</th>
		</tr>
		<c:forEach var="board" items="${list }">
			<tr>
				<td>${board.bno }</td>
				<td><a href="/board/get?bno=${board.bno}&pageNum=${btnMaker.cri.pageNum}&searchType=${btnMaker.cri.searchType}&keyword=${btnMaker.cri.keyword}">${board.title }[${board.replycount }]</a></td>
				<td>${board.writer }</td>
				<td>${board.regdate }</td>
				<td>${board.updatedate }</td>
			</tr>
		</c:forEach>
		
	</table>
	
	${btnMaker}<br/>
	페이지번호 : ${btnMaker.cri.pageNum}
	<!-- 페이지네이션 버튼 위치 
	페이지네이션 버튼을 상황에 맞게 출력하기 위해
	c태그라이브러리의 조건식을 활용합니다.-->
	<nav aria-label="Page navigation example">
	  <ul class="pagination justify-content-center">
	  
	  	<!-- prev버튼 
	  	btnMaker의 prev가 true일때만 뒤로가기 버튼 출력-->
	  	<c:if test="${btnMaker.prev}">
	    	<li class="page-item">
	    		<a class="page-link"
	    			href="/board/list?pageNum=${btnMaker.startPage - 1}&searchType=${btnMaker.cri.searchType}&keyword=${btnMaker.cri.keyword}">
	    			Previous
	    		</a>
	    	</li>
	    </c:if>
	    
	    <!-- 번호 버튼 
	    c태그의 forEach기능을 쓰되, begin, end속성을 이용해서
	    startPage부터 endPage까지의 숫자들이 버튼으로 나열되게 만들어주세요. 
	    begin, end에 따른 루프 바퀴에 따른 변수명은 var속성으로 지정합니다.
	    
	    1. 버튼이 갯수 맞게 맞는지부터 확인
	    2. 각 바퀴수별로 다른 수치를 버튼에 새기기 위해서
	       var속성에 변수명 적고 출력
	    		3. 현재 조회중 페이지 강조는 class속성 내에서 삼항연산자를 이용해도 된다.-->
		<c:forEach begin="${btnMaker.startPage}" 
					end="${btnMaker.endPage }"
					var="pageNum"> 
	   		<li class="page-item ${btnMaker.cri.pageNum == pageNum ? 'active' : ''}">
	    		<a class="page-link" 
	    		href="/board/list?pageNum=${pageNum}&searchType=${btnMaker.cri.searchType}&keyword=${btnMaker.cri.keyword}">${pageNum}</a>
	    	</li>
		</c:forEach>
	    
	    <!-- next버튼 -->
	    <c:if test="${btnMaker.next}">
		    <li class="page-item">
		    	<a class="page-link" 
		    	href="/board/list?pageNum=${btnMaker.endPage + 1}&searchType=${btnMaker.cri.searchType}&keyword=${btnMaker.cri.keyword}">Next</a>
		    </li>
		</c:if>
	    
	  </ul>
	</nav>
	
	<a href="/board/register"><button>글쓰기</button></a>
	
	<!-- 검색창 -->
	<form action="/board/list" method="get">
		<!-- option태그를 이용해 검색조건 선택창을 만들어주세요. -->
		<select name="searchType">
			<option value="n" <c:out 
		value="${btnMaker.cri.searchType == null ? 'selected' : '' }" />>
				-
			</option>
			<option value="t" <c:out 
		value="${btnMaker.cri.searchType eq 't' ? 'selected' : '' }" />>
				제목
			</option>
			<option value="c" <c:out 
		value="${btnMaker.cri.searchType eq 'c' ? 'selected' : '' }" />>
				본문
			</option>
			<option value="w" <c:out 
		value="${btnMaker.cri.searchType eq 'w' ? 'selected' : '' }" />>
				글쓴이
			</option>
			<option value="tc" <c:out 
		value="${btnMaker.cri.searchType eq 'tc' ? 'selected' : '' }" />>
				제목+본문
			</option>
			<option value="cw" <c:out 
		value="${btnMaker.cri.searchType eq 'cw' ? 'selected' : '' }" />>
				본문+글쓴이
			</option>
			<option value="tcw" <c:out 
		value="${btnMaker.cri.searchType eq 'tcw' ? 'selected' : '' }" />>
				제목+본문+글쓴이
			</option>
		</select>
		
		
		<input type="text" name="keyword" 
		placeholder="검색어" value="${btnMaker.cri.keyword}" >
		<input type="submit" value="검색하기">
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
	        <h5 class="modal-title">글 작성 완료</h5>
	        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	      </div>
	      <div class="modal-body">
	        <p>${bno }번 글 작성을 완료했습니다.</p>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
	      </div>
	    </div>
	  </div>
	</div>		
	
	 <!-- Option 1: Bootstrap Bundle with Popper 
	 부트스트랩용 JS파일도 마저 임포트
	 코드 진행 순서가 위에서 아래이므로
	 script 태그 위에 먼저 js파일을 집어넣습니다.-->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-/bQdsTh/da6pkI1MST/rWKFNjaCP5gBSY4sEBT38Q/9RBh9AH40zEOg7Hlq2THRZ" crossorigin="anonymous"></script>
	<script>
		// 컨트롤러에서 success라는 이름으로 날린 자료가 들어오는지 확인
		// 그냥 list페이지 접근시는 success를 날려주지 않아서
		// 아무것도 들어오지 않고
		// remove 로직의 결과로 넘어왔을때만 데이터가 전달됨
		var result = "${success}";
		var bno = "${bno}";
		// 모달 사용을 위한 변수 선언
		// 모달 공식문서의 자바스크립트 관련 실행 코드를 복사합니다.
		var myModal = new bootstrap.Modal(document.getElementById('myModal'), focus);
		
		if(result === "success"){
			alert(bno + "번글이 삭제되었습니다.");
		} else if(result === "register"){
			// 공식문서 하단의 modal.show()를 응용합니다.
			myModal.show();
		}
	</script>
	
	
</body>
</html>