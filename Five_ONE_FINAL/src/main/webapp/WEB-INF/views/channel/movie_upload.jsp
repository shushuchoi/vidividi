 <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="path" value="${pageContext.request.contextPath }" />
<c:set var="channelcode" value="${uploadOwner }" />
<c:set var="bundleList" value="${list }" />
<c:set var="mainCategory" value="${cateList }" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
</head>
<body>
	<script type="text/javascript" src="https://code.jquery.com/jquery-3.6.1.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
	<div class="modal-body">
	<form method="post" enctype="multipart/form-data" action="<%=request.getContextPath() %>/upload_success.do?channelCode=${channelcode }" class="form-floating" id="send_form">
		<div class="container-fluid">
			<%-- 최상단 라인 --%>
		    <div class="row">
		      <div class="col-md-2">
		      	<div class="upload-font">V I D I D I</div>
		      </div>
		      <div class="col-md-2 ms-auto">
		      	<button type="button" class="btn-close" data-dismiss="modal" aria-label="Close"></button>
		      </div>
		   </div>
		   
		   <%-- 업로드 영상 섹션 --%>
		    <div class="row">
			    <div class="col-6 ms-auto out-side">
			    	<div class="drag-area" align="center">
			      		<div class="submit_video">
				      		<div class="icon icon_change">
				      			<i class="fas fa-cloud-upload-alt"></i>
				      		</div>
				      		<header>업로드할 파일을 드래그 해주세요.</header>
				      		<span>또는</span>		      		
			      		</div>
			      		<input type="button" class="upload_click_btn" value="클 릭">
			      		<div class="file_div"><input class="upload_input_file" id="upload_input_file" name="upload_input_file" hidden  type="file"></div>
			      	</div>
			    </div>
		      <%-- 업로드 섹션 끝 --%>
		    	
		      <%-- 제목과 내용 --%>	
		    	<div class="col-6">
			      <div class="row">
			     	<div align="left">제 목</div>
			      	<input class="form-control" name="title_field" list="datalistOptions" id="floatingTextarea2" placeholder="변경할 제목을 알려주세요">
			      </div>
			      <div class="row">
					<div class="form-floating">
					  <textarea class="form-control" name="cont_area" placeholder="Leave a comment here" id="floatingTextarea3" style="height: 350px; width: 102%;"></textarea>
					  <label for="floatingTextarea2">영상을 설명해주세요</label>
					</div>
			      </div>
			    </div>
			</div><!-- upload div -->
			<hr>
			
			 <div class="row">
			  	<div class="col-12" align="left">
			  		<strong>영상 카테고리</strong>
			  	</div>
			  	<div class="col-12">
			  		<c:if test="${empty mainCategory }">
			  			<a href="#" class="text-decoration-none" style="display: flex;">카테고리 오류</a>
			  		</c:if>
			  		<c:if test="${!empty mainCategory }">
			  			<select id="category_List" name="category_List" class="form-select" size="3" aria-label="size 3 select example">
						  <c:forEach items="${mainCategory }" var="categoryList" varStatus="index">
						      	<option value="${categoryList.category_code }" <c:if test="${index.first }">selected</c:if> >${categoryList.category_title }</option>
						  </c:forEach>
						</select>
			  		</c:if>
			  	</div>
			  </div>
			  
			 <hr>
		  
			<div class="row">
				<div class="col-12" align="left">
		  		<strong>재생목록</strong>
			  	</div>
			  	<div class="col-12 bundleDiv">
			  		<c:if test="${empty bundleList }">
			  			<a href="#" class="text-decoration-none" style="display: flex;">재생목록이 없어요. 재생목록을 추가해보세요!</a>
			  		</c:if>
			  		<c:if test="${!empty bundleList }">
			  			<select id="bundleCheck" name="video_playList" class="form-select" size="3" aria-label="size 3 select example">
						  <c:forEach items="${bundleList }" var="bundle" varStatus="index">
						      	<option value="${bundle.bundle_code }" <c:if test="${index.first }">selected</c:if>>${bundle.bundle_title }</option>
						  </c:forEach>
						</select>
			  		</c:if>
			  	</div>
			</div>
			<hr>
			<div class="row">
			  	<div class="col-8" align="left">
			  		<h5>시청자층*</h5>
					이 동영상이 아동용으로 설정됨 크리에이터가 설정함<br>
					모든 크리에이터는 위치에 상관없이 아동 온라인 개인정보 보호법(COPPA) 및 기타 법률을 준수해야 할 법적인 의무가 있습니다. 아동용 동영상인지 여부는 크리에이터가 지정해야 합니다.
			  	</div>
			  	<div class="col-4" align="left">
			  		<br>
			  		<div class="form-check age_select" >
						  <input class="form-check-input" type="radio" name="flexRadioDefault_age" id="flexRadioDefault1" checked>
						  <label class="form-check-label" for="flexRadioDefault1">
						    예 아동용 입니다
						  </label>
						</div>
						<div class="form-check age_select">
						  <input class="form-check-input" type="radio" name="flexRadioDefault_age" id="flexRadioDefault2">
						  <label class="form-check-label" for="flexRadioDefault2">
						    아니요 성인용 입니다
						  </label>
					</div>
					<input type="hidden" name="select_Age" id="selectAge" value="">
			  	</div>
			 </div>
			 <hr> 
		    <div class="row">
		        <strong style="text-align: left;">공개 여부</strong>
			  	<div class="col-10 open_check">
			  		<div class="form-check">
					  <input class="form-check-input" type="radio" name="flexRadioDefault_openClose" id="flexRadioDefault3" checked>
					  <label class="form-check-label" for="flexRadioDefault3">
					   	시청자들과 같이 보기
					  </label>
					</div>
					&nbsp; &nbsp;
					<div class="form-check">
					  <input class="form-check-input" type="radio" name="flexRadioDefault_openClose" id="flexRadioDefault4">
					  <label class="form-check-label" for="flexRadioDefault4">
					   	나만 보기
					  </label>
					</div>
					<input type="hidden" name="select_openClose" id="selectOpen" value="">
			  	</div>
	        	<div class="col-2">
	        		<button type="button" class="btn btn-primary video_upload_btn">업로드</button>
	        		&nbsp;
			        <button type="button" class="btn btn-secondary modal_close" data-dismiss="modal">취소</button>
	        	</div>
		    </div>
		    <hr>
		    <div class="row">
		    	<strong>영상 첫이미지 선택하기</strong>
				<div class="input-group mb-3">
				  <input type="file" id="input_img" name="file_img" class="form-control" id="inputGroupFile02">
				</div>
		    </div>
		  </div>
		</form>
	</div>
	<script type="text/javascript" src="${path }/resources/hochan_JavaScript/uploadBtn.js"></script>
</body>
</html>