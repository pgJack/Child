package com.beta.crop.service;

import java.util.List;

import org.apache.ibatis.session.RowBounds;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

@Service
public interface BaseService<T> {
	
	public int delete(T entity);
	
	public int delectByExample(Object example);
	
	public int deleteByPrimaryKey(Object key);
	
	public int insert(T record);
	public int insertSelective(T record);
	public int insertList(List<T> records);
	
	public List<T> select(T record);
	public List<T> selectAll();
	public List<T> selectByExalple(Object example);
	public List<T> selectByExampleAndRowBounds(Object example,RowBounds rowBounds);
	
	
	public T selectByPrimaryKey(Object key);	
	public List<T> selectByRowBounds(T record,RowBounds rowBounds);
	public int selectCount(T record);
	public int selectCountByExample(Object example);
	public T selectOne(T record);
	
	
	public int updateByExample(T record,Object example);
	public int updateByExampleSelective(T record,Object example);
	public int updateByPrimaryKey(T record);
	
	public int updateByprimaryKeySelective(T record);
}
