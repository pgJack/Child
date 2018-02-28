package com.beta.crop.dao;

import org.springframework.stereotype.Service;

import tk.mybatis.mapper.common.Mapper;
import tk.mybatis.mapper.common.MySqlMapper;
/**
 * 
 * @Date 2018年2月24日 
 * @author jiacanli
 * @version 1.0.0
 * @param <T>
 */

public interface BaseMapper<T> extends Mapper<T>, MySqlMapper<T> {

}
