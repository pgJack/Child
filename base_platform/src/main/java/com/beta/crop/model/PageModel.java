package com.beta.crop.model;

import java.io.Serializable;
import java.util.List;

/**
 * <p>Description: 分页用工具类</p>
 * <p>Company: GDKJ</p>
 * @author xudonglei
 * @version 1.0.0
 * <p>2016年10月24日  上午11:56:15</p>
 */
public class PageModel<T> implements Serializable {

	private static final long serialVersionUID = 6136331780491176626L;

	private int total;
	
	private List<T> rows;

	public int getTotal() {
		return total;
	}

	public void setTotal(int total) {
		this.total = total;
	}

	public List<T> getRows() {
		return rows;
	}

	public void setRows(List<T> rows) {
		this.rows = rows;
	}

}
