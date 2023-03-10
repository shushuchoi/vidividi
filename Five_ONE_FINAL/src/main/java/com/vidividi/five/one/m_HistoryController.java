package com.vidividi.five.one;

import java.io.*;
import java.util.*;
import javax.inject.*;
import javax.servlet.http.*;
import org.json.JSONObject;
import org.json.simple.JSONArray;
import org.springframework.stereotype.*;
import org.springframework.ui.*;
import org.springframework.web.bind.annotation.*;
import com.vidividi.model.*;
import com.vidividi.variable.*;

@Controller
public class m_HistoryController {
	
	@Inject
    private MyPageDAO dao;
	
	@RequestMapping("history_list.do")
	public String history_list(@SessionAttribute(name = "RepChannelCode", required = false) String code,
							@RequestParam(value="search",  required=false, defaultValue= "1") int search,
							@RequestParam(value="keyword",  required=false, defaultValue= "none") String keyword, Model model) {

		/* model.addAttribute("keyword", keyword); */
		model.addAttribute("search", search);
		return "myPage/history";
	}
	
	
	@ResponseBody
	@RequestMapping(value = "history_new.do" , produces = "application/text; charset=UTF-8")
	public String getReplyList(@SessionAttribute(name = "RepChannelCode", required = false) String code,
								int page, HttpServletResponse response) {
		
		response.setContentType("text/html; charset=UTF-8");

		int rowsize = 5;
		int startNo = (page * rowsize) - (rowsize - 1);
		int endNo = (page * rowsize);
		
		JSONArray jArray = new JSONArray();
		
		if(code == "none") {
			System.out.println("history_new.do >>> channel_code 없음!!!");
		} else {
			List<VideoPlayDTO> list = this.dao.getHistoryList(code, startNo, endNo);
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
				jArray.add(json);
			}
		} return jArray.toString(); }
	
	@ResponseBody
	@RequestMapping(value = "history_search.do" , produces = "application/text; charset=UTF-8")
	public String history_search(@SessionAttribute(name = "RepChannelCode", required = false) String code,
								@RequestParam(value="keyword",  required=false, defaultValue="none") String keyword,
								int page, HttpServletResponse response) {
		response.setContentType("text/html; charset=UTF-8");
		
		int rowsize = 5;
		int startNo = (page * rowsize) - (rowsize - 1);
		int endNo = (page * rowsize);
		
		JSONArray jArray = new JSONArray();
		
		Map<String,Object>map = new HashMap<String,Object>();
		map.put("code", code);map.put("keyword", keyword);map.put("startNo", startNo);map.put("endNo", endNo);
		
		List<VideoPlayDTO> list = null;
		
		if(keyword.equals("none")) {
			list = this.dao.getHistoryList(code, startNo, endNo);
		}else {
			list = this.dao.getHistory_search(map);
		}
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
			jArray.add(json);
		}
		return jArray.toString();
	}

	@RequestMapping("history_one_delete.do")
	public void delete_history(@RequestParam("video_code") String video,
			@SessionAttribute(name = "RepChannelCode", required = false) String channel,
								@RequestParam("search") int search,
								@RequestParam(value="keyword",  required=false, defaultValue="none") String keyword,
								HttpServletResponse response) throws IOException {
		Map<String,Object>map = new HashMap<String,Object>();
		map.put("video", video); map.put("channel", channel);
		
		// 선택된 history 데이터 지우기
		int check = this.dao.history_search_one_delete(map);
		
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		
		if(check > 0) {
			// search라면
			if(search == 2) {
				out.println("<script>");
				out.println("location.href='history_list.do?search=2&keyword="+keyword+"'");
				out.println("</script>");
			} else if(search == 1) {
				out.println("<script>");
				out.println("location.href='history_list.do?search=1&keyword="+keyword+"'");
				out.println("</script>");
			}
		}else {
			out.println("<script>");
			out.println("alert('시청기록 삭제 중 오류 발생')");
			out.println("history.back()");
			out.println("</script>");
		}
	}
	
	@RequestMapping("delete_history.do")
	public void delete_history(@SessionAttribute(name = "RepChannelCode", required = false) String code, HttpServletResponse response) throws IOException {
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		int check = this.dao.delete_history(code);
		if(check > 0) {
			out.println("<script>");
			out.println("location.href='history_list.do'");
			out.println("</script>");
		}else {
			out.println("<script>");
			out.println("alert('전체 시청기록 삭제 중 오류 발생')");
			out.println("history.back()");
			out.println("</script>");
		}
	}
	@RequestMapping("dont_save_history.do")
	public void dont_save_history(@SessionAttribute(name = "MemberCode", required = false) String MemberCode,
								@SessionAttribute(name = "RepChannelCode", required = false) String RepChannelCode,
								HttpServletResponse response) throws IOException {
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		
		System.out.println("MemberCode >>> " + MemberCode);
		
		// 시청기록 저장이 켜져있는지 확인 (0 : 꺼저 있음) (1 : 켜져 있음)
		int historysave_check = this.dao.getHistory_save(RepChannelCode);
		
		int check = 0;
		
		Map<String,Object>map = new HashMap<String,Object>();
		map.put("code", MemberCode); 
		
		if(historysave_check == 1) {
			map.put("save", 0);
			check = this.dao.dont_save_history(map);
		}else {
			 map.put("save", 1);
			 check = this.dao.dont_save_history(map);
		}
		
		if(check > 0) {
			out.println("<script>");
			out.println("location.href='history_list.do'");
			out.println("</script>");
		}else {
			out.println("<script>");
			out.println("alert('전체 시청기록 삭제 중 오류 발생')");
			out.println("history.back()");
			out.println("</script>");
		}
	}
	
	
	
}
