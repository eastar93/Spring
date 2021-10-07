<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- 1. jquery 입력받을수 있도록 처리 -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-F3w7mX95PdgyTmZZMECAngseQB83DfGTowi0iMjiWaeVhAn4FJkqJByhZMI3AhiU" crossorigin="anonymous">
<style>
		#modDiv {
			width: 300px;
			height: 100px;
			background-color: green;
			position: absolute;
			top: 50%;
			left: 50%;
			margin-top: -50px;
			margin-left: -150px;
			padding: 10px;
			z-index: 1000;
		}
	</style>
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
	
	<hr>
	
	<h2>댓글 쓰기</h2>
	
		<div>
			<div>
				REPLYER <input type="text" name="replyer" id="newReplyWriter"> 
			</div>
			<div>
				REPLY TEXT <input type="text" name="reply" id="newReply">
			</div>
			<button id="replyAddBtn">ADD REPLY</button>
		</div>
	<!-- 3. 모달창, 기타 ajax 호출 로직을 가져와서 실제로 작동하는지 확인해주세요. -->
	<div id="modDiv" style="display:none;">
		<div class="modal-title"></div>
			<div>
				<input type="text" id="replytext">
			</div>
		<div>
			<button type="button" id="replyModBtn">Modify</button>
			<button type="button" id="replyDelBtn">Delete</button>
			<button type="button" id="closeBtn">Close</button>
		</div>
	</div>
	
	<hr>
	
	<h2>댓글 영역</h2>
	
	<ul id="replies">

	</ul>
	
	
	<!-- 2. body태그 하단에 script태그 작성 후 var bno = ${vo.bno}로 글 번호를
		받은 다음 function getAllList()를 test.jsp에서 복붙해서 게시물별 페이지에서
		잘 작동하는지 확인도 해주세요. -->
	<script>
		var bno = ${detail.bno};
			
			function getAllList() {		
			$.getJSON("/replies/all/" + bno, function(data) {
				// data 변수가 바로 얻어온 json데이터의 집합
				console.log(data.length);
				
				// str 변수 내부에 문자 형태로 html 코드를 작성함
				var str = "";
				
				$(data).each(function() { 
					// $(data).each()는 향상된 for문처럼 내부데이터를 하나하나 반복합니다.
					// 내부 this는 댓글 하나하나입니다.
					// 시간 형식을 우리가 쓰는 형식으로 변경
					var timestamp = this.updateDate;
					var date = new Date(timestamp);
					// data만으로도 시간표시는 우리가 아는 형태로 할 수 있지만 보기 불편함
					console.log(date);
					// data 내부의 시간을 형식(format)화 해서 출력
					var formattedTime = "게시일 : " + date.getFullYear() // 년도 추출
												+ "/" + (date.getMonth()+1) // month는 0월부터 시작
												+ "/" + date.getDate() // 날짜 추출
												+ "/" + date.getHours() // 시간 추출
												+ ":" + date.getMinutes() // 분 추출
												+ ":" + date.getSeconds() // 초 추출
												
					// this.updateDate로 표출하면 시간이 unix시간으로 표시됨
					str += "<div class='replyLi' data-rno='" + this.rno + "'><strong>@"
						+ this.replyer + "</strong> - " + formattedTime  + "<br>"
						+ "<div class='reply'>" + this.reply + "</div>"
						+ "<button type='button' class='btn btn-info'>수정/삭제</button>"
						+ "</div>";
						
					$("#replies").html(str);
					});
				});
			}
		getAllList();
		
		// 비동기 코드
		// 글쓰기 로직
		$("#replyAddBtn").on("click", function(){
	
		// 각 input태그에 들어있던 글쓴이, 본문의 value값을 변수에 저장함.
		var replyer = $("#newReplyWriter").val();
		var reply = $("#newReply").val();
			
		$.ajax({
			type : 'post',
			url : '/replies/',
			headers : {
				"Content-Type" : "application/json",
				"X-HTTP-Method-Override" : "POST"
			},
			dataType : 'text',
			data : JSON.stringify({
				bno : bno,
				replyer : replyer,
				reply : reply
			}),
			success : function(result) {
				if(result == 'SUCCESS') {
					
					alert("등록 되었습니다");
					$("#newReplyWriter").val("");
					$("#newReply").val("");
					
					// 댓글 쓰고 나서 다시 새롭게 갱신된 목록을
					// 넣어주도록 전체 댓글 목록 다시 조회
					getAllList();
				} 
			},
			error : function(result){
				console.log("에러가 났습니다.");
			}
		});
	});

	// 댓글 삭제 로직	
	$("#replyDelBtn").on("click", function() {
		// 삭제에 필요한 댓글번호 모달 타이틀 부분에서 얻기
		var rno = $(".modal-title").html();
		// 삭제도 마찬가지로 접근해야합니다.
		console.log("삭제버튼 눌렀을때 값 얻는지 확인" + rno);
		
		$.ajax({
			type : 'delete',
			url : '/replies/' + rno,
			// 전달 데이터가 없이 url과 호출타입만으로 삭제처리하므로
			// 이외 정보는 제공할 필요가 없음
			success : function(result) {
				if(result === 'SUCCESS') {
					alert(rno + "번 댓글이 삭제되었습니다.");
					// 댓글 삭제 후 모달창 달고 새 댓글목록 갱신
					$("#modDiv").hide("slow");
					getAllList();
				}
			}
		})
	});
	
	// 댓글 수정 로직(rno, reply필요)
	$("#replyModBtn").on("click", function() {
		// 수정에 필요한 댓글번호 모달 타이틀 부분에서 얻기
		var rno = $(".modal-title").html();
		//수정에 필요한 본문내역을 #reply의 value값으로 얻기
		var reply = $("#replytext").val();
		// 수정시 정보를 얻는지 디버깅을 해봐야합니다.
		console.log("수정버튼 눌렀을때 얻은 rno : " + rno);
		console.log("수정버튼 눌렀을때 얻은 reply : " + reply);
		
		$.ajax({
			type : 'patch',
			url : '/replies/' + rno,
			headers : {
				"Content-Type" : "application/json",
				"X-HTTP-Method-Override" : "PATCH"
			},
			dataType : 'text',
			data : JSON.stringify({reply:reply}),
			success : function(result) {
				if(result === 'SUCCESS') {
					alert(rno + "번 댓글이 수정되었습니다.");
					// 댓글 수정 후 모달창 닫고 새 댓글목록 갱신
					$("#modDiv").hide("slow");
					getAllList();
				}
			}
		})
	});
	
	
	// 이벤트 위임 
	// 내가 현재 이벤트를 걸려는 집단(button)을 포함하면서 범위가 제일 좁은
	// #replies로 시작조건을 잡습니다
	// .on("click", "목벅지 태그까지 요소들", function(){실행문})과 같이
	// 위임시는 파라미터가 3개 들어갑니다.
	$("#replies").on("click", ".replyLi button", function(){
		// this는 최 하위태그인 button, button의 부모면 결국 .replyLi
		var replyLi = $(this).parent();
		
		// .attr("속성명")을 하면 해당 속성의 값을 얻습니다.
		var rno = replyLi.attr("data-rno"); 
		// 버튼의 형제태그중 .reply의 내부 텍스트얻기
		// 아래처러 ㅁ하면 this의 부모의 형제가 됩니다. 제가 적은건 형제태그지 부모의 형제가 아닙니다.
		var reply = $(this).siblings(".reply").text();
		
		// 버튼의 부모(replyLi)의 자식(.reply) div class="reply"의 내부텍스트 얻기
		// var reply = $(this).parent().childrens(".reply").text();
		
		
		// 클릭한 버튼에 해당하는 댓글번호 + 본문이 얻어지나 디버깅
		console.log(rno + ":" + reply);
		
		$(".modal-title").html(rno);
		$("#replytext").val(reply);
		$("#modDiv").show("slow");
	});
	
	// 모달 닫기 : closeBtn을 눌렀을때 #modDiv가 hide되도록 해야함
	$("#closeBtn").on("click", function() {
		$("#modDiv").hide("slow");
	})
	
	</script>
		
</body>
</html>