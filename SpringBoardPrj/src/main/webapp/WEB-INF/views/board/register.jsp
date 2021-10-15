<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<style>
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
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>게시물 입력 창</h1>
	
	<form action="/board/register" method="post">
		제목:<input type="text" name="title" /><br/>
		본문:<textarea rows="10" cols="50" name="content"></textarea><br/>
		글쓴이:<input type="text" name="writer" /><br/>
		<input id="submitBtn" type="submit" value="제출" />
	</form>
	
	<hr>
	<!-- register.jsp가 파일업로드 폼 역할을 수행하고 있음 -->
	<h2>첨부파일</h2>
	<div class="uploadDiv">
		<input type="file" name="uploadFile" multiple>
	</div>
	
	<div class="uploadResult">
		<ul>
			<!-- 업로드된 파일이 들어갈 자리 -->
		</ul>
	</div>
	
	
	<button id="uploadBtn">upload</button>
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	
<script>
	$(document).ready(function(){
		
		// 정규표현식으로 파일 확장자, 용량 거르기
		var regex = new RegExp("(.*?)\.(exe|sh|zip|az)$");
		
		var maxSize = 5242880; //5mb
		
		function checkExtension(fileName, fileSize){
			if(fileSize >= maxSize){
				alert("파일 사이즈 초과");
				return false;
			}
			
			// 아까 만든 형식에 파일 이름이 해당하는지 아닌지 검사
			if(regex.test(fileName)){
				alert("해당 종류의 파일은 업로드할 수 없습니다.");					
				return false;
			}
			return true;
		}			
		
		// 업로드시 파일 선택을 초기화시키기 위해 미리 비어있는
		// .uploadDiv를 깊은복사로 복사해둠
		var cloneObj = $('.uploadDiv').clone();
		
		
		$("#uploadBtn").on("click", function(e){
			
			// ajax는 제출버튼을 눌렀을때 목적지가 없기 때문에
			// 빈 폼을 만들고 거기에 정보를 채워나갑니다.
			var formData = new FormData();
			
			var inputFile = $("input[name='uploadFile']");
			
			console.log(inputFile);
			var files= inputFile[0].files;
			
			console.log(files);
			
			// 파일데이터를 폼에 넣기
			for(var i = 0; i < files.length; i++){
				// 폼에 넣기 전에 검사부터
				if(!checkExtension(files[i].name, files[i].size)){
					return false;
				}
				
				formData.append("uploadFile", files[i]);
			}
			
			console.log(formData);
			
			$.ajax({
				url: '/uploadAjaxAction',
				processData : false,
				contentType : false,
				data : formData,
				type : 'POST',
				dataType:'json', // 입력시 json으로 콘솔에, 안입력하면 xml로 콘솔에찍힘.
				success : function(result){
					console.log(result);// 내가 업로드한 파일 내역이 콘솔에 찍히나 디버깅

					// 업로드된 그림파일 목록을 ul내부에 리스트로 입력
					showUploadedFile(result);
					
					// 세팅되어있던 파일이 업로드되면서 목록에서 사라지게 처리.
					$(".uploadDiv").html(cloneObj.html());
				}
			});
		});// onclick uploadBtn
		

		
		var uploadResult = $(".uploadResult ul");
		
		function showUploadedFile(uploadResultArr){
			var str = "";
			
			// i는 인덱스번호(0, 1, 2....) obj 그림파일 정보가 담긴 json
			$(uploadResultArr).each(function(i, obj){
				
					if(!obj.image){
						
						var fileCallPath = encodeURIComponent(
								obj.uploadPath + "/"
							+ obj.uuid + "_" + obj.fileName);
						
						// 그림이 아니면 썸네일대신 resources폴더 내 이미지를 대체로 보여줌
						str += "<li "
							+"data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid
							+ "' data-filename='" + obj.fileName + "' data-type='" + obj.image
							+ "'><a href='/download?fileName=" + fileCallPath
							+ "'><img src='/resources/file.png'>"
							+ obj.fileName + "</a>"
							+ "<span data-file=\'" + fileCallPath + "\' data-type='file'>X</span>"
							+ "</li>";
					} else {
						//str += "<li>" + obj.fileName + "</li>";
						// 파일이름 + 썸네일을 보여주기 위해 썸네일 주소 요청하게 만들기
						var fileCallPath = encodeURIComponent(obj.uploadPath
									+ "/s_" + obj.uuid + "_" + obj.fileName);
						var fileCallPath2 = encodeURIComponent(obj.uploadPath
								+ "/" + obj.uuid + "_" + obj.fileName);
						
						// 원래 그냥 fileCallPath를 조립해서
						str += "<li "
							+"data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid
							+ "' data-filename='" + obj.fileName + "' data-type='" + obj.image
							+ "'><a href='/download?fileName=" + fileCallPath2
							+ "'><img src='/display?fileName=" 
							+ fileCallPath +"'>" + obj.fileName + "</a>"
							+ "<span data-file=\'" + fileCallPath + "\' data-type='image'>X</span>"	
							+ "</li>";
					}
				});
				uploadResult.append(str);
			}//showUploadedFile
		
		$(".uploadResult").on("click", "span", function(e){
			
			console.log($(e));
			
			console.log($(this));
			var targetFile = $(this).data("file");
			var type = $(this).data("type");
			console.log(targetFile + "///" + type);
			
			var targetLi  = $(this).closest("li");
			
			$.ajax({
				url : '/deleteFile',
				data : {fileName : targetFile, type:type},
				dataType : 'text',
				type : 'post',
				success : function(result){
					alert(result);
					targetLi.remove();
				}
			})
		});// .uploadResult click
		
		
		$("#submitBtn").on("click", function(e){
			// 클릭된 요소의 동작 중지(제출버튼인경우 버튼을 눌러도 제출이 되지 않음)
			// 글쓰기를 했을때, 그림이 몇 장 추가될지는 글을 써봐야 알 수 있음
			// 제출을 바로 하지 못하도록 막습니다.
			e.preventDefault();
			
			// 위의 form에 업로드된 그림요소들에 대한 정보를 추가합니다.
			// 1. form 태그 정보 얻어오기
			// 상단 form태그에 이미지 관련 정보를 hidden으로 추가하기 위해 얻어옴
			var formObj = $('form');
			
			// 2. 추가내용을 먼저 받기 위해 빈 문자열 생성
			var str = "";
			
			// 3. .uploadResult 내부에 들어간 그림정보를 얻어와서
			// formObj내부에 넣어주기
			// .uploadResult내부 ul 내부의 li가 그림정보를 담고있으므로
			// 반복문으로 처리
			$(".uploadResult ul li").each(function(i, obj){
				
				var imgInfo = $(obj);
				// BoardVO 내부의 List<BoardAttachVO>를 처리하기 위해 변수명 attachList로 전달 
				str += "<input type='hidden' name='attachList[" + i + "].fileName'"
					+ " value='"+ imgInfo.data("filename") +"'>"
					+ "<input type='hidden' name='attachList[" + i + "].uuid'"
					+ " value='"+ imgInfo.data("uuid") +"'>"
					+ "<input type='hidden' name='attachList[" + i + "].uploadPath'"
					+ " value='"+ imgInfo.data("path") +"'>"
					+ "<input type='hidden' name='attachList[" + i + "].image'"
					+ " value='"+ imgInfo.data("type") +"'>"
			});
			// 반복이 끝나면, formObj에 위 태그들을 추가한 다음 제출합니다.
			formObj.append(str).submit();
			// 그림정보가 잘 추가되는지 디버깅
			//console.log($(formObj));
		});// #submitBtn onclick
		
		
		
	});//document


</script>
	
	
</body>
</html>