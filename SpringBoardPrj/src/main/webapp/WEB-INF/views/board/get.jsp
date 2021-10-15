<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- 1. jquery 입력받을수있도록 처리 -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-F3w7mX95PdgyTmZZMECAngseQB83DfGTowi0iMjiWaeVhAn4FJkqJByhZMI3AhiU" crossorigin="anonymous">
<style>
	#modDiv {
		width:300px;
		height:100px;
		background-color:green;
		position:absolute;
		top:50%;
		left:50%;
		margin-top:-50px;
		margin-left:-150px;
		padding: 10px;
		z-index:1000;
	}
	
	/* uploadResult 결과물 css */
	.uploadResult {
		width:100%;
		background-color:gray;
	}
	.uploadResult ul {
		display:flex;
		flex-flow:row;
		justify-content:center;
		align-items: center;
	}
	.uploadResult ul li {
		list-style:none;
		padding : 10px;
	}
	.uploadResult ul li img {
		width:20px;
	}
	
</style>
</head>
<body>
	<h1>상세페이지</h1>
	글번호 : ${vo.bno}<br/>
	글제목 : ${vo.title}<br/>
	글본문 : ${vo.content}<br/>
	글쓴이 : ${vo.writer}<br/>
	쓴날짜 : ${vo.regdate} / 최종수정날짜 : ${vo.updatedate}<br/>
	<button><a href="/board/list?pageNum=${param.pageNum}&searchType=${param.searchType}&keyword=${param.keyword}">목록으로</a></button>
	<%-- pageNum, searchType, keyword 들어오는지 여부 디버깅
	EL의 ${param.파라미터명} 을 이용해 확인가능 
	get 파라미터에 SearchCriteria를 선언해서 처리해도 되지만
	pageNum, searchType, keyword가 DB와 연계된 작업을 하지 않으므로
	굳이 두 군데를 고치지 않고 get.jsp에서 바로 받아 쓸 수 있도록 
	아래와 같이 활용하는게 효율적입니다.--%>
	페이지번호 : ${param.pageNum}<br>
	검색조건 : ${param.searchType}<br>
	키워드 : ${param.keyword}<br>
	<!-- 글 삭제용 버튼 
	글 삭제가 되면, 리스트페이지로 넘어가는데, 삭제로 넘어오는 경우는
	alert()창을 띄워서 "글이 삭제되었습니다" 가 출력되도록 로직을 짜주세요.-->
	<form action="/board/remove" method="post">
		<input name="bno" type="hidden" value="${vo.bno}" >
		<input type="submit" value="삭제">
	</form>
	<!-- 수정페이지로 넘어가는 버튼을 추가해주세요. -->
	<form action="/board/boardmodify" method="post">
		<input name="bno" type="hidden" value="${vo.bno}" >
		<input name="pageNum" type="hidden" value="${param.pageNum}" >
		<input name="searchType" type="hidden" value="${param.searchType}" >
		<input name="keyword" type="hidden" value="${param.keyword}" >
		<input type="submit" value="수정">
	</form>
	
	<!-- 첨부파일추가 -->
	<hr>
	<div class="row">
		<h3 class="text-primary">첨부파일</h3>
		<div id="uploadResult">
			<ul>
				<!-- 첨부파일 집어넣을 위치 -->
			</ul>
		</div>
	</div>
	
	
	<hr>
	<h2>댓글 영역</h2>
		
	<!-- 3. 모달창, 기타 ajax 호출 로직을 가져와서 실제로 작동하는지
	확인해주세요. 글쓰기 폼도 가져와서 댓글을 작성해보세요. -->
	<div>
		<div>
			REPLYER <input type="text" name="replyer" id="newReplyWriter">
		</div>
		<div>
			REPLY <input type="text" name="reply" id="newReply">
		</div>
		<button id="replyAddBtn">리플추가</button>
	</div>	
	
	<ul id="replies">
	
	</ul>
	
	
	<!-- 모달 요소는 안 보이기 때문에 어디 넣어도 되지만 보통 html요소들 끼리 놨을때
	제일 아래쪽에 작성하는 경우가 많습니다. -->
	<div id="modDiv" style="display:none;">
		<div class="modal-title"></div>
		<div>
			<input type="text" id="replytext">		
		</div>
		<div>
			<button type="button" id="replyModBtn">수정</button>
			<button type="button" id="replyDelBtn">삭제</button>
			<button type="button" id="closeBtn">닫기</button>
		</div>
	</div>
	
	<!-- 2. body태그 하단에 <script>태그 작성 후 var bno = ${vo.bno}로 글 번호를
	받은 다음 function getAllList()를 test.jsp에서 복붙해서 게시물별 페이지에서
	잘 작동하는지 확인도 해주세요. -->
	<script>
		var bno = ${vo.bno};
		
		function getAllList(){
			$.getJSON("/replies/all/" + bno, function(data){
				//data 변수가 바로 얻어온 json데이터의 집합
				console.log(data);
				
				// str 변수 내부에 문자 형태로 html 코드를 작성함
				var str = "";
			

				$(data).each(function(){
				  // $(data).each()는 향상된 for문처럼 내부데이터를 하나하나 반복합니다.
				  // 내부 this는 댓글 하나하나입니다.
				  // 시간 형식을 우리가 쓰는 형식으로 변경
				  var timestamp = this.updateDate;
				  var date = new Date(timestamp);
				  // date만으로도 시간표시는 우리가 아는 형태로 할 수 있지만 보기 불편함
				  console.log(date);
				  // date 내부의 시간을 형식(format)화 해서 출력
				  var formattedTime = "게시일 : " + date.getFullYear() // 년도 추출
					  				  + "/" + (date.getMonth()+1) // month는 0월부터시작
									  + "/" + date.getDate() // 날짜 추출
									  + "/" + date.getHours() // 시간 추출
									  + ":" + date.getMinutes() // 분 추출
									  + ":" + date.getSeconds() // 초 추출	
				
				  // this.updateDate를 표출하면 시간이 unix시간으로 표시됨
				  str += "<div class='replyLi' data-rno='" + this.rno + "'><strong>@"
					+ this.replyer + "</strong> - " + formattedTime + "<br>"
					+ "<div class='reply'>" + this.reply + "</div>"
					+ "<button type='button' class='btn btn-info'>수정/삭제</button>"
					+ "</div>";
				});
				
				// #replies인 ul태그 내부에 str을 끼워넣음
				$("#replies").html(str);
			});
		}
		getAllList();
		
		// 비동기 코드
		// 글쓰기 부분
		$("#replyAddBtn").on("click", function(){
			// 각 input태그에 들어있던 글쓴이, 본문의 value값을 변수에 저장함.
			var replyer = $("#newReplyWriter").val();
			var reply = $("#newReply").val();
			// 디버깅시는 console.log() 내부에 적어서 확인합니다.
			//console.log(replyer + "/" + reply);
			
			$.ajax({
				type : 'post',
				url : '/replies/',
				headers: {
					"Content-Type" : "application/json",
					"X-HTTP-Method-Override" : "POST"
				},
				dataType : 'text',
				data : JSON.stringify({
					bno:bno,
					replyer:replyer,
					reply:reply
				}),
				success : function(result){
					if(result == 'SUCCESS'){
						alert("등록 되었습니다.");
						// 댓글 쓰고 나서 다시 새롭게 갱신된 목록을
						// 넣어주도록 전체 댓글 목록 다시 조회
						getAllList();
						// 댓글 다 썼으면 댓글창 비워지도록 처리
						$("#newReplyWriter").val("");
						$("#newReply").val("");
					}
				}
			})
		});

		// 글 삭제 로직
		$("#replyDelBtn").on("click", function(){
			// 삭제에 필요한 댓글번호를 모달 타이틀 부분에서 얻기
			var rno = $(".modal-title").html();
			
			$.ajax({
				type : 'delete',
				url : '/replies/' + rno,
				// 삭제로직은 rno만 전달함
				// 호출타입 delete, url정보 이외엔 처리할게 없음
				success : function(result){
					if(result === 'SUCCESS'){
						alert(rno + "번 댓글이 삭제되었습니다.");
						// 댓글삭제 후에 모달창 닫고 새 댓글목록 갱신
						$('#modDiv').hide('slow');
						getAllList();
					}
				}
			})
		});
		
		// 글 수정 로직(rno, reply 필요)
		$('#replyModBtn').on("click", function(){
			// rno(수정에 필요한 댓글번호 모달 타이틀에서 얻기)
			var rno = $(".modal-title").html();
			// 수정에 필요한 본문내역을 #replytext의 value값으로 얻기
			var reply = $("#replytext").val();
			
			$.ajax({
				type : 'put',
				url : '/replies/' + rno,
				headers : {
					"Content-Type" : "application/json",
					"X-HTTP-Method-Override" : "PUT"
				},
				dataType : 'text',
				data : JSON.stringify(
						{reply:reply}
						),
				success : function(result){
					if(result === 'SUCCESS'){
						alert(rno + "번 댓글이 수정되었습니다.");
						// 댓글 삭제 후 모달창 닫고 새 댓글목록 갱신
						$("#modDiv").hide("slow");
						getAllList();
					}
				}
			});
		});
		
		
		
		
		// 이벤트 위임
		// 내가 현재 이벤트를 걸려는 집단(button) 을 포함하면서 범위가 제일 좁은
		// #replies로 시작조건을 잡습니다.
		// .on("click", "목적지 태그까지 요소들", function(){실행문})
		// 과 같이 위임시는 파라미터가 3개 들어갑니다.
		$("#replies").on("click", ".replyLi button", function(){
			// this는 최 하위태그인 button, button의부모면 결국 .replyLi
			var replyLi = $(this).parent();
			
			// .attr("속성명") 을 하면 해당 속성의 값을 얻습니다.
			var rno = replyLi.attr("data-rno");// data-rno=this.rno 얻어오기
			//버튼의 형제(.reply)의 내부텍스트 얻기
			var reply = $(this).siblings(".reply").text(); 
			// 버튼의 부모(replyLi)의 자식(.reply) div class="reply"의 내부텍스트얻기
			// var reply = $(this).parent().childrens(".reply").text();
			
			
			// 클릭한 버튼에 해당하는 댓글번호 + 본문이 얻어지나 디버깅
			console.log(rno + ":" + reply);
			
			
			// 모달 열리도록 추가
			$(".modal-title").html(rno);// 모달 상단에 댓글번호 넣기
			$("#replytext").val(reply);// 모달 수정창에 댓글본문 넣기
			$("#modDiv").show("slow"); // 창에 애니메이션 효과 넣기
		});
		
	
		// 모달 닫기 : closeBtn을 눌렀을때 #modDiv가 hide되도록 해야함
		$("#closeBtn").on("click", function(){
			$("#modDiv").hide("slow");
		});
		
		(function(){
			// getJSON의 두 번째 파라미터로 ?bno=bno값을 대체
			$.getJSON("/board/getAttachList", {bno:bno}, function(arr){
				console.log(arr);
				
				// ul태그 내부에 태그를 추가해야하기때문에 문자열 이용
				var str = "";
				// i, obj랑 같은데 변수명만 i, attach로 바꿈
				$(arr).each(function(i, attach){
					// image type
					if(attach.image){
						var fileCallPath = encodeURIComponent(attach.uploadPath 
							+ "/s_" + attach.uuid + "_" + attach.fileName);
						
						str += "<li data-path='" + attach.uploadPath + "' data-uuid='"
							+ attach.uuid + "' data-filename='"+ attach.fileName
							+ "' data-type='" + attach.image + "' >"
							+ "<div>"
							+ "<img src='/display?fileName=" + fileCallPath + "'>"
							+ "</div>"
							+ "</li>";
					} else {
						str += "<li data-path='" + attach.uploadPath + "' data-uuid='"
						+ attach.uuid + "' data-filename='"+ attach.fileName
						+ "' data-type='" + attach.image + "' >"
						+ "<div>"
						+ "<img src='/resources/file.png' width='100px' height='100px'>"
						+ "</div>"
						+ "</li>";
					}
				});//end forEach
				$("#uploadResult ul").html(str);
			});// end getJSON
		})();// end anonymous function & call function()
		
		
		
		
		
	</script>
	
</body>
</html>