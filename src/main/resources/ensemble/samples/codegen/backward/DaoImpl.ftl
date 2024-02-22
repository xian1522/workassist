package com.joyin.ticm${packageName}.dao.impl;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.hibernate.HibernateException;
import org.hibernate.JDBCException;

import com.joyin.ticm.bean.ResultData;
import com.joyin.ticm.common.constant.Constant;
import com.joyin.ticm.common.util.CommonUtil;
import com.joyin.ticm.dao.BaseDao;
import com.joyin.ticm.dao.DaoException;
import com.joyin.ticm.dao.impl.AbstractDao;
import com.joyin.ticm.page.PageInfo;
import com.joyin.ticm.page.Pager;
import com.joyin.ticm${packageName}.dao.${className}Dao;
import com.joyin.ticm${packageName}.model.${className};


/**
 * ${table.comment!}数据库操作层实现 
 */
public class ${className}DaoImpl extends AbstractDao implements ${className}Dao {
	
	@Resource
	private BaseDao baseDao;
	
	/**
	* 查询${table.comment!}
	* @param ${className?uncap_first} 查询条件
	* @param pager 分布信息
	* @param optype 操作类型
	* @param ${className?uncap_first}Reqids 办理数据编号
	* @return ResultData
	* @throws DaoException  
	 */
	@Override
	public ResultData find${className}OfPage(${className} ${className?uncap_first}, Pager pager, String optype,
			List<String> ${className?uncap_first}Reqids) throws DaoException {
		String methodName = "find${className}OfPage";
		info(methodName, "params: "+ ${className?uncap_first} +" - "+ pager + " - " +optype+ " - "+${className?uncap_first}Reqids);
        try {
            String hql = "from ${className} ${className?uncap_first} where 1 = 1 ";
            String strWhere = "";
            List<Object> paramValues = new ArrayList<Object>();
            //机构号查询
            if (CommonUtil.isNotEmpty(${className?uncap_first}.getOrgid())) {
                strWhere += " and ${className?uncap_first}.slDeal.orgid in ("+${className?uncap_first}.getOrgid()+")";
            }
            //有效性查询
            if (!Constant.EffectFlag.ALL.equals(${className?uncap_first}.getEffectflag())) {
                if (CommonUtil.isNotEmpty(${className?uncap_first}.getEffectflag())) {
                    strWhere += " and ${className?uncap_first}.effectflag = ? ";
                    paramValues.add(${className?uncap_first}.getEffectflag());
                }
            }
            //查询需要办理的数据
            if (Constant.OptionType.DEAL.equals(optype)) {
                hql+=" AND ${className?uncap_first}.seqid IN (" + CommonUtil.listToSqlStr(${className?uncap_first}Reqids)
                        + ")";
            }
            
            if (CommonUtil.isNotEmpty(pager.getSort())
                    && CommonUtil.isNotEmpty(pager.getDirection())) {

                strWhere += " order by ${className?uncap_first}." + pager.getSort() + " "
                        + pager.getDirection();
            }

            hql = hql + strWhere;

            PageInfo pageInfo = baseDao.findByParamPageQuery(hql, paramValues,
                    pager.getPageSize(), pager.getPageNo());

            ResultData rstData = new ResultData();
            if (CommonUtil.isNotEmpty(pageInfo)) {
                if (CommonUtil.isNotEmpty(pageInfo.getPageData())) {
                    rstData.setList(pageInfo.getPageData());
                }
                if (CommonUtil.isNotEmpty(pageInfo.getPager())) {
                    rstData.setPager(pageInfo.getPager());
                }
            }
            return rstData;
        }
        catch (JDBCException ex) {
			error(methodName, "Error find ississuebDealList", ex);
			throw new DaoException(DaoException.ERROR_GENERIC_JDBC_EXCEPTION,
					ex);
		}
		catch (HibernateException ex) {
			error(methodName, "Error find ississuebDealList", ex);
			throw new DaoException(DaoException.ERROR_HIBERNATE, ex);
		}
	}
}
