package com.vidividi.five.one;

import java.io.File;
import java.io.IOException;
import java.util.Calendar;
import java.util.Iterator;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

@Service
// 스프링에서 비지니스 로직을 수행할 때 붙이는 애노테이션
// 해당 Upload라는 클래스는 비지니스 로직을 수행하는 클래스
public class Upload {
	
	public String fileUpload(MultipartHttpServletRequest mRequest) {

		String saveFileName = "";
		String dateFolder = "";

		String uploadPath = "/var/lib/tomcat9/webapps/upload/";
		
		Calendar cal = Calendar.getInstance();
		
		int year = cal.get(Calendar.YEAR);
		int month = cal.get(Calendar.MONTH) + 1;
		int day = cal.get(Calendar.DAY_OF_MONTH);
		
		Iterator<String> iterator = mRequest.getFileNames();
		
		while(iterator.hasNext()) {
			String uploadFileName = iterator.next(); 
			MultipartFile mFile = mRequest.getFile(uploadFileName);
			
			String originalFileName = mFile.getOriginalFilename();
			
			// 실제 폴더를 만들어보자 
			// .... \\resources\\upload\\2022-11-25
			dateFolder = year + "-" + month + "-" + day;
			String homedir = uploadPath + dateFolder;
			
			
			File path1 = new File(homedir);
			
			if(!path1.exists()) {
				path1.mkdirs();
			}
			
			// 실제 파일 만들기
			saveFileName = originalFileName;
			
			if (!saveFileName.equals("")) {
				saveFileName = System.currentTimeMillis() + "_" +saveFileName;
			}
			
			try {

				File origin = new File(homedir+"/"+saveFileName);
				mFile.transferTo(origin);     // 파일 데이터를 지정한 폴더로 이동하는 메서드
				
				
			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			} 
			
		}
		
		return "upload/" + dateFolder + "/" + saveFileName;
	}

}
