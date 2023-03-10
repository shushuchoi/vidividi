package com.vidividi.five.one;

import java.io.File;
import java.io.IOException;
import java.util.Calendar;
import java.util.Iterator;

import javax.security.auth.message.callback.PrivateKeyCallback.Request;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.PageContext;

import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

// 스프링에서 비지니스 로직을 수행할 때 붙이는 애노테이션
// 해당 Upload라는 클래스는 비지니스 로직을 수행하는 클래스
@Service
public class UploadFile {
	public String dynamicPath_r() {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		request.getContextPath();
		return request.getServletContext().getRealPath("resources");
	}
	
	
	public boolean fileUpload(MultipartHttpServletRequest mRequest, String lastChannelCode, String title) {
		boolean isUpload = false;
		
		// 채널 코드 또는 채널 이름, 영상 제목 
		String saveFileName = "";
		String dateFolder = "";

		//String uploadVideoPath = "C:/final/GitHub/Five_ONE_Final/Five_ONE_FINAL/src/main/webapp/resources/AllChannel/" + lastChannelCode + "/";
		//String uploadVideoPath = "F:/GitHub/workspace(Spring)/Five_ONE_Final/Five_ONE_FINAL/src/main/webapp/resources/AllChannel/"; // 집 PC
		//String uploadVideoPath = dynamicPath_r() + "/AllChannel/";
		
		String uploadVideoPath = "/Users/maclee/Public/Spring/Github/Five_ONE_Final/Five_ONE_FINAL/src/main/webapp/resources/AllChannel/";
		//thumbnail
		Iterator<String> iterator = mRequest.getFileNames();
		
		System.out.println("uploadVideoPath: " + uploadVideoPath);
		
		// 들어오기 전부터 뭔가를 해야할듯...
		String extMovieArr[] = { "mp4" };
		String extImgArr[] = { "png" };
		
		while(iterator.hasNext()) {
			
			String uploadFileName = iterator.next(); 
			MultipartFile mFile = mRequest.getFile(uploadFileName);
			
			String originalFileName = mFile.getOriginalFilename(); // 파일 이름 저장
			
			
			System.out.println("파일이름: " + originalFileName);
			String ext = originalFileName.substring(originalFileName.lastIndexOf(".") + 1);
			System.out.println("ext: " + ext);
			
			// 영상 확장자 찾기
			for(int i=0; i<extMovieArr.length; i++) {
				if(ext.equals(extMovieArr[i]) ) {
					dateFolder = uploadVideoPath + lastChannelCode;
					File path1 = new File(dateFolder); // 폴더 경로
					
					if(!path1.exists()) {
						path1.mkdirs();
					}
					
					// 실제 저장되는 파일 이름
					saveFileName = originalFileName;
					if (!saveFileName.equals("")) {
						//saveFileName = System.currentTimeMillis() + "_" +saveFileName;
						saveFileName = title;
					}
					// 파일 저장 및 예외처리
					try {
						// 파일 저장
						File origin = new File(dateFolder+"/"+saveFileName + ".mp4");
						mFile.transferTo(origin);     // 파일 데이터를 지정한 폴더로 이동하는 메서드
						
						isUpload = true;
					} catch (IllegalStateException e) {
						e.printStackTrace();
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			}
			
			// 이미지 확장자 찾기
			for(int i=0; i<extImgArr.length; i++) {
				if(ext.equals(extImgArr[i])) {
					// 실제 폴더를 만들어보자 
					// .... \\resources\\upload\\2022-11-25
					dateFolder = uploadVideoPath + lastChannelCode + "/thumbnail";
					File path1 = new File(dateFolder); // 폴더 경로
					
					if(!path1.exists()) {
						path1.mkdirs();
					}
					
					// 실제 저장되는 파일 이름
					saveFileName = originalFileName;
					if (!saveFileName.equals("")) {
						//saveFileName = System.currentTimeMillis() + "_" +saveFileName;
						saveFileName = title;
					}
					// 파일 저장 및 예외처리
					try {
						// 파일 저장
						File origin = new File(dateFolder+"/"+saveFileName + ".png");
						mFile.transferTo(origin);     // 파일 데이터를 지정한 폴더로 이동하는 메서드
						
						isUpload = true;
					} catch (IllegalStateException e) {
						e.printStackTrace();
					} catch (IOException e) {
						e.printStackTrace();
					} 
				}
			}
		}
		
		return isUpload;
	}
	
	
	// 파일이 변경될때 사용하는 메소드
	public boolean fileChangeUpload(MultipartHttpServletRequest mRequest, String sendPosition, String channelCode) {
		boolean isUpload = false;
		
		String uploadVideoPath = "/Users/maclee/Public/Spring/Github/Five_ONE_Final/Five_ONE_FINAL/src/main/webapp/resources/AllChannel/"; // MACBOOK
		
		// 채널 코드 또는 채널 이름, 영상 제목 
		String saveFileName = "";
		String dateFolder = "";
		
		
		
		
					
		if(sendPosition.equals("profilChange")) { // 프로필 업로드
			//thumbnail
			Iterator<String> iterator = mRequest.getFileNames();
			
			
			// 들어오기 전부터 뭔가를 해야할듯...
			String extImgArr[] = { "png" };
			
			while(iterator.hasNext()) {
				
				String uploadFileName = iterator.next(); 
				MultipartFile mFile = mRequest.getFile(uploadFileName);
				
				String originalFileName = mFile.getOriginalFilename(); // 파일 이름 저장
				
				
				System.out.println("파일이름: " + originalFileName);
				
				dateFolder = uploadVideoPath + channelCode;
				File path1 = new File(dateFolder); // 폴더 경로
				
				if(!path1.exists()) {
					path1.mkdirs();
				}
				
				// 실제 저장되는 파일 이름
				saveFileName = originalFileName;
				if (!saveFileName.equals("")) {
					saveFileName = channelCode+"-profil";
				}
				// 파일 저장 및 예외처리
				try {
					// 파일 저장
					File origin = new File(dateFolder+"/"+saveFileName + ".png");
					mFile.transferTo(origin);     // 파일 데이터를 지정한 폴더로 이동하는 메서드
					
					isUpload = true;
				} catch (IllegalStateException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
			} //while
		} else if(sendPosition.equals(sendPosition)){ //다른 파일 업로드
			
			uploadVideoPath = "/Users/maclee/Public/Spring/Github/Five_ONE_Final/Five_ONE_FINAL/src/main/webapp/resources/AllChannel/";
			
			Iterator<String> iterator = mRequest.getFileNames();
			String extMovieArr[] = {"mp4" };
			String extImgArr[] = {"png"};
			
			while(iterator.hasNext()) {
				String uploadFileName = iterator.next();
				MultipartFile mFile = mRequest.getFile(uploadFileName);
				String originalFileName = mFile.getOriginalFilename();
				
				dateFolder = uploadVideoPath + channelCode;
				File path1 = new File(dateFolder);
				
				File pathCheck = new File(dateFolder + "/" + originalFileName);
			}
			
		}
		return isUpload;
	} // fileUpload
}
