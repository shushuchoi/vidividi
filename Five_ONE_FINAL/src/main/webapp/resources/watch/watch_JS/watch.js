$(document).ready(function() {


	//$("link[rel=stylesheet][href*='https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css']").remove();

	function getContextPath(){
		
		let path = location.href.indexOf(location.host)+location.host.length;
		
		return location.href.substring(path, location.href.indexOf('/', path+1));
	}

	let video_code = $("#video_code").val();
	let channel_code = $("#channel_code").val();
	let category_code = $("#category_code").val();

	let navOption = "all";
	let reply_option = "most";

	let page_reply = 1;
	let page_comment;
	let page_nav = 1;
	
	let loading_reply = true;
	let loading_nav = true;
	
	let nav_list;

	let scroll_check = false;



	function getReply(video_code, reply_option, page_reply){


		$.ajax({

			url : getContextPath() +"/reply.do",
			data : {
				"video_code" : video_code,
				"reply_option" : reply_option,
				"page" : page_reply 
			},
			datatype : 'JSON',
			contentType : "application/json; charset=UTF-8",
			success : function(data){
				
				let str = data;

				if(str == "[]"){
					loading_reply = false;
					return;
				}else{
					let reply = JSON.parse(data);

					let div = "";

					//div += myReply;

					$(reply).each(function(){

						let reply_cont = this.reply_cont.replaceAll("\\n","<br>");

						div += "<div class='reply_box card_a' data-value='" +this.check_good+ "' data-code='" +this.check_code+ "'>";
						
						div += "<input type='hidden' class='reply_code' name='reply_code' value='" +this.reply_code+ "'>";
						div += "<input type='hidden' class='reply_group' name='reply_group' value='" +this.reply_group+ "'>";

						div += "<div class='item_a'>";
						div += "<div class='reply_wrap'>";
						div += "<div class='input_profile'><img class='profile' src='" +getContextPath()+ "/resources/img/" +this.channel_profil+ "'></div></div></div>";

						div += "<div class='input_reply item_a'>";

						div += "<div id='input_reply_writer' class='writer_info'>";
						div += "<span class='reply_writer'>" +this.channel_name+"</span>";
						div += "<span class='reply_date'>" +this.reply_regdate+ "</span>";
						div += "</div>";

						div += "<div class='reply_cont_box'>";
						div += "<div id='input_reply_cont'>" +reply_cont+ "</div>";
						//div += "<div id='input_reply_cont'>" +repalceEnter(this.reply_cont)+ "</div>";
						div += "</div>";

						div += "<div class='reply_action_box'>";
						div += "<div class='toolbar_wrap card_a'>";

						div += "<div class='reply_good_btn'><div class='card_b'>";
						if(this.check_good == 1){
							div += "<img class='reply_good' src='" +getContextPath()+ "/resources/watch/watch_img/good_icon_selected.svg'>";
						}else{
							div += "<img class='reply_good' src='" +getContextPath()+ "/resources/watch/watch_img/good_icon.svg'>";
						}
						div += "<div class='good_cnt'>" +this.reply_good+ "</div></div></div>" //reply_goodbtn;

						div += "<div class='reply_bad_btn'>";
						if(this.check_good == 2){
							div += "<img class='reply_bad' src='" +getContextPath()+ "/resources/watch/watch_img/bad_icon_selected.svg'>";
						}else{
							div += "<img class='reply_bad' src='" +getContextPath()+ "/resources/watch/watch_img/bad_icon.svg'>";
						}
						div += "</div>"; // reply_bad_btn

						div += "<div class='reply_comment_btn'>답글</div>";
						div += "</div>"; // .toolbar_wrap
						div += "</div>"; // .reply_action_box
						
						div += "</div>"; // .input_reply


						div += "<div class='render_box'><div class='render_wrap'><button class='render'><img class='render_icon' src='" +getContextPath()+ "/resources/watch/watch_img/render_icon.png'></button></div></div>";
						div += "</div>"; // .reply_box

						if(this.reply_comment == 1){

							div += "<div class='comment_box'>";
							div += "<div class='comment_menu card_c'><div class='comment_btn close'><button class='comment_toggle card_a' value='" +this.reply_group+ "'><img class='toggle open' src='" +getContextPath()+ "/resources/watch/watch_img/comment_open.png'>";
							div += "<div class='comment_count'>답글" +this.comment_count+ "개</div>";
							div += "</button></div>"
							div += "</div>" // .comment_wrap
							div += "<div class='input_comment'></div>";
							div += "</div>"; //.comment_box
						}

						
						
						//div += "</div></div>";
					});
					
					
					$("#input_reply_box").append(div);
				}
			},

			error : function(request, status, error){
				console.log("code: " + request.status);
				console.log("message: " + request.responseText);
				console.log("error: " + error);
			}
			
		}); 

	}	// getReply() end


	function getComment(video_code, reply_group, page_comment, tag){

		let div = "";

		$.ajax({
			

			url : getContextPath() +"/comment.do",
			data : {
				"video_code" : video_code,
				"reply_group" : reply_group,
				"page" : page_comment
			},
			datatype : 'JSON',
			contentType : "application/json; charset=UTF-8",
			async : false,
			success : function(data){

				let comment = JSON.parse(data);


				if(comment == "[]"){
					div += data;
				}else{
					$(comment).each(function(){
						
						let reply_cont = this.reply_cont.replaceAll("\\n","<br>");

						div += "<div class='comment_wrap card_a' data-value='" +this.check_good+ "' data-code='" +this.check_code+ "'>"; //card
						div += "<input type='hidden' class='reply_code' name='reply_code' value='" +this.reply_code+ "'>";
						// commnet_wrap(item1)
						div += "<div class='profile'>"; //.comment_wrap(item1)
						div += "<img class='profile' src='" +getContextPath()+ "/resources/img/" +this.channel_profil+ "'>";
						div += "</div>"; //.profile end
						//comment_wrap(item2)
						div += "<div class='comment_card card_c'>"; //card
						// comment_card(item1)
						div += "<div id='input_comment_writer' class='writer_info'>"; 
						div += "<span class='reply_writer'>" +this.channel_name+ "</span>";
						div += "<span class='reply_date'>" +this.reply_regdate+ "</span>";	
						div += "</div>"; //#input_comment_writer end
						// comment_card(item2)
						div += "<div class='reply_cont_box'>"; 
						div += "<div id='input_comment_cont'>" +reply_cont+ "</div>";
						div += "</div>"; //.reply_cont_box end
						// comment_card(item3)
						div += "<div class='reply_action_box'>"; 
						div += "<div class='toolbar_wrap card_a'>" //card
						// toolbar(item1)
						div += "<div class='comment_good_btn'><div class='card_b'>"; 
						if(this.check_good == 1){
							div += "<img class='reply_good' src='" +getContextPath()+ "/resources/watch/watch_img/good_icon_selected.svg'>";
						}else{
							div += "<img class='reply_good' src='" +getContextPath()+ "/resources/watch/watch_img/good_icon.svg'>";
						}
						div += "<div class='good_cnt'>" +this.reply_good+ "</div>";
						div += "</div></div>"; //.reply_good_btn, .card_b
						// toolbar(item2)
						div += "<div class='comment_bad_btn'>"; 
						if(this.check_good == 2){
							div += "<img class='reply_bad' src='" +getContextPath()+ "/resources/watch/watch_img/bad_icon_selected.svg'>";
						}else{
							div += "<img class='reply_bad' src='" +getContextPath()+ "/resources/watch/watch_img/bad_icon.svg'>";
						}
						div += "</div>"; // .reply_bad_btn end
						div += "</div>"; //.toolbar_wrap end
						div += "</div>"; //.reply_action_box end

						div += "</div>"; //.comment_card end

						// comment_wrap(item3)
						div += "<div class='render_box'>";
						div += "<div class='render_wrap'>";
						div += "<button class='render'><img class='render_icon' src='" +getContextPath()+ "/resources/watch/watch_img/render_icon.png'></button>";
						div += "</div>"; // .render_wrap end
						div += "</div>"; // .render_box end
										
						div += "</div>"; // .comment_wrap

					});

					if(comment.length == 3){

						div += "<div class='comment_box'>";
						div += "<div class='comment_menu card_c'><div class='comment_btn close'><button class='comment_toggle_more card_a' value='" +reply_group+ "'><img class='toggle open' src='" +getContextPath()+ "/resources/watch/watch_img/comment_open.png'>";
						div += "<div class='comment_count'>답글 더보기</div>";
						div += "</button></div>"
						div += "</div>" // .comment_wrap
						div += "<div class='input_comment'></div>";
						div += "</div>"; //.comment_box
					}

						tag.append(div);
					
				}
				
			},

			error : function(){
				alert('대댓글 불러오기 error');
			}

			
		});

		return div;

	} //getComment() end

	function getNavList(navOption, channel_code, category_code, page_nav){


		$.ajax({
			url : getContextPath() +"/nav_list.do",
			data : {
				"navOption" : navOption,
				"channel_code" : channel_code,
				"category_code" : category_code
			},
			success : function(data){
				nav_list = data;
				$("#input_video_list").empty();
				getNavListSc(nav_list, navOption, page_nav);
			},
			error : function(request, status, error){
				console.log("code: " + request.status);
				console.log("message: " + request.responseText);
				console.log("error: " + error);
			}
		})

	}// getNavList() end

	function getNavListSc(nav_list, navOption, page_nav){
		let rowsize = 10;
		let startNo = ((page_nav * rowsize) - (rowsize - 1))-1;
		let endNo = (page_nav * rowsize)-1;


		let nav = "";
		if(nav_list.length == 0){
			nav += "<div class='video_list_none'>찾으시는 동영상이 없습니다.</div>";
			loading_nav = false;
			$("#input_video_list").append(nav);
			return;
		}else{
			for(let i=startNo; i<=endNo; i++){
				if(nav_list.length-1 < i){
					$("#input_video_list").append(nav);
					loading_nav = false;
					return;
				}else if(nav_list.length > i){
					nav += "<div class='video_list_box card_a'>";
					// video_list_box(item1)
					nav += "<div class='video_list_thumbnail'>";
					nav += "<a><img class='video_list_img' src='" +getContextPath()+ "/resources/watch/watch_img/" +nav_list[i].video_img+ "'></a>";
					nav += "</div>";
					// video_list_box(item2)
					nav += "<div class='video_list_info card_c'>";
					nav += "<span class='video_list_title'>" +nav_list[i].video_title+ "</span>";
					nav += "<span class='video_list_channel_name'>" +nav_list[i].channel_name+ "</span>";
					nav += "<div class='video_list_meta_block'>";
					nav += "<span class='video_list_view_cnt'>" +nav_list[i].video_view_cnt+ "</span>";
					nav += "<span class='video_list_date'>" +nav_list[i].video_regdate+ "</span>";
					nav += "</div>"; // video_list_mata_block end
					nav += "</div>"; // video_list_info end
					// video_list_box(item3)
					nav += "<div class='render_box'>";
					nav += "<div class='render_wrap'>";
					nav += "<button class='render'><img class='render_icon' src='" +getContextPath()+ "/resources/watch/watch_img/render_icon.png'></button>";
					nav += "</div>"; // .render_wrap end
					nav += "</div>";// .render_box end

					nav += "</div>"; // .video_list_box end

				}
				
			}
			
		}

		$("#input_video_list").append(nav);

		
	} // getNavListSc() end



 	 	
	 
	//  기본 실행 함수
	//let myReply = getMyreply(video_code, channel_code);
	getReply(video_code, reply_option, page_reply);
	getNavList(navOption, channel_code, category_code, page_nav);


 		




	
	
 	/* 대댓글 토글 버튼 */
	$(document).on("click", ".comment_toggle", function(){
		

		page_comment = 1;
		let toggle_img = $(this).find(".toggle");
		let reply_group = $(this).val();
		let tag = $(this).parents(".comment_menu").next(); // .input_comment
		
		if(toggle_img.hasClass("open")){ // 열린상태
			toggle_img.attr("src", getContextPath() +"/resources/watch/watch_img/comment_close.png");
			toggle_img.removeClass("open");
			toggle_img.addClass("close");

			if(tag.children().length == 0){
				getComment(video_code, reply_group, page_comment, tag);
			}
			
			tag.addClass("show");


		}else{	// 닫힌상태
			toggle_img.attr("src", getContextPath() +"/resources/watch/watch_img/comment_open.png");
			toggle_img.removeClass("close");
			toggle_img.addClass("open");

			tag.removeClass("show");
		}			 					
	
	});

	// 대댓글 토글 more
	$(document).on("click", ".comment_toggle_more", function(){

		
		let reply_group = $(this).val();
		let tag = $(this).parents(".input_comment");

		page_comment++;
		getComment(video_code, reply_group, page_comment, tag);
		$(this).remove();
	});




		// 스크롤 버튼 클릭
		$(".scrollmenu_btn").on("click", function(){

			loading_nav = true;
			page_nav = 1;
			navOption = $(this).attr("data-value");
			getNavList(navOption, channel_code, category_code, page_nav);		

		});

		$(window).scroll(function(){			
			scroll_check = true;
		});

		// 댓글 옵션 선택
		$(".video_option").on("click", function(){

			reply_option = $(this).attr("data-value");
			page_reply = 1;
			$("#input_reply_box").empty();
			getReply(video_code, reply_option, page_reply);

		});





		// 무한 스크롤
		setInterval(function() {

			if (scroll_check) {
				scroll_check = false;

				if($(window).scrollTop()>=$(document).height() - $(window).height()){
					if(loading_reply){
						page_reply++;						
						getReply(video_code, reply_option, page_reply);											
					}

					if(loading_nav){
						page_nav++;
						getNavListSc(nav_list,navOption, page_nav);
					}
				}				
			}
		}, 500); // 무한 스크롤 end





}); // document.ready end


