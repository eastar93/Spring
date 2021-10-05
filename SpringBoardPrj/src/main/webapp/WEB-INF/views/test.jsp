<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
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
<meta charset="UTF-8">
<title>Insert title here</title>


</head>
<body>

	<h2>Ajax 테스트</h2>
	
		<div>
			<div>
				REPLYER <input type="text" name="replyer" id="newReplyWriter"> 
			</div>
			<div>
				REPLY TEXT <input type="text" name="reply" id="newReply">
			</div>
			<button id="replyAddBtn">ADD REPLY</button>
		</div>
	
	<ul id="replies">
	
	</ul>
	
	<!-- 모달 요소는 안 보이기 때문에 어디 넣어도 되지만 보통 html요소들 끼리 놨을때
		제일 아래쪽에 작성하는 경우가 많습니다 -->
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
	


	<!-- jquery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<!-- 코드는 위에서 아래로 실행되므로 ajax스크립트 태그는 맨 아래에 -->
	<script type="text/javascript">
		
		var bno = 13000;
		
		
			// 비동기 코드
			// 글쓰기 로직
			$("#replyAddBtn").on("click", function(){
		
			// 각 input태그에 들어있던 글쓴이, 본문의 value값을 변수에 저장함.
			var replyer = $("#newReplyWriter").val();
			var reply = $("#newReply").val();
			
			// 디버깅시는 console.log()내부에 적어서 확인합니다.
			// console.log(replyer + "/" + reply);
			
			$.ajax({
				type : 'post',
				url : '/replies/',
				headers : {
					"content-Type" : "application/json",
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
						
						// 댓글 쓰고 나서 다시 새롭게 갱신된 목록을
						// 넣어주도록 전체 댓글 목록 다시 조회
						getAllList();
					} 
				}
			});
		});
	
		// 댓글 삭제 로직	
		$("#replyDelBtn").on("click", function() {
			// 삭제에 필요한 댓글번호 모달 타이틀 부분에서 얻기
			var rno = $(".modal-title").html();
			
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
			var reply = replyLi.text(); // li태그 글씨만 얻기.
			
			// 클릭한 버튼에 해당하는 댓글번호 + 본문이 얻어지나 디버깅
			console.log(rno + ":" + reply);
			
			$(".modal-title").html(rno);
			$("#replytext").val(reply);
			$("#modDiv").show("slow");
		});
		
		
		function getAllList() {		
			$.getJSON("/replies/all/" + bno, function(data) {
				// data 변수가 바로 얻어온 json데이터의 집합
				console.log(data.length);
				
				// str 변수 내부에 문자 형태로 html 코드를 작성함
				var str = "";
				
				$(data).each(function() { 
					// $(data).each()는 향상된 for문처럼 내부데이터를 하나하나 반복합니다.
					// 내부 this는 댓글 하나하나입니다.
					
					str += "<div class='repiyLi' data-rno='" + this.rno + "'><strong>@"
						+= this.replyer + "</strong> - " + this.updateDate + "<br>"
				});
				$("#replies").html(str);	
			
				// #replies인 ul태그에 내부에 str을 끼워넣음
				// ul 내부에 <li>123</li>를 추가하는 구문.
				$("#replies").html(str);
			});
		}
		getAllList();
	</script>
	
	
</body>
</html>