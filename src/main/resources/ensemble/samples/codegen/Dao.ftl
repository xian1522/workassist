package com.joyin.ticm${packageName}.dao;

import java.util.List;

import com.joyin.ticm.bean.ResultData;
import com.joyin.ticm.dao.DaoException;
import com.joyin.ticm.page.Pager;
import com.joyin.ticm${packageName}.model.${className};


/**
 * ${table.comment!}数据库操作层接口
 */
public interface ${className}Dao {

	/**
	* 查询${table.comment!}
	* @param ${className?uncap_first} 查询条件
	* @param pager 分布信息
	* @param optype 操作类型
	* @param ${className?uncap_first}Reqids 办理数据编号
	* @return ResultData
	* @throws DaoException  
	 */
	public ResultData find${className}OfPage(${className} ${className?uncap_first}, Pager pager,
			String optype, List<String> ${className?uncap_first}Seqids) throws DaoException;
}
