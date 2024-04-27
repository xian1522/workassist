package com.joyin.ticm${packageName}.dao.impl;

import com.joyin.ticm.bean.ResultData;
import com.joyin.ticm.common.util.CommonUtil;
import com.joyin.ticm.dao.BaseDao;
import com.joyin.ticm.dao.DaoException;
import com.joyin.ticm.dao.impl.AbstractDao;
import com.joyin.ticm${packageName}.dao.${className}Dao;
import com.joyin.ticm${packageName}.model.${className};
import com.joyin.ticm.page.PageInfo;
import com.joyin.ticm.page.Pager;
import org.hibernate.HibernateException;
import org.hibernate.JDBCException;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;


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
	* @return ResultData
	* @throws DaoException  
	 */
	@Override
	public ResultData find${className}OfPage(${className} ${className?uncap_first}, Pager pager) throws DaoException {
		String methodName = "find${className}OfPage";
		info(methodName, "params: "+ ${className?uncap_first} +" - "+ pager);
        try {
            String hql = "from ${className} ${className?uncap_first} where ${className?uncap_first}.effectflag = 'E' ";
            String strWhere = "";
            List<Object> paramValues = new ArrayList<Object>();
            //机构号查询
            if (CommonUtil.isNotEmpty(${className?uncap_first}.getOrgid())) {
                strWhere += " and ${className?uncap_first}.orgid in ("+${className?uncap_first}.getOrgid()+")";
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
			error(methodName, "Error find ${className?uncap_first}List", ex);
			throw new DaoException(DaoException.ERROR_GENERIC_JDBC_EXCEPTION,
					ex);
		}
		catch (HibernateException ex) {
			error(methodName, "Error find ${className?uncap_first}List", ex);
			throw new DaoException(DaoException.ERROR_HIBERNATE, ex);
		}
	}
}
