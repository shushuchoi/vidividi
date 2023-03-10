<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="path" value="${pageContext.request.contextPath }"/>   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- 아이콘 관련 링크 -->
<script src="https://kit.fontawesome.com/ccf3e996b8.js" crossorigin="anonymous"></script>

<script type="text/javascript" src="https://code.jquery.com/jquery-3.6.1.js"></script>
<script type="text/javascript">

$("link[rel=stylesheet][href*='https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css']").remove();

function getContextPath(){
	
	let path = location.href.indexOf(location.host)+location.host.length;
	
	return location.href.substring(path, location.href.indexOf('/', path+1));
}

let RepChannelCode = "${RepChannelCode}";
let search = "${search}";
let keyword = "none";



let page_history = 1;
let page_search = 1;

let loading_history = false;
let loading_search = false;
if(search == 1) {
	loading_history = true;
}else if(search == 2) {
	loading_search = true;
}

console.log("=============== 페이지 시작시 확인용 코드 ========================");
console.log("default RepChannelCode >>> "+RepChannelCode);
console.log("default search >>> "+search);
console.log("default loading_history >>> " + loading_history);
console.log("default loading_search >>> " + loading_search);
console.log("===========================================================");




function getHistory_new(page_history){

	$.ajax({

		url : getContextPath() +"/history_new.do",
		data : {
			"page" : page_history 
		},
		datatype : 'JSON',
		contentType : "application/json; charset=UTF-8",
		success : function(data){
			
			let str = data;

			if(str == "[]"){
				loading_history = false;
				
			}else{
				
				let history = JSON.parse(data);
				let div = "";
				div += "<div class='video_boxs'>"
				$(history).each(function(){
					div += "<div class='video_box'>";
					div += "<a href='<%=request.getContextPath() %>/watch.do?video_code=" + this.video_code + "'>";
					div += "<video class='test_video' src='"+getContextPath()+"/resources/AllChannel/"+this.channel_code+"/"+this.video_title+".mp4' controls></video>";
					div += "<div class='video_pbox'>";
					div += "<p class='video_title_p'>"+this.video_title+"<p>";
					div += "</a>";
					div += "<p class='video_channel_p'>";
					div += "<a href='"+getContextPath()+"/channel.do?mc="+this.channel_code+"'>"+this.channel_name+"</a> <i class='fa-solid fa-carrot'></i> 조회수 "+this.video_view_cnt+"회</p>";
					div += "<p class='video_views_p'>"+this.video_cont+"<p>";
					div += "</div>";
					div += "<a href='"+getContextPath()+"/history_one_delete.do?video_code="+this.video_code+"&search="+search+"'>";
					div += "<img class='video_history_d_img' src='"+getContextPath()+"/resources/img/x.png'>";
					div += "</a>";
					div += "</div>";
				});
				div += "</div>"
				loading_saerch = false;
				loading_history = true;
				$("#ajax_area").append(div);
			}
		},
		error : function(){
			
		}
	}); 
}

function getHistory_search(page_search, keyword) {
	search_keyword = keyword;
    $.ajax({
  		url : getContextPath() +"/history_search.do",
  		data : {
			"page" : page_search,
			"keyword" : keyword,
  		}, 
  		datatype : 'JSON',
  		contentType : "application/json; charset=UTF-8",
  		success : function(data){
			let str = data;
			
			console.log("data >>> " + data);
			
			if(str == "[]"){
				loading_search = false;
				
			}else{
				let history_search = JSON.parse(data);
				
				console.log();
				
				let div = ""; 
				div += "<div class='video_boxs'>"
				$(history_search).each(function(){
					div += "<div class='video_box'>";
					div += "<a href='<%=request.getContextPath() %>/watch.do?video_code=" + this.video_code + "'>";
					div += "<video class='test_video' src='"+getContextPath()+"/resources/AllChannel/"+this.channel_code+"/"+this.video_title+".mp4' controls></video>";
					div += "<div class='video_pbox'>";
					div += "<p class='video_title_p'>"+this.video_title+"<p>";
					div += "</a>";
					div += "<p class='video_channel_p'>";
					div += "<a href='"+getContextPath()+"/channel.do?mc="+this.channel_code+"'>"+this.channel_name+"</a> <i class='fa-solid fa-carrot'></i> 조회수 "+this.video_view_cnt+"회</p>";
					div += "<p class='video_views_p'>"+this.video_cont+"<p>";
					div += "</div>";
					div += "<a href='"+getContextPath()+"/history_one_delete.do?video_code="+this.video_code+"&keyword="+keyword+"&search="+search+"'>";
					div += "<img class='video_history_d_img' src='"+getContextPath()+"/resources/img/x.png'>";
					div += "</a>";
					div += "</div>";
				});
				div += "</div>";
				loading_history = false;
				loading_search = true;
				$("#search_area").append(div);
			}
		},
		error : function(){
			
		}
	}); 
};	



//기본 실행 함수
if(search == 1) {
	getHistory_new(page_history);	
} else if(search != 1){
	getHistory_search(page_search);
};

//검색 버튼을 클릭했을 때
$(document).on("click", "#search_img", function(){	
	keyword = $("#search_keyword").val();
	console.log("keyword >>> " + keyword);
	$(".video_boxs").remove();
	page_history = 1;
	page_search = 1;
	getHistory_search(page_search, keyword);
});

//무한 스크롤
$(window).scroll(function(){
	if($(window).scrollTop()>=$(document).height() - $(window).height()){
		console.log("==================================================================");
		console.log("무한스크롤 함수 실행!!! ");
		console.log("무한스크롤 함수 안에 loading_hisory >>> " + loading_history);
		console.log("무한스크롤 함수 안에 loading_search >>> " + loading_search);
		console.log("==================================================================");
		
		if(loading_history == true){
			page_history++;
			getHistory_new(page_history);
		} else if(loading_search == true){
			page_search++;
			getHistory_search(page_search, keyword);
		}
	}
}); //scroll end
</script>
</head>
<body>
<div id="wrap_myPage">
	<!-- top 영역 -->
	<jsp:include page="../include/top_include.jsp"/>
	<jsp:include page="../include/side_include.jsp"/>

	<!-- 모달창 관련 링크 -->
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-modal/0.9.1/jquery.modal.min.css" />
	<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/myPage/myPage_CSS/history.css">

	<!-- 오른쪽 사이드 채널 정보 영역 -->
	<div id="channel_area" class="area_style">
		<div id="history_search_area">

				<input type="text" class="history_search" name="keyword" id="search_keyword" placeholder="시청 기록 검색" value="">
				<input id="search_img" type="image" src="${pageContext.request.contextPath}/resources/img/search_img.jpg">

		</div>
	
		<div id="profile_info">
			<div class="info_box">
				<div class="info_title">
					<p><a class="btn" href="<%=request.getContextPath() %>/myPage_go.do"><i class="fa-solid fa-briefcase"></i>&nbsp;&nbsp;내 보관함</a></p>
				</div>
			</div>
			
			<hr class="info_hr">
			
			<div class="info_box">
				<div class="info_title">
					<p><a class="btn" href="#history_delete"><i class="fa-solid fa-trash"></i>&nbsp;&nbsp;시청 기록 지우기</a></p>
				</div>
			</div>
			
			<hr class="info_hr">
			
			<div class="info_box">
				<div class="info_title">
					<p><a class="btn" href="#history_stop"><i class="fa-solid fa-circle-stop"></i>&nbsp;&nbsp;시청 기록 일시정지</a></p>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 중앙 메인컨텐츠 영역 -->
	<div id="content_area" class="area_style">
		
		<!-- [기록(시청한 동영상)] 박스 -->
		<div id="watch_box" class="content_box">
			<c:if test="${!empty RepChannelCode}">
			<div class="test">
				<p class="content_title1" onclick="location.href='<%=request.getContextPath() %>/history_list.do'">
					<img id="history_logo" src="${pageContext.request.contextPath}/resources/img/history.png">&nbsp;시청 기록
				</p>
			</div>
			<div id="ajax_area"></div>
			<div id="search_area"></div>
			</c:if>
			
			<!-- 로그인이 되어있지 않으면 출력하는 영역 -->
			<c:if test="${empty RepChannelCode}">
			<div id="page_none">
				<img id="none_img" src="${pageContext.request.contextPath}/resources/img/myPage_no.jpg">
				<p id="none_title">좋아하는 동영상을 감상해 보세요.</p>
				<p id="none_text">저장하거나 좋아요 표시한 동영상을 보려면 로그인하세요.</p>
				<button id="none_btn" onclick="location.href='<%=request.getContextPath() %>/login.do'">로그인</button>
			</div>
			</c:if>
		</div>
		
	</div>
</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.0.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-modal/0.9.1/jquery.modal.min.js"></script>
<!-- ======================================== 모달창 관련 영역 ========================================  -->
<div id="history_delete" class="modal">
	<p class="model_title">시청 기록을 삭제할까요?</p>
	<br>
	<p>VIDIDI 시청 기록이 모든 기기의 모든 VIDIDI 앱에서 삭제됩니다.(임시 내용입니다)</p>
	<p>맞춤 동영상이 재설정되지만 다른 제품에서의 활동으로부터 계속 영향을 받을 수 있습니다.</p>
	<br>
	<button class="model_btn" onclick="location.href='delete_history.do'"><i class="fa-solid fa-square-check" style="font-size: 30px"></i></button>
</div>
<div id="history_stop" class="modal">
	<p class="model_title">시청 기록을 중지할까요?</p>
	<br>
	<p>VIDIDI 시청 기록이 모든 기기의 모든 VIDIDI 앱에서 기록 중지됩니다.(임시 내용입니다)</p>
	<p>맞춤 동영상이 재설정되지만 다른 제품에서의 활동으로부터 계속 영향을 받을 수 있습니다.</p>
	<br>
	<button class="model_btn" onclick="location.href='dont_save_history.do'"><i class="fa-solid fa-square-check" style="font-size: 30px"></i></button>
</div>
<!-- ====================================== 모달창 자바 스크립트 영역 ====================================== -->
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/myPage/myPage_JavaScript/history.js"></script>
<!-- ======================= 모달창 관련 영역 end =======================  -->
</body>
</html>