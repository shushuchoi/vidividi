<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="path" value="${pageContext.request.contextPath }"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>VIDIVIDI SEARCH</title>

<script src="https://unpkg.com/ionicons@5.2.3/dist/ionicons.js"></script>
<script src="https://code.jquery.com/jquery-latest.min.js"></script>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<!-- 스타일 시트 -->
<link rel="stylesheet" href="${path }/resources/eunji_CSS/search.css">	
</head>

<body>

<div id="all_content">

<%-- 검색 필드 include 영역 --%>
	<div id="top_wrap">
		<jsp:include page="../include/top_include.jsp"/>
	</div>

<%-- 사이드바 영역 --%>
	<div id="side_wrap">
		<div id="sidebar">
			<jsp:include page="../include/side_include.jsp"/>
		</div>
	</div> 
	

<%-- 정렬 변환 스위치 영역 --%>
	<div class="centerer">
	    <div class="switcher">
	      <input type="radio" name="balance" value="yin" id="yin" class="switcher__input switcher__input--yin" checked="">
	      <label for="yin" class="switcher__label" id="popular">
	      	<i class="fa-solid fa-ranking-star"></i> 인기순</label>
	      
	      <input type="radio" name="balance" value="yang" id="yang" class="switcher__input switcher__input--yang">
	      <label for="yang" class="switcher__label" id="recent">
	      	<i class="fa-solid fa-star"></i> 최신순</label>
	      
	      <span class="switcher__toggle"></span>
	    </div>
	</div>


<%-- 검색 페이지 출력 영역 --%>
	<div id="search_result"></div>

	
<%-- 무한 스크롤 중 로딩... --%>
 <div class="loading_list">
  <div>
    <div class="c1"></div>
    <div class="c2"></div>
    <div class="c3"></div>
    <div class="c4"></div>
  </div>
  <span>loading · · ·</span>
</div>


<%-- 광고 배너 이미지 영역 --%>	
	<div id="adv_box">
		<img alt="경로 못찾음" id="adv" src="${path }/resources/eunji_IMG/side_banner1.png">
	</div>

<%-- 넘어온 값 받기 --%>
	<input type="hidden" value="${keyword }" id="keyword" >
	<input type="hidden" value="${field }" id="field" >

</div> <!-- 전체 div end -->
</body> 


<script type="text/javascript">
/*---------------------------------------------------------검색결과 인기순 ajax + 기본 설정----------------------------------------------------------------  */

let keyword = $("#keyword").val();
let field = $("#field").val();
let page_rec = 1;
let page_pop = 1;
let check = 0;
let option = "video_regdate";
let loading = true;

function getContextPath(){
    let path = location.href.indexOf(location.host)+location.host.length;
    return location.href.substring(path, location.href.indexOf('/', path+1));
}

function getSearchVideoList_popular(keyword, field, option, page_pop){
	
	$.ajax({
		url : "search_result.do",
		type: "post",
		async : false,
		data : {
			field : field,
			keyword : keyword,
			option : option,
			page : page_pop
		},
		success: function(data){
			
			console.log(field);
			console.log(keyword);
			
			console.log(data);
			console.log("인기순 함수 실행");
			let str = data;
			
			if(str == "[]"){
				loading = false;
				
			}else{
				
				let div = "";
				
				div += "<div class='search_table'>"
				
				$(data).each(function(){
				div += "<div id='watch_box' class='content_box'>";
				div += "<div class='video_box'>";
				div += "<video class='test_video' width='320px' height='180px' src='https://blog.kakaocdn.net/dn/bzobdO/btrSnWRB7qk/LAZKJtMKBI4JPkLJwSKCKK/1234.mp4?attach=1&knm=tfile.mp4' controls></video>";
					div += "<div class='video_pbox'>";
					
						div += "<p class = 'video_title_p'>" +  "<a href='<%=request.getContextPath() %>/watch.do?video_code=" + this.video_code + "'>" +
								"<img class='channel_profile' src='" + getContextPath() + "/resources/img/" + this.channel_profil+ "'>"
								+ '&nbsp;' + this.video_title + "</p>";								
						
						div += "<p class = 'video_channel_p'>" + "<a href='<%=request.getContextPath() %>/channel.do?channel_code=" + this.channel_code + "'>" + this.channel_name + "</p>";
						
						div += "<p class = 'video_view_date_p'>" + "조회수&nbsp;" + this.video_view_cnt + "회" +"&nbsp; <i class='fa-solid fa-carrot'></i> &nbsp;" + this.video_regdate + "</p>";
						div += "<p class = 'video_views_p'>" + this.video_cont + "</p>";

					div += "</div>"; //video pbox end
					div += "<hr>"
				div += "</div>"; //video box end
				div += "</div>"; //watch box end
				}); //each end
				
				div += "</div>";
				
				$("#search_result").append($("<div>").html(div));	
		
			}//else end
		},
		
		error: function(){
			console.log(data);
			alert("검색 비디오 리스트 인기 ajax 오류입니다.");
			
		}
	});
}

	//기본 인기순	
	if(check == 2) {
		 page_rec = 1;
	 	 page_pop = 1;
		getSearchVideoList_recent(keyword, field, option, page_rec);
	} else if(check != 2){
		 page_rec = 1;
	 	 page_pop = 1;
		getSearchVideoList_popular(keyword, field, option, page_pop);
	};


/*-----------------------------------------------------검색결과 최신순 ajax----------------------------------------------------------------  */
 let vicode = this.video_code;

 function getSearchVideoList_recent(keyword, field, option, page_rec){
	
	$.ajax({
		url : "search_result_new.do",
		type: "post",
		async : false,
		data : {
			field : field,
			keyword : keyword,
			option : option,
			page : page_rec
		},
		success: function(data){
			
			console.log(data);
			console.log("최신순 함수 실행");
			
			let str = data;
			
			if(str == "[]"){
				loading = false;
				
			}else{
			
			let div = "";
			
			div += "<div class='search_table'>"
			
			$(data).each(function(){
			div += "<div id='watch_box' class='content_box'>";
			div += "<div class='video_box'>";
			div += "<video class='test_video' width='320px' height='180px' src='https://blog.kakaocdn.net/dn/bzobdO/btrSnWRB7qk/LAZKJtMKBI4JPkLJwSKCKK/1234.mp4?attach=1&knm=tfile.mp4' controls></video>";
				div += "<div class='video_pbox'>";
					div += "<p class = 'video_title_p'>" +  "<a href='<%=request.getContextPath() %>/watch.do?video_code=" + this.video_code + "'>" +
							"<img class='channel_profile' src='" + getContextPath() + "/resources/img/" + this.channel_profil+ "'>"
							+ '&nbsp;' + this.video_title + "</p>";	
						
					div += "<p class = 'video_channel_p'>" + "<a href='<%=request.getContextPath() %>/channel.do?channel_code=" + this.channel_code + "'>" + this.channel_name + "</p>";
					
					div += "<p class = 'video_view_date_p'>" + "조회수&nbsp;" + this.video_view_cnt + "회" +"&nbsp; <i class='fa-solid fa-carrot'></i> &nbsp;" + this.video_regdate + "</p>";
					div += "<p class = 'video_views_p'>" + this.video_cont + "</p>";
					
				div += "</div>"; //video pbox end
			div += "</div>"; //video box end
			div += "</div>"; //watch box end
			}); //each end
			
			div += "</div>";
				$("#search_result").append($("<div>").html(div));			
		
			} //else end		
		},
		
		error: function(){
			console.log(data);
			alert("검색 비디오 리스트 최신 ajax 오류입니다.");
		}
	});
}


//-----------------------------------------------------------------토글버튼 클릭 시 소트 정렬--------------------------------------------------------------------

	//인기순 버튼을 클릭했을 때
	$(document).on("click", ".switcher__input--yin", function(){
		check = 1;
		page_rec = 1;
		page_pop = 1;
		option = "video_good";

		$(".search_table").remove();
		console.log("인기순>>>" + check);
		getSearchVideoList_popular(keyword, field, option, page_pop);
	});
	
	//최신순 버튼을 클릭했을 때
	$(document).on("click", ".switcher__input--yang", function(){
		check = 2;
		page_rec = 1;
		page_pop = 1;
		
		$(".search_table").remove();
		console.log("최신순>>>" + check);
		getSearchVideoList_recent(keyword, field, option, page_rec);
	});
	
	
//--------------------------------------------------------------비디오 hover시 자동재생--------------------------------------
	$(document).on("mouseover", ".test_video", function(){
		 $(this).get(0).play();
	});
	
	$(document).on("mouseout", ".test_video", function(){
		 $(this).get(0).pause();
	});	
	
//---------------------------------------------------------------- 배너 스크롤 따라 이동 ---------------------------------------------------------------------	

	// 기본 위치(top)값
		var floatPosition = parseInt($("#adv_box").css('top'))
	
	// scroll 인식
		$(window).scroll(function() {
				  
	// 현재 스크롤 위치
		var currentTop = $(window).scrollTop();
		var bannerTop = currentTop + floatPosition + "px";
	
	//이동 애니메이션
		$("#adv_box").stop().animate({
			"top" : bannerTop
		}, 750);

		}).scroll();
		
//-----------------------------------------------------------------무한 스크롤------------------------------------------

 	let scroll_check = false;

	   $(window).scroll(function(){
	   scroll_check = true;
	  });
	  
	   setInterval(function() {
	       if (scroll_check) {
	           scroll_check = false;

	           if($(window).scrollTop()>=$(document).height() - $(window).height()){
	        	   if(loading){
	        		   
	        		   if(check == 1){
	        			   page_pop++;
		        	 	   getSearchVideoList_popular(keyword, field, option, page_pop);
		        	 	   
	        		   }else if(check == 2){
	        			   page_rec++;
	        			   getSearchVideoList_recent(keyword, field, option, page_rec);
	        			   
	        		   }else if(check == 0){
	        			   page_pop++;
		        	 	   getSearchVideoList_popular(keyword, field, option, page_pop);
	        		   }
	        		  
	        	   } //loading if end
	        	   
	           } //전체 if end
	       }
	   }, 250); // 무한 스크롤 end		


</script>

</html>