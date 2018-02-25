package com.beta.crop.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.beta.crop.service.testService;







@RestController
@RequestMapping("/test")
public class testCon {
	@Autowired
	private testService service;
	@RequestMapping("/testctrl")
	public String testctrl() {
		service.selectAll();
		return "success";
	}
}
