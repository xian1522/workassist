package com.joyin.ticm${packageName}.dao.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.hibernate.HibernateException;
import org.hibernate.JDBCException;

import com.joyin.ticm.bean.ResultData;
import com.joyin.ticm.common.constant.Constant;
import com.joyin.ticm.common.constant.Constant.EffectFlag;
import com.joyin.ticm.common.util.CommonUtil;
import com.joyin.ticm.dao.BaseDao;
import com.joyin.ticm.dao.DaoException;
import com.joyin.ticm.dao.impl.AbstractDao;
import com.joyin.ticm.page.PageInfo;
import com.joyin.ticm.page.Pager;
import com.joyin.ticm${packageName}.dao.${className}Dao;
import com.joyin.ticm${packageName}.model.${className};
import com.joyin.ticm${packageName}.model.${subClassName};
import com.joyin.ticm.sl.deal.model.SlDeal;

public class ${className}DaoImpl extends AbstractDao implements ${className}Dao{
	@Resource
	private BaseDao baseDao;
	
	/**
	 * @Description: 查询机构最新计提汇总信息
	 * @param orgid 机构号
	 * @return ${className}  
	 * @throws DaoException  
	 */
	@Override
	public ${className} findLast${className}(String orgid) throws DaoException {
		String methodName = "findLast${className}";
		info(methodName, "param[orgid]"+orgid);
		StringBuffer hql = new StringBuffer();
		try {
			hql.append(" from ${className} draw where draw.effectflag = 'E' ");
			List<Object> params = new ArrayList<Object>();
			//拼装参数
			if (CommonUtil.isNotEmpty(orgid)) {
				hql.append(" and draw.orgid = ? ");
				params.add(orgid);
			}
			hql.append(" order by draw.drawdate desc");
			
			List<${className}> list = baseDao.findByParams(hql.toString(), params.toArray());
			
			if (CommonUtil.isEmpty(list)) {
				return null;
			}else{
				return list.get(0);
			}
		}
		catch (JDBCException ex) {
			error(methodName, "Error find IssuebCountDraw", ex);
			throw new DaoException(DaoException.ERROR_GENERIC_JDBC_EXCEPTION,
					ex);
		}
		catch (HibernateException ex) {
			error(methodName, "Error find IssuebCountDraw", ex);
			throw new DaoException(DaoException.ERROR_HIBERNATE, ex);
		}
	}
	/**
	 * @Description: ${table.comment!}信息查询
	 * @param ${subClassName?uncap_first} ${table.comment!}明细
	 * @param pager 分页对象
	 * @return ResultData  
	 * @throws DaoException 
	 */
	@Override
	public ResultData find${className}OfPage(
			${subClassName} ${subClassName?uncap_first}, Pager pager)
			throws DaoException {
		String methodName = "find${className}OfPage";
		info(methodName, "param[${subClassName?uncap_first}]: " + ${subClassName?uncap_first} + ", param[pager]: "
				+ pager);

		ResultData rstData = new ResultData();
		if (CommonUtil.isEmpty(${subClassName?uncap_first}) || CommonUtil.isEmpty(pager)) {
			error(methodName, "输入的参数为空!");
			rstData.setSuccess(false);
			return rstData;
		}

		try {
			String hql = "from ${subClassName} where 1 = 1";
			String strWhere = "";
			List<Object> paramValues = new ArrayList<Object>();

			// A:试运行数据查询、E:已计提数据查询
			if (CommonUtil.isNotEmpty(${subClassName?uncap_first}.getEffectflag())) {
				strWhere += " and effectflag = ?";
				paramValues.add(${subClassName?uncap_first}.getEffectflag());
			}
			// 机构号
			if (CommonUtil.isNotEmpty(${subClassName?uncap_first}.getOrgid())) {
				strWhere += " and orgid in ("+${subClassName?uncap_first}.getOrgid()+")";
			}
			if (CommonUtil.isNotEmpty(${subClassName?uncap_first}.getReqid())) {
				strWhere += " and reqid like ?";
				paramValues.add("%" + ${subClassName?uncap_first}.getReqid() + "%");
			}
			// 计提日期
			if (CommonUtil.isNotEmpty(${subClassName?uncap_first}.getDate1From())) {
				strWhere += " and drawdate >= ?";
				paramValues.add(${subClassName?uncap_first}.getDate1From());
			}
			if (CommonUtil.isNotEmpty(${subClassName?uncap_first}.getDate1To())) {
				strWhere += " and drawdate <= ?";
				paramValues.add(${subClassName?uncap_first}.getDate1To());
			}
			// 计提开始日
			if (CommonUtil.isNotEmpty(${subClassName?uncap_first}.getDate2From())) {
				strWhere += " and intstrtdte >= ?";
				paramValues.add(${subClassName?uncap_first}.getDate2From());
			}
			if (CommonUtil.isNotEmpty(${subClassName?uncap_first}.getDate2To())) {
				strWhere += " and intstrtdte <= ?";
				paramValues.add(${subClassName?uncap_first}.getDate2To());
			}
			// 计提截止日
			if (CommonUtil.isNotEmpty(${subClassName?uncap_first}.getDate3From())) {
				strWhere += " and intenddte >= ?";
				paramValues.add(${subClassName?uncap_first}.getDate3From());
			}
			if (CommonUtil.isNotEmpty(${subClassName?uncap_first}.getDate3To())) {
				strWhere += " and intenddte <= ?";
				paramValues.add(${subClassName?uncap_first}.getDate3To());
			}
			
			// 排序转换
			if (CommonUtil.isNotEmpty(pager)
					&& CommonUtil.isNotEmpty(pager.getDirection())) {
				String sort = pager.getSort();
				strWhere += " order by " + sort + " " + pager.getDirection();
			}
			hql = hql + strWhere;
			PageInfo pageInfo = baseDao.findByParamPageQuery(hql, paramValues,
					pager.getPageSize(), pager.getPageNo());
			
			if (CommonUtil.isNotEmpty(pageInfo.getPageData())) {
				rstData.setList(pageInfo.getPageData());
			}
			if (CommonUtil.isNotEmpty(pageInfo.getPager())) {
				rstData.setPager(pageInfo.getPager());
			}
			rstData.setSuccess(true);
			return rstData;
		}
		catch (JDBCException ex) {
			error(methodName, "Error find ${subClassName}", ex);
			throw new DaoException(DaoException.ERROR_GENERIC_JDBC_EXCEPTION,
					ex);
		}
		catch (HibernateException ex) {
			error(methodName, "Error find ${subClassName}", ex);
			throw new DaoException(DaoException.ERROR_HIBERNATE, ex);
		}
	}
	/**
	 * @Description: 删除计提试运行的汇总及明细
	 * @param orgid 机构号
	 * @throws DaoException  
	 */
	@Override
	public void deleteCountDraw(String orgid) throws DaoException {
		String methodName = "deleteCountDraw";
		info(methodName, "params[orgid]: " + orgid);

		try {
			// 删除参数列表
			Object[] paramValues = { EffectFlag.A, orgid };
			// 删除汇总
			String delCollect = "delete from ${className} where effectflag = ? and orgid = ?";
			baseDao.executeByHql(delCollect, paramValues);
			// 删除明细
			String delDetail = "delete from ${subClassName} where effectflag = ? and orgid = ?";

			baseDao.executeByHql(delDetail, paramValues);
		}
		catch (JDBCException ex) {
			error(methodName, "Error delete ${className} And ${subClassName}", ex);
			throw new DaoException(DaoException.ERROR_GENERIC_JDBC_EXCEPTION,
					ex);
		}
		catch (HibernateException ex) {
			error(methodName, "Error delete ${className} And ${subClassName}", ex);
			throw new DaoException(DaoException.ERROR_HIBERNATE, ex);
		}
		catch (DaoException e) {
			throw e;
		}
	}
	/**
	* @Description: 查询待计提的债券借贷交易
	* @param orgid 机构号
	* @param drawDate 计提日期
	* @return List<SlDeal> 债券借贷交易list
	* @throws DaoException  
	 */
	@Override
	public List<SlDeal> findSlDealForCountDraw(String orgid,
			Date drawDate) throws DaoException {
		String methodName = "findSlDealForCountDraw";
		info(methodName, "param[orgid]"+orgid+" param[drawDate]"+drawDate);
		StringBuffer hql = new StringBuffer();
		try {
			hql.append(" from SlDeal slDeal where slDeal.effectflag = '" + Constant.EffectFlag.E + "'");
			List<Object> params = new ArrayList<Object>();
			//拼装参数
			if (CommonUtil.isNotEmpty(orgid)) {
				hql.append(" and slDeal.orgid = ? ");
				params.add(orgid);
			}
			if (CommonUtil.isNotEmpty(drawDate)) {
				hql.append(" and slDeal.vdate <= ? ");
				params.add(drawDate);
				hql.append(" and slDeal.mdate >= ? ");
				params.add(drawDate);
			}

			hql.append(" and not exists (select 1 from SlDue due where due.effectflag ='E' and due.slDeal.reqid = slDeal.reqid) " +
					"order by slDeal.lstmntdate desc");
			
			List<SlDeal> list = baseDao.findByParams(hql.toString(), params.toArray());
			
			return list;
			
		}
		catch (JDBCException ex) {
			error(methodName, "Error find IssuebPositionList", ex);
			throw new DaoException(DaoException.ERROR_GENERIC_JDBC_EXCEPTION,
					ex);
		}
		catch (HibernateException ex) {
			error(methodName, "Error find IssuebPositionList", ex);
			throw new DaoException(DaoException.ERROR_HIBERNATE, ex);
		}
	}
	/**
	* @Description: 查询最新的一条计提明细
	* @param orgid 机构编号
	* @param reqid 申请编号
	* @return ${subClassName} ${table.comment!}明细
	* @throws DaoException  
	 */
	@Override
	public ${subClassName} findLast${subClassName}(String orgid,String reqid) throws DaoException{
		String methodName = "findLast${subClassName}";
		info(methodName, "param[orgid]" + orgid + " param[reqid]" + reqid);
		StringBuffer hql = new StringBuffer();
		try {
			hql.append(" from ${subClassName} drawDetail where drawDetail.effectflag = 'E' ");
			List<Object> params = new ArrayList<Object>();
			//拼装参数
			if (CommonUtil.isNotEmpty(orgid)) {
				hql.append(" and drawDetail.orgid = ? ");
				params.add(orgid);
			}
			if(CommonUtil.isNotEmpty(reqid)) {
				hql.append(" and drawDetail.reqid = ? ");
				params.add(reqid);
			}
			hql.append(" order by drawDetail.seqno desc");
			
			List<${subClassName}> list = baseDao.findByParams(hql.toString(), params.toArray());
			
			if (CommonUtil.isEmpty(list)) {
				return null;
			}else{
				return list.get(0);
			}
		}
		catch (JDBCException ex) {
			error(methodName, "Error find IssuebCountDraw", ex);
			throw new DaoException(DaoException.ERROR_GENERIC_JDBC_EXCEPTION,
					ex);
		}
		catch (HibernateException ex) {
			error(methodName, "Error find IssuebCountDraw", ex);
			throw new DaoException(DaoException.ERROR_HIBERNATE, ex);
		}
	}
	/**
	* @Description: 根据流水号查询计提明细
	* @param seqno 
	* @return ${subClassName}
	* @throws DaoException
	 */
	@Override
	public ${subClassName} find${subClassName}ById(Long seqno)
			throws DaoException {
		String methodName = "find${subClassName}ById";
		info(methodName, "param[seqno]"+seqno);
		try {
			${subClassName} ${subClassName?uncap_first} = baseDao.findById(${subClassName}.class, seqno);
			
			return ${subClassName?uncap_first};
		}
		catch (JDBCException ex) {
			error(methodName, "Error find ${subClassName}", ex);
			throw new DaoException(DaoException.ERROR_GENERIC_JDBC_EXCEPTION,
					ex);
		}
		catch (HibernateException ex) {
			error(methodName, "Error find ${subClassName}", ex);
			throw new DaoException(DaoException.ERROR_HIBERNATE, ex);
		}
	}
	/**
	* @Description: 根据机构查询最新的待计提汇总信息
	* @param orgid 机构号
	* @return ${className} 计提汇总信息 
	* @throws DaoException
	 */
	@Override
	public ${className} findCountDrawForCount(String orgid) throws DaoException {
		String methodName = "findCountDrawForCount";
		info(methodName, "param[orgid]"+orgid);
		StringBuffer hql = new StringBuffer();
		try {
			hql.append(" from ${className} draw where draw.effectflag = 'A' ");
			List<Object> params = new ArrayList<Object>();
			//拼装参数
			if (CommonUtil.isNotEmpty(orgid)) {
				hql.append(" and draw.orgid = ? ");
				params.add(orgid);
			}
			hql.append(" order by draw.drawdate desc");
			
			List<${className}> list = baseDao.findByParams(hql.toString(), params.toArray());
			
			if (CommonUtil.isNotEmpty(list)&&list.size()>0) {
				return list.get(0);
			}else{
				return null;
			}
			
		}
		catch (JDBCException ex) {
			error(methodName, "Error find ${className}", ex);
			throw new DaoException(DaoException.ERROR_GENERIC_JDBC_EXCEPTION,
					ex);
		}
		catch (HibernateException ex) {
			error(methodName, "Error find ${className}", ex);
			throw new DaoException(DaoException.ERROR_HIBERNATE, ex);
		}
	}
	/**
	* @Description: 根据计提汇总id查询计提明细
	* @param seqid 计提汇总id
	* @param effectflag 有效状态
	* @return List<${subClassName}> 计提明细list
	* @throws DaoException  
	 */
	@Override
	public List<${subClassName}> find${subClassName}ForCount(Long seqid,String effectflag)
			throws DaoException {
		String methodName = "find${subClassName}ForCount";
		info(methodName, "param[seqid]"+seqid);
		StringBuffer hql = new StringBuffer();
		try {
			hql.append(" from ${subClassName} draw where 1=1 ");
			List<Object> params = new ArrayList<Object>();
			//拼装参数
			if (CommonUtil.isNotEmpty(seqid)) {
				hql.append(" and draw.seqid = ? ");
				params.add(seqid);
			}
			//拼装参数
			if (CommonUtil.isNotEmpty(effectflag)) {
				hql.append(" and draw.effectflag = ? ");
				params.add(effectflag);
			}
			
			List<${subClassName}> list = baseDao.findByParams(hql.toString(), params.toArray());
			return list;
			
		}
		catch (JDBCException ex) {
			error(methodName, "Error find ${subClassName}", ex);
			throw new DaoException(DaoException.ERROR_GENERIC_JDBC_EXCEPTION,
					ex);
		}
		catch (HibernateException ex) {
			error(methodName, "Error find ${subClassName}", ex);
			throw new DaoException(DaoException.ERROR_HIBERNATE, ex);
		}
	}
	
}
