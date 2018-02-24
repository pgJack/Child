package com.beta.crop.service.impl;

import java.util.List;

import org.apache.ibatis.session.RowBounds;
import org.springframework.beans.factory.annotation.Autowired;


import com.beta.crop.dao.BaseMapper;
import com.beta.crop.service.BaseService;

import tk.mybatis.mapper.common.Mapper;

public abstract class BaseServiceImpl<T> implements BaseService<T> {
	@Autowired
	protected BaseMapper<T> mapper;
	
	public Mapper<T> getMapper() {
		return mapper;
	}

	public int delete(T entity) {
		return mapper.delete(entity);
	}

	public int delectByExample(Object example){
		return mapper.deleteByExample(example);
	}

	public int deleteByPrimaryKey(Object key){
		return mapper.deleteByPrimaryKey(key);
	}
	
	public int insert(T record){
		return mapper.insert(record);
	}
	public int insertSelective(T record){
		return mapper.insertSelective(record);
	}
	public int insertList(List<T> records){
		return mapper.insertList(records);
	}
	
	public List<T> select(T record){
		return mapper.select(record);
	}
	public List<T> selectAll(){
		return mapper.selectAll();
	}
	public List<T> selectByExalple(Object example){
		return mapper.selectByExample(example);
	}
	public List<T> selectByExampleAndRowBounds(Object example,RowBounds rowBounds){
		return mapper.selectByExampleAndRowBounds(example, rowBounds);
	}
	

	public T selectByPrimaryKey(Object key){
		return mapper.selectByPrimaryKey(key);
	}
	public List<T> selectByRowBounds(T record,RowBounds rowBounds){
		return mapper.selectByRowBounds(record, rowBounds);
	}
	public int selectCount(T record){
		return mapper.selectCount(record);
	}
	public int selectCountByExample(Object example){
		return mapper.selectCountByExample(example);
	}
	public T selectOne(T record){
		return mapper.selectOne(record);
	}
	
	
	public int updateByExample(T record,Object example){
		return mapper.updateByExample(record, example);
	}
	public int updateByExampleSelective(T record,Object example){
		return mapper.updateByExampleSelective(record, example);
	}
	public int updateByPrimaryKey(T record){
		return mapper.updateByPrimaryKey(record);
	}
	

	public int updateByprimaryKeySelective(T record){
		return mapper.updateByPrimaryKeySelective(record);
		
		
	}
	
}
