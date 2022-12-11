/**
 selecting all required elements
 */
 
 const dragArea = document.querySelector(".drag-area"),
 dragText = dragArea.querySelector("header"),
 button = dragArea.querySelector(".upload_click_btn"),
 input = dragArea.querySelector(".upload_input_file"),
 span = dragArea.querySelector("span"),
 submit_video = dragArea.querySelector(".submit_video"),
 file_div = dragArea.querySelector(".file_div");

 let file; // drop 한 파일의 전역 변수 이름명
 let fileURL; // drop한 파일의 경로
 
 let video; // 영상
 let uploadtitle; // 영상 제목
 let uploadCont; // 영상 설명
 let selectPlayList; // 영상 재생목록
 let selectAn; // 아동용&성인용
 
 button.onclick = () => {
 	input.click();	// 만약 클릭버튼을 클릭했을 때 >> input이 클릭
 }

 // 클릭버튼 눌렀을때
 input.addEventListener("change", function() {
 	file = this.files[0];
 	
 	let fileType = file.type;
 	
 	let vaildExtensions = ["video/quicktime", "video/mp4", "video/wmv", "video/avi", "video/avchd", "video/mpeg-2"]; // 모든 목록
 	
 	// 사용자가 vaildExtensions에 있는 이외의 파일을 넣었을때
 	if(vaildExtensions.includes(fileType)) {
	 	showFile() // calling function 	
 	} else {
		alert("MOV, MP4, WMV, AVI, AVCHD, mpeg-2 파일을 넣어주세요.");
	}
	
 	//console.log("input =" + input.files[0].name);
 });
 
 // 사용자가 파일을 드래그 했을 때 발생
 dragArea.addEventListener('dragover', (event) => {
 	event.preventDefault();
 	dragArea.classList.add("active");
 	
 	dragText.textContent = "Release to Upload File";
 });
 
 // 사용자가 파일을 드래그 밖으로 뺏을때 했을 때 발생
 dragArea.addEventListener('dragleave', (event) => {
 	event.preventDefault();
 	dragArea.classList.remove("active");
 	
 	
 	dragText.textContent = "Drag & Drop to Upload File";
 });
 
 
 // 사용자가 파일을 넣었을때
 dragArea.addEventListener('drop', (event) => {
 	event.preventDefault(); // 화면에 자동생성 막기
 	 	
 	// 전역변수에 파일 넣기
 	file = event.dataTransfer.files[0];
	let fileType = file.type;
	
	let vaildExtensions = ["video/quicktime", "video/mp4", "video/wmv", "video/avi", "video/avchd", "video/mpeg-2"]; // 모든 목록
	if(vaildExtensions.includes(fileType)) {
	    //DataTransfer로 받아올 수 있음
		const data = event.dataTransfer;
				    
		//* Drag&Drop 된 파일을 input file의 내용으로 교체
		$('#upload_input_file')[0].files = data.files;
		
	 	showFile() // calling function
	} else {
		alert("MOV, MP4, WMV, AVI, AVCHD, mpeg-2 파일을 넣어주세요.");
	}
			
 });
 
 // 파일을 클릭, 업로드 했을때 발생
 function showFile() {
	let fileReader = new FileReader();
    let reader = new FileReader();
    let file_name;

    reader.fileName = file.name;
    

	fileReader.onload = function(e) {
        fileURL  = fileReader.result;
        let videoTag = `<video><source src="${fileURL}"></video>`;
        submit_video.innerHTML = videoTag;
	    
        fileReader.fileName = file.name;
		file_name = e.target.fileName;
	};
	   
    
    let change_img = document.querySelector('.icon_change');
    
    button.type = "hidden";
    //input.type="hidden";
    
    submit_video.style.height='100%';
    submit_video.style.width='100%';
    $(".submit_video").css("padding-top","10%");
			
    fileReader.readAsDataURL(file);
 }
 
 $(function() {
 	
 });
 
 
 
 // 업로드 버튼 클릭시@@@@@@@@@@@@@@@@@@@@@@@@
 function upload_seccess() {
 	$.ajaxSetup({
			ContentType: "application/x-www-form-urlencoded;charset=UTF-8", //한글처리
			type: "post"
	});
	
	let selectRadio; // input radio의 id값 가져오기
	video = $("#upload_input_file").val();
	
	if(!video == "") {
		if(!$("#floatingTextarea2").val().trim() == "") { //제목 공백
			if($("#floatingTextarea3").val().trim() == "") { // 영상 내용
				//제목
				this.uploadtitle = $("#floatingTextarea2").val();

				//내용
				this.uploadCont = $("#floatingTextarea3").val(null);
				

				// 재생목록
				//console.log($("#play_List option:selected").val());
				this.selectPlayList = $("#play_List option:selected").text();
				
				// 시청자층
				selectRadio = $('input[name=flexRadioDefault]:checked').attr("id");
				this.selectAn = $("label[for='"+selectRadio+"']").text();
			
				upload_move();
			} else {
				//제목
				this.uploadtitle = $("#floatingTextarea2").val();

				//내용
				this.uploadCont = $("#floatingTextarea3").val();

				// 재생목록
				//console.log($("#play_List option:selected").val());
				this.selectPlayList = $("#play_List option:selected").text();
				
				// 시청자층
				selectRadio = $('input[name=flexRadioDefault]:checked').attr("id");
				this.selectAn = $("label[for='"+selectRadio+"']").text();
				
				upload_move();
			}
		} else {
			alert("제목을 작성해주세요");
		}
	} else {
		alert("업로드할 영상이 없어요!");
	} 
 }
 // 업로드 버튼 종료

 // 업로드 하기
function upload_move() {
	$.ajaxSetup({
		ContentType: "application/x-www-form-urlencoded;charset=UTF-8", //한글처리
		type: "post"
	});

	var form = document.createElement('form');
	const url= "/one/upload_success.do";
	form.setAttribute("method", "post");
	form.setAttribute("id", "send_form");
	form.setAttribute("enctype", "multipart/form-data");
	form.setAttribute("action", url);
	
	var hiddenField1 = document.createElement('input');
	hiddenField1.setAttribute('type', 'hidden');
	hiddenField1.setAttribute('name', "1");
	hiddenField1.setAttribute('value', this.uploadtitle);
	
	var hiddenField2 = document.createElement('input');
	hiddenField2.setAttribute('type', 'hidden');
	hiddenField2.setAttribute('name', "2");
	hiddenField2.setAttribute('value', this.uploadCont);

	var hiddenField3 = document.createElement('input');
	hiddenField3.setAttribute('type', 'hidden');
	hiddenField3.setAttribute('name', "3");
	hiddenField3.setAttribute('value', this.selectPlayList);

	var hiddenField4 = document.createElement('input');
	hiddenField4.setAttribute('type', 'hidden');
	hiddenField4.setAttribute('name', "4");
	hiddenField4.setAttribute('value', this.selectAn);

	$(".modal-body").append(form);
	$("#send_form").submit();



	// let form = new FormData();
	// form.append("upload_input_file", $("#upload_input_file")[0].files[0]);

	// $.ajax({
	// 	url: "/Five_ONE_FINAL/upload_success.do",
	// 	data: {
	// 		form,
	// 		title: this.uploadtitle,
	// 		context: this.uploadCont,
	// 		playList: this.selectPlayList,
	// 		age: this.selectAn
	// 	},
	// 	success: function(data) {
	// 		console.log("test");
	// 	},
	// 	error: function() {
	// 		alert("데이터 통신 오류");
	// 	}
	// });
}

 