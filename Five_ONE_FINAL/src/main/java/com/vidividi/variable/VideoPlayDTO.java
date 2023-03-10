package com.vidividi.variable;

import java.util.Date;

import com.vidividi.service.FormatCnt;
import com.vidividi.service.Time;

public class VideoPlayDTO {

	private String video_code; // 비디오코드
	private String channel_code; // 채널코드
	private String channel_name; //
	private String video_title;
	private String video_cont;
	private String video_img;
	private String video_good;
	private int video_bad;
	private String video_view_cnt;
	private String video_hash;
	private String video_regdate;
	private int video_open;
	private String channel_like;
	private String video_age;
	private int category_code;
	
	private String channel_profil;
	private String playList_title; // 재생목록
	private String playList_code; // 재생목록
	
	private String bundle_code;
	private String bundle_title;
	
	public String getVideo_code() {
		return video_code;
	}
	public void setVideo_code(String video_code) {
		this.video_code = video_code;
	}
	public String getChannel_code() {
		return channel_code;
	}
	public void setChannel_code(String channel_code) {
		this.channel_code = channel_code;
	}
	public String getChannel_name() {
		return channel_name;
	}
	public void setChannel_name(String channel_name) {
		this.channel_name = channel_name;
	}
	public String getVideo_title() {
		return video_title;
	}
	public void setVideo_title(String video_title) {
		this.video_title = video_title;
	}
	public String getVideo_cont() {
		return video_cont;
	}
	public void setVideo_cont(String video_cont) {
		this.video_cont = video_cont;
	}
	public String getVideo_img() {
		return video_img;
	}
	public void setVideo_img(String video_img) {
		this.video_img = video_img;
	}
	public String getVideo_good() {
		return video_good;
	}
	public void setVideo_good(int video_good) {
		this.video_good = FormatCnt.format(video_good);
	}
	public int getVideo_bad() {
		return video_bad;
	}
	public void setVideo_bad(int video_bad) {
		this.video_bad = video_bad;
	}
	public String getVideo_view_cnt() {
		return video_view_cnt;
	}
	public void setVideo_view_cnt(int video_view_cnt) {
		this.video_view_cnt = FormatCnt.format(video_view_cnt);
	}
	public String getVideo_hash() {
		return video_hash;
	}
	public void setVideo_hash(String video_hash) {
		this.video_hash = video_hash;
	}
	public String getVideo_regdate() {
		return video_regdate;
	}
	public void setVideo_regdate(Date video_regdate) {
		this.video_regdate = Time.calculateTime(video_regdate);
	}
	public int getVideo_open() {
		return video_open;
	}
	public void setVideo_open(int video_open) {
		this.video_open = video_open;
	}
	public int getCategory_code() {
		return category_code;
	}
	public void setCategory_code(int category_code) {
		this.category_code = category_code;
	}
	public String getChannel_like() {
		return channel_like;
	}
	public void setChannel_like(int channel_like) {
		this.channel_like = FormatCnt.format(channel_like);
	}
	
	public String getPlayList_title() {
		return playList_title;
	}
	
	public void setPlayList_title(String playList_title) {
		this.playList_title = playList_title;
	}
	
	public String getPlayList_code() {
		return playList_code;
	}
	
	public void setPlayList_code(String playList_code) {
		this.playList_code = playList_code;
	}
	
	public String getVideo_age() {
		return video_age;
	}
	
	public void setVideo_age(String video_age) {
		this.video_age = video_age;
	}
	public String getChannel_profil() {
		return channel_profil;
	}
	public void setChannel_profil(String channel_profil) {
		this.channel_profil = channel_profil;
	}
	
	public String getBundle_code() {
		return bundle_code;
	}
	public void setBundle_code(String bundle_code) {
		this.bundle_code = bundle_code;
	}
	public String getBundle_title() {
		return bundle_title;
	}
	public void setBundle_title(String bundle_title) {
		this.bundle_title = bundle_title;
	}
	
	
}
