package com.beta.crop.util;

import com.beta.crop.model.DataModel;

/**
 * @Description controller 返回统一结构结果工具类
 * @Date 2017年3月17日 下午7:08:38
 * @author cll
 * @version 1.0.0
 */
public class ResultMapUtils {

	public static final String SUCCESS_CODE = "200";
	public static final String SUCCESS_MSG = "success";

	public static final String GET_ERROR_KEY = "-0001";
	public static final String GET_ERROR_VALUE = "获取信息失败";
	public static final String UPDATE_ERROR_KEY = "-0002";
	public static final String UPDATE_ERROR_VALUE = "更新数据失败";
	public static final String DELETE_ERROR_KEY = "-0003";
	public static final String DELETE_ERROR_VALUE = "删除数据失败";
	public static final String INSERT_ERROR_KEY = "-0004";
	public static final String INSERT_ERROR_VALUE = "新增数据失败";
	

	/**
	 * 方法执行成功调用的返回值方法
	 * @param result
	 * @return
	 */
	public static DataModel<Object> getResultMap(){
		DataModel<Object> dm = new DataModel<Object>();
		dm.setCode(SUCCESS_CODE);
		dm.setMessage(SUCCESS_MSG);
		return dm;
	}
	/**
	 * 方法执行成功调用的返回值方法
	 * @param result
	 * @return
	 */
	public static DataModel<Object> getResultMap(Object result){
		DataModel<Object> dm = new DataModel<Object>();
		dm.setCode(SUCCESS_CODE);
		dm.setMessage(SUCCESS_MSG);
		dm.setData(result);
		return dm;
	}
	
	/**
	 * 方法有误时调用的返回值方法
	 * @param errorCode    错误码
	 * @param errorMsg     错误信息
	 * @return
	 */
	public static DataModel<Object> getFailResultMap(String errorCode,String errorMsg){
		DataModel<Object> dm = new DataModel<Object>();
		dm.setCode(errorCode);
		dm.setMessage(errorMsg);
		return dm;
	}
	
	/**
	 * 
	 * @Description 重载
	 * @param result
	 * @param code
	 * @param msg
	 * @return
	 */
	public static DataModel<Object> getResultMap(Object result, String code,String msg){
		DataModel<Object> dm = new DataModel<Object>();
		dm.setData(result);
		dm.setCode(code);
		dm.setMessage(msg);
		return dm;
	}
	
	public static DataModel<Object> failGetting(){
		DataModel<Object> dm = new DataModel<Object>();
		dm.setCode(GET_ERROR_KEY);
		dm.setMessage(GET_ERROR_VALUE);
		return dm;
	}
	
	public static DataModel<Object> failInserting(){
		DataModel<Object> dm = new DataModel<Object>();
		dm.setCode(INSERT_ERROR_KEY);
		dm.setMessage(INSERT_ERROR_VALUE);
		return dm;
	}
	
	public static DataModel<Object> failUpdating(){
		DataModel<Object> dm = new DataModel<Object>();
		dm.setCode(UPDATE_ERROR_KEY);
		dm.setMessage(UPDATE_ERROR_VALUE);
		return dm;
	}
	
	public static DataModel<Object> failDeleting(){
		DataModel<Object> dm = new DataModel<Object>();
		dm.setCode(DELETE_ERROR_KEY);
		dm.setMessage(DELETE_ERROR_VALUE);
		return dm;
	}
}
