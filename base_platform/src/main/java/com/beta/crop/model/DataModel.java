package com.beta.crop.model;


import java.io.Serializable;

public class DataModel<T> implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = -2040381030054754869L;
	private String code;
	private String message;
	private T data;

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public T getData() {
		return data;
	}

	public void setData(T data) {
		this.data = data;
	}

	public DataModel(String code, String message, T data) {
		super();
		this.code = code;
		this.message = message;
		this.data = data;
	}

	public DataModel() {
		super();
	}

	public DataModel(String code, String message) {
		super();
		this.code = code;
		this.message = message;
	}
	
}
