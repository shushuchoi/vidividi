<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="path" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- Google -->
<meta name ="google-signin-client_id" content="279446786317-1d8b3dusm3g9oc69uvskvd84p04eira1.apps.googleusercontent.com">
<title>Insert title here</title>
<!-- jQuery -->
<script src="https://code.jquery.com/jquery-latest.min.js"></script> 
<!-- member css -->
<link rel="stylesheet" href="${path}/resources/member/member_login.css">
<link rel="stylesheet" href="${path}/resources/member/member_cummon.css"> 

<!-- toast -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.css" integrity="sha512-3pIirOrwegjM6erE5gPSwkUzO+3cTjpnV9lexlNZqvupR64iZBnOOTiiLPb9M36zpMScbmUNIcHUqKD47M719g==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js" integrity="sha512-VEd+nq25CkR676O+pLBnDW09R7VQX9Mdiij052gVCp5yVH3jGtH70Ho/UUv4mJDsEdTvqRCFZg0NKGiojGnUCw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>

<!-- bootstrap icon -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.9.1/font/bootstrap-icons.css">

<!-- Google signin api -->
<script src="https://accounts.google.com/gsi/client" async defer></script>

<!-- KaKao -->
<script src="https://t1.kakaocdn.net/kakao_js_sdk/2.1.0/kakao.min.js"
  integrity="sha384-dpu02ieKC6NUeKFoGMOKz6102CLEWi9+5RQjWSV0ikYSFFd8M3Wp2reIcquJOemx" crossorigin="anonymous"></script>
<script type="text/javascript">
	Kakao.init('f76456adebea52ab2b1a18207c100a25');
</script>

<!-- Naver -->
<script type="text/javascript" src="https://static.nid.naver.com/js/naveridlogin_js_sdk_2.0.2.js" charset="utf-8"></script>

<script type="text/javascript">
	$(function(){
		
		$.ajaxSetup({
			ContentType: "application/x-www-form-urlencoded; charset=UTF-8",
			type : "post"								
		});
		
		toastr.options = {
				  "closeButton": false,
				  "debug": false,
				  "newestOnTop": false,
				  "progressBar": false,
				  "positionClass": "toast-top-center",
				  "preventDuplicates": false,
				  "onclick": null,
				  "showDuration": "300",
				  "hideDuration": "1000",
				  "timeOut": "2000",
				  "extendedTimeOut": "2000",
				  "showEasing": "swing",
				  "hideEasing": "linear",
				  "showMethod": "fadeIn",
				  "hideMethod": "fadeOut"
				}
		
		
		inputPlaceholder();
		pwdShow();
				
	});

	
	
	<!-- ????????? ?????? ??????????????? ????????? ???????????? ??????????????? ??????-->
	function loginCheck(){
		
		$.ajax({
			url : "<%=request.getContextPath()%>/loginOk.do",
			data : $('#login-form').serialize(),
			datatype : 'text',
			success : function(data){
				
				console.log("data : "+data);
				
				if (data == 'success'){
					$(location).attr('href', '<%=request.getContextPath()%>');
				}else if(data == 'fail'){
					toastr.error('???????????? ??????????????? ???????????????.','????????? ??????!');
				}else {
					$("#email-auth-span").text("????????? ?????????");
					modalShow();
					protectLogin(data);
				}
			},
			error : function(){
				toastr["error"]("????????? ?????? ??????");
			}
		});
		
	}
	
	<!-- ?????? ???????????? ?????? ??????????????? ?????? -->
	function authLogin(){

		$.ajax({
			url : "<%=request.getContextPath()%>/protect_login_ok.do",
			data : $('#login-form').serialize(),
			datatype : 'text',
			success : function(data){
				
				if (data == 'success'){
					$(location).attr('href', '<%=request.getContextPath()%>');
				}else if(data == 'fail'){
					toastr.error('???????????? ??????????????? ???????????????.','????????? ??????!');
				}
			},
			error : function(){
				toastr["error"]("????????? ?????? ??????");
			}
		});
		
	}
	
	<!-- ???????????? ???????????? ?????? -->
	function protectLogin(key){
		
		authtimer();
		setTimeout(function(){
			clearInterval(CountDown);
			key == "";
			$("#email-auth-span").text("?????? ?????? ??????");
			toastr.warning("?????? ????????? ?????????????????????.");
		}, 180000);
		
		$("#protect-login-btn").on('click', function(){
			if ($("#input-authKey").val() == key){
				authLogin();
			}else {
				toastr.error('??????????????? ???????????????.');
			}
		});
		
		$("#protect-cancle-btn").on('click', function(){
			modalHide();
			clearInterval(CountDown);
			key == "";
			$("#email-auth-span").text("");
			toastr.warning("???????????? ?????????????????????.");
		});
	}
	
<!-- ?????? ????????? -->

	function getGoogleData(response){
	 	console.log("Encoded JWT ID token: " + response.credential);
	 	
	 	$.ajax({
	 		url : '<%=request.getContextPath()%>/google_login.do',
			data: {
				jwt : response.credential
			},
			success : function(data){
				if (data == "joined" || data == "linked"){
					toastr.success("????????? ??????");
					$(location).attr("href", "<%=request.getContextPath()%>");
				}else if (data == "notlinked"){
					toastr.success('?????? ???????????? ????????? ?????????????????????.');
					$(location).attr("href", "<%=request.getContextPath()%>");
				}
			},
			error: function(){
				toastr.error("?????? ????????? ????????? ?????? ??????");
			}
	 		
	 		
	 	});
	}
	

	
	<!-- ????????? ????????? -->
	function loginWithKakao() {
	 console.log('loginWithKakao() ?????????');
	 Kakao.Auth.authorize({
	    redirectUri: 'http://localhost:8282/one/kakao_login.do',
	  });
	 
	}
	

</script>


</head>
<body>
	<div id="login-page-wrap">
		<jsp:include page="../include/top_include.jsp"/>
		
		<div id="login-wrap">
			<div id="login-side-bar">
				<jsp:include page="../include/side_include.jsp"></jsp:include>
			</div>
			<div id="login-wrap-top">
				<div id="login-logo">
					<span class="login-logo">?????????</span>
					<span class="login-logo txt">?????? ????????? ?????????, ????????????</span>
				</div>
			</div>
			<div id="login-wrap-bottom">
				<div id="login-component-left">
					<form method="post" action="<%=request.getContextPath()%>/loginOk.do" id="login-form">
						<div class="input-wrap">
							<div class="label-input" >
								<label for="input-id" id="input-id-check"></label>
								<label for="input-id" id="input-id-label">?????????</label>
								</div>
								<input name="id" class="member-input form-input" id="input-id">
							</div>
							<div class="input-wrap">
								<div class="label-input" >
									<label for="input-id" class="label-input" id="input-pwd-check"></label>
									<label for="input-id" class="label-input" id="input-pwd-label">????????????</label>
								</div>
								<div class="pwd-wrap">
									<input name="pwd" class="password member-input form-input essential member-pwd-input" id="input-pwd" autocomplete="off">
									<div class="pwd-eye showEye">
										<i class="bi bi-eye-fill"></i>
									</div>
								</div>
							</div>
						<input type="button" value="?????????" class="form-btn" onclick="loginCheck()">
						<hr class="horizontal-hr">
						<div class="login-menu">
							<a href="<%=request.getContextPath()%>/find_id.do" class="form-a">
								<span class="form-text">???????????? ?????????????<span class="form-link"> ?????????/???????????? ??????</span></span> 
							</a>
						</div>
					</form>
				</div>
				<hr class="vertical-hr">
				<div id="login-component-right">
					<span id="social-title">?????? ?????????</span>
					<hr class="horizontal-hr">
					<div id="login-icon-wrap">
					<div id="google-wrap">
						<div id="g_id_onload"
				         data-client_id="279446786317-1d8b3dusm3g9oc69uvskvd84p04eira1.apps.googleusercontent.com"
				         data-callback="getGoogleData"
				         data-auto_prompt="false"
				         data-auto_select="false"
				         data-context="signin">
				      </div>
				      <div class="g_id_signin"
				         data-type="icon"
				         data-size="large"
				         data-theme="outline"
				         data-text="sign_in_with"
				         data-shape="circle"
				         data-logo_alignment="center"
				         >
				      </div>
					</div>
				    
					<div id="kakao-wrap">
						<a id="kakao-login-btn" href="javascript:loginWithKakao()">
						  <img src="<%=request.getContextPath() %>/resources/img/kakao_login_circle.png" alt="????????? ????????? ??????" width="40px"/>
						</a>
					</div>
					<div id="naver-wrap">
						<a id="naver-login-btn" href="${NaverLoginUrl }">
						  <img src="<%=request.getContextPath() %>/resources/img/naver_login_circle.png" alt="????????? ????????? ??????" width="40px"/>
						</a>
					</div>
					</div>
					<hr class="horizontal-hr">
					<div class="login-menu">
							<a href="<%=request.getContextPath()%>/join.do" class="form-a">
								<span class="form-text">?????? ????????? ?????????????<span class="form-link"> ????????????</span></span> 
							</a>
						</div>
				</div>
			</div>
		</div>
	</div>
	
	<!-- ????????? ????????? ?????? ?????? -->
		<div class="member-modal">
		<div class="member-modal-body">
			<div class="member-modal-title member-alert">
				<span>????????? ??????</span>
			</div>
			<hr>
			<div class="member-modal-content member-alert">
				<span>???????????? ????????? ??????????????? ???????????????.</span>
				<div class="input-wrap" style="color:gray;">
					<span id="email-auth-span"></span>
				</div>
				<div class="input-wrap">
					<input id="input-authKey" class="member-input form-input">
				</div>
				<br>
				<input type="button" value="?????????" class="member-emp" id="protect-login-btn">
				<input type="button" value="??????" id="protect-cancle-btn">
			</div>
		</div>
	</div>
</body>
</html>