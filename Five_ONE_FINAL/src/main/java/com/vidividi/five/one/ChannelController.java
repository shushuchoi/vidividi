package com.vidividi.five.one;

import java.io.File;

import java.io.IOException;

import java.io.PrintWriter;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


import org.json.simple.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.context.request.ServletWebRequest;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.vidividi.model.BundleDAO;
import com.vidividi.model.ChannelDAO;
import com.vidividi.model.VideoPlayDAO;
import com.vidividi.service.LoginService;
import com.vidividi.variable.BundleDTO;
import com.vidividi.variable.CategoryDTO;
import com.vidividi.variable.ChannelDTO;
import com.vidividi.variable.MemberDTO;
import com.vidividi.variable.PlaylistDTO;
import com.vidividi.variable.SubscribeDTO;
import com.vidividi.variable.VideoPlayDTO;


@Controller
public class ChannelController {
	private userUpload up;
	
	@Inject
	private ChannelDAO dao;
	
	@Inject
	private VideoPlayDAO videodao;
	
	@Inject
	private BundleDAO bundledao;
	
	@Autowired
	private LoginService service;
	
	
	@Autowired
	private UploadFile uploadFile;
	
	private String sendPosition;
	
	public String dynamicPath() {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		return request.getServletContext().getRealPath("resources");
	}
	
	
	@RequestMapping("channel.do")
	public String channel(@RequestParam("mc") String channelCode,HttpServletRequest request, HttpSession session, Model model) throws Exception {
		
		String memCode = (String)session.getAttribute("MemberCode"); // ?????? ??????
		String repCode = (String)session.getAttribute("RepChannelCode"); // ?????? ??????
		
		// @RequestParam("mc") String channelCode ????????? ????????????
		
		if(memCode != null) {
			ChannelDTO channeldto = this.dao.getChannelOwner(channelCode); // 1. ????????? ?????? ???
			
			List<VideoPlayDTO> channelVideoDto = this.dao.getVideoList(channelCode); // 2. ????????? ??????
			int allOpen = 0;
			for(VideoPlayDTO list: channelVideoDto) {
				allOpen = allOpen + Integer.parseInt(list.getVideo_view_cnt());
			}
			channeldto.setChannel_view_cnt(allOpen);
			
			List<BundleDTO> bundle = this.bundledao.getBundleList(channelCode); // 3. ???????????? ?????????
			
			VideoPlayDTO newVideo = this.dao.getNewVideo(channelCode); // 4. ?????? ????????? ?????? ??????
			
			SubscribeDTO subdto = new SubscribeDTO();
			subdto.setChannel_code(channelCode);
			subdto.setMember_code(repCode);
			
			int subCheck = this.dao.checkSubscribe(subdto); // 5. ?????? ??????
			
			model.addAttribute("currentOwner", channeldto);
			model.addAttribute("currentVideo", channelVideoDto);
			model.addAttribute("bundleList", bundle);
			model.addAttribute("currentNewVideo", newVideo);
			model.addAttribute("subCheck", subCheck);
			
			return "channel/channel_main";
		} else {
			return "main";
		}
	}
	
	@ResponseBody
	@RequestMapping(value = "bundleSetList.do", produces = "application/text; charset=UTF-8")
	public String bundleVideoList(@RequestParam("bundle_Code") String bundleCode, HttpServletResponse response, HttpServletRequest request) {
		response.setContentType("text/html; charset=UTF-8");
		
		List<VideoPlayDTO> playdto = this.dao.getPlayListDetails(bundleCode);
		JSONArray jsonArray = new JSONArray();
		
		int rowsize = 4;
		int page = 0;
		
		if(request.getParameter("page") != null) {
			page = Integer.parseInt(request.getParameter("page").trim());
		}
		
		if(playdto.toString() == "[]") {
			return "[]";
		} else {
			for(VideoPlayDTO dto : playdto) {
				JSONObject json = new JSONObject();
				json.put("bundle_code", dto.getBundle_code());
				json.put("bundle_title", dto.getBundle_title());
				json.put("video_code", dto.getVideo_code());
				json.put("video_title", dto.getVideo_title());
				json.put("video_regdate", dto.getVideo_regdate());
				json.put("video_view_cnt", dto.getVideo_view_cnt());
				json.put("channel_code", dto.getChannel_code());
				
				jsonArray.add(json);
			}			
		}
		return jsonArray.toString();
	}
	
	@ResponseBody
	@RequestMapping(value = "bundle_bundle_list.do", produces = "application/text; charset=UTF-8")
	public String bundleBundleList(@RequestParam("bundleCode") String code, HttpServletResponse response) {
		
		String video_code = "";
		try {
			PlaylistDTO playdto = this.dao.getBundleBundleList(code);
			
			video_code = playdto.getVideo_code();
		} catch (NullPointerException e) {
			return "null";
		}
		return video_code;
	}
	
	// ?????? ?????????
	@RequestMapping("movie_upload.do")
	public String modalUploadPage(HttpServletRequest request, HttpSession session, Model model, @RequestParam("code") String ownerCode) {
		// ????????? ?????????
		
		String repChannelCode = (String)session.getAttribute("RepChannelCode");
		// ????????? ?????? ?????? ?????????
		
		
		//if(repChannelCode.equals(ownerCode)) { } else { } ????????? ??????
		ChannelDTO channelDTO = new ChannelDTO();
		channelDTO.setChannel_code(repChannelCode);
		
		List<BundleDTO> bundleList = this.bundledao.getBundleList(ownerCode); // ???????????? ?????????
		
		List<CategoryDTO> categoryList = this.videodao.getCategoryList(); // ???????????? ?????????
		
		
		model.addAttribute("uploadOwner", ownerCode);
		model.addAttribute("list", bundleList);
		model.addAttribute("cateList", categoryList);
		
		return "channel/movie_upload";
	}
	
	
	@RequestMapping("upload_success.do")
	public void upload(
			@RequestParam("channelCode") String channelCode,
			@RequestParam("title_field") String title, 
			@RequestParam("cont_area") String context,
			@RequestParam("category_List") String categoryList,
			@RequestParam("video_playList") String bundleCode, 
			@RequestParam("select_Age") String age, 
			@RequestParam("select_openClose") String open,
			@RequestParam("bundleText") String bundleText,
			MultipartHttpServletRequest mRequest, 
			Model model, 
			HttpServletRequest request, HttpSession session, 
			HttpServletResponse response) throws IOException {
		
		
		// categoryList: ?????? ?????? ????????????
		// bundleCode: ?????? ?????? ??????
		// bundleText: ?????? ?????? ??????
		
		response.setContentType("text/html charset=UTF-8");
		
		// ?????? ????????? ?????? ????????? ?????? ????????? ???????????? ????????? ??????
		String lastChannelCode = (String)session.getAttribute("RepChannelCode");
		
		PrintWriter out = response.getWriter();
		
		String[] name = fileName(mRequest); // ????????? ????????????
		
		if(uploadFile.fileUpload(mRequest, lastChannelCode.trim(), title.trim())) {
			System.out.println("??????");
		} else {
			System.out.println("??????");
		}
		
		String cookingVideoCode = service.generateVideoCode(); // ???????????????
		int category = Integer.parseInt(categoryList);
		String img = name[1];
		// video_play ?????????
		VideoPlayDTO playdto = new VideoPlayDTO();
		playdto.setVideo_code(cookingVideoCode.trim());
		playdto.setChannel_code(channelCode.trim()); // ?????? ??????
		playdto.setVideo_title(title.trim());
		playdto.setVideo_cont(context.trim());
		if(!(img.equals(""))) {
			playdto.setVideo_img(title + ".png");			
		} else {
			playdto.setVideo_img("");
		}
		playdto.setVideo_hash(null);
		playdto.setCategory_code(category); // value??? ????????????
		
		// playlist ?????????
		PlaylistDTO playbundledto = new PlaylistDTO();
		playbundledto.setChannel_code(channelCode.trim());
		playbundledto.setPlaylist_title(bundleText.trim()); // ???????????? ??????
		playbundledto.setPlaylist_code(bundleCode.trim()); // ???????????? ??????
		playbundledto.setVideo_code(cookingVideoCode.trim());
		
		//System.out.println("age: " + age.trim());
		
		if(age.trim().equals("??? ????????? ?????????")) {
			playdto.setVideo_age("true");
		} else if(age.trim().equals("????????? ????????? ?????????")) {
			playdto.setVideo_age("false");
		} else {
			out.println("<script>"
					+ "alert('???????????? ??????');");
			out.println("history.back();"
					+ "</script>");
		}
		
		if(open.trim().equals("??????????????? ?????? ??????")) {
			//bundledto.setPlaylist_open(1); // ???????????? ??????
			playdto.setVideo_open(1); // ????????? ??????
		} else if(open.trim().equals("?????? ??????")) {
			//bundledto.setPlaylist_open(0); // ???????????? ?????????
			playdto.setVideo_open(0); // ????????? ?????????
		} else {
			out.println("<script>"
					+ "alert('???????????? ??????');");
			out.println("history.back();"
					+ "</script>");
		}
		
		int check = this.dao.setVideoUpload(playdto, playbundledto);
		
		
		System.out.println("check: " + check);
		if(check > 0 ) {
			out.println("<script>"
					+ "alert('????????? ??????');"
					+ "location.href='" + request.getContextPath() +"/channel.do?mc="+ channelCode +"';");
			out.println("</script>");
		} else {
			out.println("<script>"
					+ "alert('????????? ??????');"
					+ "history.bakc();");
			out.println("</script>");
		}
		
		
	}
	
	
	// ?????? ?????? ?????????
	@RequestMapping("channel_manager.do")
	public String manager(Model model, @RequestParam("code") String code, HttpServletResponse response, HttpServletRequest request,
			HttpSession session) throws IOException {
		response.setContentType("text/html; charset=UTF-8");
		String memCode = (String)session.getAttribute("MemberCode"); // ?????? ??????
		String repCode = (String)session.getAttribute("RepChannelCode"); // ?????? ??????
		
		String path = "";
		
		PrintWriter out = response.getWriter();
		
		if(!(code.trim().equals(""))) {
			if(repCode.trim().equals(code.trim())) {
				MemberDTO memdto = new MemberDTO();
				memdto.setMember_rep_channel(code);
				memdto.setMember_code(memCode);
				
				ChannelDTO channelDTO =  this.dao.getChannelOwner(code); // ????????? ?????????
				List<VideoPlayDTO> videoList = this.dao.getVideoList(code); // ?????? ????????? ?????????
				List<BundleDTO> bundle = this.bundledao.getBundleList(code); // ???????????? ?????????
				
				model.addAttribute("currentOwner", channelDTO);
				model.addAttribute("mvList", videoList);
				model.addAttribute("bundleList", bundle);
				path = "channel/channel_manager";
			} else {
				out.println("<script>");
				out.println("alert('????????? ???????????????.');");
				out.println("location.href='"+ request.getContextPath() + "/main.do';");
				out.println("</script>");
			}
		} else if(code.trim().equals("")) {
			out.println("<script>");
			out.println("alert('????????? ?????????????????????.');");
			out.println("location.href='"+ request.getContextPath() + "/main.do';");
			out.println("</script>");
		} else {
			path = "main";
		}
		
		return path;
	}
	
	// ?????? ????????? ????????? ?????????
	@RequestMapping("channel_profil.do")
	public void profilImg(Model model, HttpServletResponse response) throws IOException {
		
	}
	
	
	// ?????? ?????? ?????????
	@RequestMapping("video_update_modal.do")
	public String setVideoUpdate(Model model, @RequestParam("video_code") String code, HttpServletResponse response) {
		response.setContentType("text/html; charset=UTF-8");
		
		VideoPlayDTO playdto = new VideoPlayDTO();
		
		playdto = this.videodao.getVideoOne(code); // ????????? ??????
		
		List<CategoryDTO> categoryList = this.videodao.getCategoryList(); // ???????????? ?????????
		List<BundleDTO> bundleList = this.bundledao.getBundleList(playdto.getChannel_code()); // ???????????? ?????????
		
		model.addAttribute("list", playdto); // videoplay
		model.addAttribute("cateList", categoryList); // category
		model.addAttribute("playBundle", bundleList); // bundle
		
		
		return "channel/channel_update_modal";
	}
	
	
	// ??????, ????????? ?????????
	@RequestMapping("video_update_success.do")
	public void setVideoUpdateSuccess(MultipartHttpServletRequest mRequest,
			HttpServletResponse response,
			HttpServletRequest request,
			@RequestParam("subVideoCode") String videoCode, 
			@RequestParam("video_title") String title, 
			@RequestParam(value="video_cont", required = false) String cont,
			@RequestParam("category_List") String categoryCode,
			@RequestParam("bundleValue") String bundleValue,
			@RequestParam("bundleText") String bundleText,
			@RequestParam("select_Age") String age,
			@RequestParam("select_openClose") String open,
			@RequestParam("video_name") String video_name,
			@RequestParam("img_name") String img_name,
			@RequestParam("channelCode") String channelCode) throws IOException {
		
		
		response.setContentType("text/html charset=utf-8");
		
		String[] name = fileName(mRequest); // ????????? ????????????
		for(int i=0; i<name.length; i++) {
			System.out.println("name: "+ name[i]);
		}
		// ?????? ??? ??????
		//videoCode
		VideoPlayDTO playdtoSearch = this.videodao.getVideoOne(videoCode);
		
		
		if(fileDelete(video_name.trim(), channelCode.trim(), playdtoSearch)) {
			System.out.println("?????? ??????: " + playdtoSearch.getVideo_title());
		} else {
			System.out.println("????????? ???????????? ????????????.");
		}
		
		if(ImgDelete(img_name.trim(), channelCode.trim(), playdtoSearch)) {
			if(!(playdtoSearch.getVideo_img().trim() == null)) {
				System.out.println("?????? ??????: " + playdtoSearch.getVideo_img().trim());				
			} else {
				System.out.println("???????????? ???????????? ????????????.");
			}
			
		} else {
			System.out.println("???????????? ???????????? ????????????.");
		}
		
		
		if(uploadFile.fileUpload(mRequest, channelCode.trim(), title.trim())) {
			System.out.println("??????");
		} else {
			System.out.println("??????");
		}
		
		// ?????? ??? ?????? ???
		
		// DB??? ??????
		PrintWriter out = response.getWriter();
		
		VideoPlayDTO videodto = new VideoPlayDTO();
		videodto.setVideo_code(videoCode);
		videodto.setVideo_title(title);
		videodto.setVideo_cont(cont);
		videodto.setCategory_code(Integer.parseInt(categoryCode));
		if(!(img_name.trim().equals("????????? ??????????????????"))) {
			videodto.setVideo_img(title.trim() + ".png");				
		} 
		
		if(age.trim().equals("??? ????????? ?????????")) {
			videodto.setVideo_age("true");
		} else if(age.trim().equals("????????? ????????? ?????????")) {
			videodto.setVideo_age("false");
		} else {
			out.println("<script>"
					+ "alert('???????????? ??????');");
			out.println("history.back();"
					+ "</script>");
		}
		
		if(open.trim().equals("??????????????? ?????? ??????")) {
			//bundledto.setPlaylist_open(1); // ???????????? ??????
			videodto.setVideo_open(1); // ????????? ??????
		} else if(open.trim().equals("?????? ??????")) {
			//bundledto.setPlaylist_open(0); // ???????????? ?????????
			videodto.setVideo_open(0); // ????????? ?????????
		} else {
			out.println("<script>"
					+ "alert('???????????? ??????');");
			out.println("history.back();"
					+ "</script>");
		}
		
		
		PlaylistDTO playdto = new PlaylistDTO();
		playdto.setPlaylist_code(bundleValue);
		playdto.setPlaylist_title(bundleText);
		playdto.setVideo_code(videoCode);
		
		
		int check = this.videodao.updateUploadVideo(videodto, playdto);
		if(check > 0) {
			out.println("<script>"
					+ "location.href ='"+ request.getContextPath() +"/channel_manager.do?code=" + channelCode +"';");
			out.println("</script>");
		} else {
			out.println("<script>"
					+ "history.back();"
					+ "</script>");
		}
		// DB??? ?????? ???
	}
	
	
	// ???????????? ????????????
	@ResponseBody
	@RequestMapping(value="bundleList.do", produces = "application/text; charset=UTF-8")
	public String bundleList(@RequestParam("ownerCode") String code, HttpServletResponse response) throws IOException {	
		response.setContentType("text/html; charset=UTF-8");
		
		JSONArray jsonArray = new JSONArray();
		List<BundleDTO> bundleList = this.bundledao.getBundleList(code);
		for(BundleDTO dto: bundleList) {
			JSONObject json = new JSONObject();
			json.put("bundle_code", dto.getBundle_code());
			json.put("bundle_title", dto.getBundle_title());
			json.put("bundle_regdate", dto.getBundle_regedate());
			json.put("bundle_open", dto.getPlaylist_open());
			json.put("channel_code", dto.getChannel_code());
			
			jsonArray.add(json);
		}
		return jsonArray.toString();
	}
	
	
	
	@ResponseBody
	@RequestMapping(value = "bundleMaking.do", produces = "application/text; charset=UTF-8")
	public String bundleMaking(@RequestParam("code") String code, @RequestParam("bundleN") String bundleName, HttpServletResponse response, HttpServletRequest request) throws IOException {
		response.setContentType("text/html; charset=UTF-8");
		
		
		String bundleCode = service.generateBundleCode();
		
		BundleDTO bundledto = new BundleDTO();
		bundledto.setBundle_code(bundleCode);
		bundledto.setBundle_title(bundleName);
		bundledto.setChannel_code(code);
		
		int check = this.bundledao.bundleAdd(bundledto);
		String arr = "";
		
		if(check > 0) {
			arr = bundleList(code, response);
		}
		
		return arr;
	}
	
	// ???????????? ??????
	@ResponseBody
	@RequestMapping(value = "BundleDelete.do", produces = "application/text; charset=UTF-8")
	public String bundleDelete(@RequestParam("bundleCode") String code, @RequestParam("ownerCode") String ownerCode, HttpServletResponse response) throws IOException {
		response.setContentType("text/html; charset=UTF-8");
		
		int check = this.bundledao.bundleDel(code);
		String arr = "";

		if(check > 0) {
			arr = bundleList(ownerCode, response);
		} else {
			arr = "[]";
		}
		
		return arr;
	}
	
	// ??????????????? ?????? ????????? ????????????
	@ResponseBody
	@RequestMapping(value = "videoListBundle.do", produces = "application/text; charset=UTF-8")
	public String videoListBundle(@RequestParam("bundleCode") String bundleCode, HttpServletResponse response) {
		response.setContentType("text/html; charset=UTF-8");
		
		
		List<VideoPlayDTO> list = this.dao.getPlayListDetail(bundleCode);
		JSONArray arr = new JSONArray();
		for(VideoPlayDTO dto : list) {
			JSONObject json = new JSONObject();
			json.put("video_code", dto.getVideo_code());
			json.put("channel_code", dto.getChannel_code());
			json.put("channel_name", dto.getChannel_name());
			json.put("video_title", dto.getVideo_title());
			json.put("video_cont", dto.getVideo_cont());
			json.put("video_img", dto.getVideo_img());
			json.put("video_good", dto.getVideo_good());
			json.put("video_bad", dto.getVideo_bad());
			json.put("video_view_cnt", dto.getVideo_view_cnt());
			json.put("video_hash", dto.getVideo_hash());
			json.put("video_regdate", dto.getVideo_regdate());
			json.put("video_open", dto.getVideo_open());
			json.put("category_code", dto.getCategory_code());
			json.put("video_age", dto.getVideo_age());
			
			arr.add(json);
		}
		System.out.println("arr: " + arr.toString());
		return arr.toString();
	}
	
	// ?????? ??????
	@ResponseBody
	@RequestMapping(value = "subscribe.do", produces = "application/text; charset=UTF-8")
	public String subScribe(@RequestParam Map<String, Object> map) {
		String owner = (String)map.get("ownerCode");
		String mem = (String)map.get("memCode");
		
		String subCode = service.generateSubscribeCode();
		
		SubscribeDTO subdto = new SubscribeDTO();
		
		subdto.setSubscribe_code(subCode);
		subdto.setChannel_code(owner);
		subdto.setMember_code(mem);
		
		if(this.dao.inOutSubscribe(subdto)) {
			return "insert";
		} else {
			return "delete";
		}
	}
	
	// ?????? ?????? ????????????
	public String[] fileName(MultipartHttpServletRequest mRequest) {
		Iterator<String> iterator = mRequest.getFileNames();
		String[] name = new String[2];
		int count = 0;
		while(iterator.hasNext()) {
			String uploadFileName = iterator.next();
			MultipartFile mFile = mRequest.getFile(uploadFileName);
			String orginalFilename = mFile.getOriginalFilename();
			
			name[count] = orginalFilename;
			count++;
		}

		return name;
	}
	
	//????????????
	public String[] hashTag(String context) {
		String[] hash = context.split("#");
		
		for(int i=0; i<hash.length; i++) {
			
		}
		return null;
	}
	
	// ?????? ?????? ??????
	public boolean fileDelete(String video, String channelCode, VideoPlayDTO playdtoSearch) throws IOException {
		boolean check = false;
		
		String video_dir = "/Users/maclee/Public/Spring/Github/Five_ONE_Final/Five_ONE_FINAL/src/main/webapp/resources/AllChannel/" + channelCode + "/" + playdtoSearch.getVideo_title().trim();
		File dir = new File(video_dir);
	
		if(!(video.trim().equals(playdtoSearch.getPlayList_title()))) { // ???????????? ???
			if(dir.exists()) {
				if(dir.delete()) {
					return true;
				}
			}
		}
		
		return check;
	}
	
	public boolean ImgDelete(String img, String channelCode, VideoPlayDTO playdtoSearch) {
		boolean check = false;
		if(!(playdtoSearch.getVideo_img() == null)) {
			String img_dir = "/Users/maclee/Public/Spring/Github/Five_ONE_Final/Five_ONE_FINAL/src/main/webapp/resources/AllChannel/" + channelCode + "/thumbnail/" + playdtoSearch.getVideo_img().trim();
			File dir = new File(img_dir);
			
			if(!(img.trim().equals(playdtoSearch.getVideo_img()))) {
				if(dir.exists()) {
					if(dir.delete()) {
						return true;
					}
				}
			}
		} else {
			return false;
		}
			
		return check;
	}
	
	public void res() throws IOException {
		ServletWebRequest servletContainer = (ServletWebRequest)RequestContextHolder.getRequestAttributes();
		HttpServletResponse response = servletContainer.getResponse();
		PrintWriter out = response.getWriter();
		
		out.println("<script>");
		out.println("alert('?????? ??????');");
		out.println("history.back();");
		out.println("</script>");
	}
}
