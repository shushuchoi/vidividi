<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" pageEncoding="UTF-8" %>
<c:set var="path" value="${pageContext.request.contextPath }"/>
<html>
<head>

<script src="https://unpkg.com/ionicons@5.2.3/dist/ionicons.js"></script>
<script src="https://code.jquery.com/jquery-latest.min.js"></script>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>

<!-- 스타일 시트 -->
<link rel="stylesheet" href="${path }/resources/eunji_CSS/main.css">	


<title>VIDIVIDI</title>
</head>

<body align="center">

<%-- 검색 필드 include 영역 --%>

	<div id="top_wrap">
		<jsp:include page="./include/top_include.jsp"/>
	</div>
	
	<br>

<%-- 카테고리 영역 --%>

	<nav id="mainnav" class="group">
	    <div id="menu">&#x2261; Menu</div>
	    <ul>
	        <li id="all"><a href="#">전체</a></li>
	        <li><a href="#">음악</a></li>
	        <li><a href="#">게임</a></li>
	        <li><a href="#">요리</a></li>
	        <li><a href="#">스포츠</a></li>
	        <li><a href="#">뉴스</a></li>
	        <li><a href="#">교육</a></li>
	        <li><a href="#">유아</a></li>
	    </ul>
	</nav>
	 	

<%-- 캐러셀 영역 --%>

<div id="slide_wrap">
	
		<div id="slide"> 
	
		<section id="section">
		  <ul class="carousel">
		    <li class="items main-pos" id="1">
		    <iframe width="600" height="320" src="https://www.youtube.com/embed/D1xoRXtzc8c" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
		    </li>
		    <li class="items right-pos" id="2">
		      <iframe width="600" height="320" src="https://www.youtube.com/embed/UFovWG_A_fk" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
		    </li>
		    <li class="items back-pos" id="3">
		      <iframe width="600" height="320" src="https://www.youtube.com/embed/YHQmzncbIds" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
		    </li>
		    <li class="items back-pos" id="4">
		    <iframe width="600" height="320" src="https://www.youtube.com/embed/M0O2YjP7ngw" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
		    </li>
		    <li class="items back-pos" id="5">
		     <iframe width="600" height="320" src="https://www.youtube.com/embed/Kmgo00avvEw" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
		    </li>
		    <li class="items back-pos" id="6">
		      <iframe width="600" height="320" src="https://www.youtube.com/embed/4Qry1Osot08" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
		    </li>
		    <li class="items left-pos" id="7">
		    <iframe width="600" height="320" src="https://www.youtube.com/embed/I9vK5EVTt0U" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
		    </li>
		  </ul>
		  
		  <div id = "slidebtn_wrap">
			<button id="prev"><i class="fa-solid fa-angles-left"></i></button>
			<button id="next"><i class="fa-solid fa-angles-right"></i></button>
		  </div>
		  
	</section>
    </div>
    	
  </div>  
	
	<br>
	
	<div id="re_label">
		<button class="custom-btn re_btn"><i class="fa-solid fa-ranking-star"></i>&nbsp;&nbsp;추천 동영상</button>
		<button class="custom-btn up_btn"><i class="fa-solid fa-star"></i>&nbsp;&nbsp;신규 동영상</button>
	</div>
	
	
<%-- 동영상 리스트 영역 --%>
	 <div id="video_list">  
		 <!-- 	<h4> 오늘의 추천 동영상 </h4> -->
		 <table cellspacing="0">
		 	<c:set var="list" value="${video_list }" />
	     	 <c:if test="${!empty list }">
				 <c:forEach items="${list }" var="dto">
				 
			        <tr>
			          <td colspan="1">
			          <video src="https://blog.kakaocdn.net/dn/bzobdO/btrSnWRB7qk/LAZKJtMKBI4JPkLJwSKCKK/1234.mp4?attach=1&knm=tfile.mp4" controls></video></td>
			          <td id = "video_title">${dto.getVideo_title() }</td>
			          <td id ="video_channel">${dto.getChannel_name() }</td>
			          <td id = "video_view_ctn">조회수: ${dto.getVideo_view_cnt() } &nbsp; &nbsp; ${dto.getVideo_regdate() }</td>
			          <td>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</td>	
			        </tr>
			        
			        <tr>
						<td>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</td>		        
			        </tr>
					
					<br>
					
			 	</c:forEach>
			 </c:if>
			 
		   <c:if test="${empty list }">
	         <tr>
	            <td colspan="4" align="center">
	               <h3>동영상 리스트가 없습니다.....</h3>
	            </td>
	         </tr>
	      </c:if>
	      
		</table>	
	</div>
	 
	
<%-- 사이드바 영역 --%>
	
	<div id="side_wrap">
		<div id="sidebar">
			<jsp:include page="./include/side_include.jsp"/>
		</div>
	</div>
	
</body>


<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	
<script>
//----------------------------------------------------------------------카테고리------------------------------------------------------------------------
	$(document).ready(function() {
			   
	//네비바 토글
	$('#menu').bind('click',function(event){
		$('#mainnav ul').slideToggle();
	});
		
		$(window).resize(function(){  
		var w = $(window).width();  
		if(w > 768) {  
		$('#mainnav ul').removeAttr('style');  
	}  
	});
				
	});

//----------------------------------------------------------------------캐러셀------------------------------------------------------------------------

	//슬라이드 쇼 움직이는 속도
	var autoSwap = setInterval( swap,3500);
	
	//마우스 빠지면 슬라이드 멈추기
	$('ul, span').hover(
	  function () {
	    clearInterval(autoSwap);
	}, 
	  function () {
	   autoSwap = setInterval( swap,3500);
	});
	
	var items = [];
	var startItem = 1;
	var position = 0;
	var itemCount = $('.carousel li.items').length;
	var leftpos = itemCount;
	var resetCount = itemCount;
	
	$('li.items').each(function(index) {
	    items[index] = $(this).text();
	});
	
	//이미지 바뀌기
	function swap(action) {
	  var direction = action;
	  
	  //캐러셀 뒤로 가기
	  if(direction == 'counter-clockwise') {
	    var leftitem = $('.left-pos').attr('id') - 1;
	    if(leftitem == 0) {
	      leftitem = itemCount;
	    }
	    
	    $('.right-pos').removeClass('right-pos').addClass('back-pos');
	    $('.main-pos').removeClass('main-pos').addClass('right-pos');
	    $('.left-pos').removeClass('left-pos').addClass('main-pos');
	    $('#'+leftitem+'').removeClass('back-pos').addClass('left-pos');
	    
	    startItem--;
	    if(startItem < 1) {
	      startItem = itemCount;
	    }
	  }
	  
	  //캐러샐 앞으로 가기
	  if(direction == 'clockwise' || direction == '' || direction == null ) {
	    function pos(positionvalue) {
	      if(positionvalue != 'leftposition') {
	        //리스트 아이디 증가
	        position++;
	        
	        //등록 동영상 끝까지 가면 처음으로 돌아오기
	        if((startItem+position) > resetCount) {
	          position = 1-startItem;
	        }
	      }
	    
	      //왼쪽 아이템 세팅
	      if(positionvalue == 'leftposition') {
	        
	        position = startItem - 1;
	      
	        if(position < 1) {
	          position = itemCount;
	        }
	      }
	   
	      return position;
	    }  
	  
	   $('#'+ startItem +'').removeClass('main-pos').addClass('left-pos');
	   $('#'+ (startItem+pos()) +'').removeClass('right-pos').addClass('main-pos');
	   $('#'+ (startItem+pos()) +'').removeClass('back-pos').addClass('right-pos');
	   $('#'+ pos('leftposition') +'').removeClass('left-pos').addClass('back-pos');
	
	    startItem++;
	    position=0;
	    if(startItem > itemCount) {
	      startItem = 1;
	    }
	  }
	}
	
	//다음 버튼
	$('#next').click(function() {
	  swap('clockwise');
	});
	
	//이전 버튼
	$('#prev').click(function() {
	  swap('counter-clockwise');
	});
	
	//다음 버튼을 클릭했을 때 다음 동영상이 없다면
	$('li').click(function() {
	  if($(this).attr('class') == 'items left-pos') {
	     swap('counter-clockwise'); 
	  }
	  else {
	    swap('clockwise'); 
	  }
	});

	
</script>

</html>
