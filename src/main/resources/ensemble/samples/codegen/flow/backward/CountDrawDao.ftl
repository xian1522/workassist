package com.joyin${packageName}.countdraw.dao;

import java.util.Date;
import java.util.List;

import com.joyin.ticm.bean.ResultData;
import com.joyin.ticm.dao.DaoException;
import com.joyin.ticm.page.Pager;
import com.joyin.ticm${packageName}.model.${className};
import com.joyin.ticm${packageName}.model.${subClassName};
import com.joyin.ticm${packageName}.deal.model.SlDeal;

/**
 * @Description: ${table.comment!}DAO
 */
public interface ${className}Dao {
	/**
	 * @Description: 查询机构最新计提汇总信息
	 * @param orgid 机构号
	 * @return ${className}  
	 * @throws DaoException  
	 */
	public ${className} findLast${className}(String orgid)
	throws DaoException;
	/**
	 * @Description: ${table.comment!}信息查询
	 * @param ${subClassName?uncap_first} ${table.comment!}明细
	 * @param pager 分页对象
	 * @return ResultData  
	 * @throws DaoException 
	 */
	public ResultData find${className}OfPage(${subClassName} ${subClassName?uncap_first}, Pager pager)throws DaoException;
	
	/**
	 * @Description: 删除计提试运行的汇总及明细
	 * @param orgid 机构号
	 * @throws DaoException  
	 */
	public void deleteCountDraw(String orgid) throws DaoException;
	/**
	* @Description: 查询待计提的交易
	* @param orgid 机构号
	* @param drawDate 计提日期
	* @return List<SlDeal> 交易list
	* @throws DaoException  
	 */
	public List<SlDeal> findSlDealForCountDraw(String orgid,Date drawDate) throws DaoException;
	/**
	* @Description: 查询最新的一条计提明细
	* @param orgid 机构编号
	* @param reqid 申请编号
	* @return ${subClassName} ${table.comment!}明细
	* @throws DaoException  
	 */
	public ${subClassName} findLast${subClassName}(String orgid,String reqid) throws DaoException;
	/**
	* @Description: 根据流水号查询计提明细
	* @param seqno 
	* @return ${subClassName}
	* @throws DaoException
	 */
	public ${subClassName} find${subClassName}ById(Long seqno)throws DaoException;
	/**
	* @Description: 根据机构查询最新的计提汇总信息
	* @param orgid 机构号
	* @return ${className} 计提汇总信息 
	* @throws DaoException
	 */
	public ${className} findCountDrawForCount(String orgid)throws DaoException;
	/**
	* @Description: 根据计提汇总id查询计提明细
	* @param seqid 计提汇总id
	* @param effectflag 有效状态
	* @return List<${subClassName}>  计提明细list
	* @throws DaoException  
	 */
	public List<${subClassName}>  find${subClassName}ForCount(Long seqid,String effectflag)throws DaoException;
}
