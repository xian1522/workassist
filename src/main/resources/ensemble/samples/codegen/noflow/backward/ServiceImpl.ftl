package com.joyin.ticm${packageName}.service.impl;

import com.joyin.ticm.bean.ResultData;
import com.joyin.ticm.common.util.CommonUtil;
import com.joyin.ticm.dao.BaseDao;
import com.joyin.ticm.dao.DaoException;
import com.joyin.ticm${packageName}.dao.${className}Dao;
import com.joyin.ticm${packageName}.model.${className};
import com.joyin.ticm${packageName}.service.${className}Service;
import com.joyin.ticm.page.Pager;
import com.joyin.ticm.service.ServiceBase;
import com.joyin.ticm.service.ServiceException;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;


/**
 * ${table.comment!}表业务操作层实现类
 */
@Service("${className?uncap_first}Service")
public class ${className}ServiceImpl extends ServiceBase implements ${className}Service {
	@Resource
	private ${className}Dao ${className?uncap_first}Dao;
	@Resource
	private BaseDao baseDao;


	/**
	 * 查询${table.comment!}表信息
	 * @param ${className?uncap_first}
	 * @param pager
	 * @return ResultData
	 * @throws ServiceException
	 */
	@Override
	public ResultData find${className}OfPage(${className} ${className?uncap_first}, Pager pager) throws ServiceException {
		String methodName = "find${className}OfPage ";
		info(methodName, "查询${table.comment!}表信息" + ",params[${className?uncap_first}]=" + ${className?uncap_first} + ",[pager]="
				+ pager);
		ResultData rs = new ResultData();
		if (CommonUtil.isEmpty(pager)) {
			rs.setSuccess(false);
			rs.setResultMessage("分页参数错误");
			return rs;
		}
		if (CommonUtil.isEmpty(${className?uncap_first})) {
			rs.setSuccess(false);
			rs.setResultMessage("查询参数错误");
			return rs;
		}
		try {
			rs = ${className?uncap_first}Dao.find${className}OfPage(${className?uncap_first}, pager);
		}
		catch (DaoException e) {
			throw processException(methodName, e.getMessage(), e);
		}
		return rs;
	}

	/**
	 * 根据流水号查询${table.comment!}数据
	 * @param ${pkname?lower_case} 主键
	 * @return ${className} ${table.comment!}
	 * @throws ServiceException
	 */
	@Override
	public ${className} findById(Long ${pkname?lower_case}) throws ServiceException {
		String methodName = "findById";
		info(methodName, "param[${pkname?lower_case}]: " + ${pkname?lower_case});

		try {
			${className} ${className?uncap_first} = baseDao.findById(${className}.class, ${pkname?lower_case});
			return ${className?uncap_first};
		}
		catch (DaoException ex) {
			String message = "查询${table.comment!}表错误";
			throw processException(methodName, message, ex);
		}
	}

	/**
	 * 删除${table.comment!}表
	 * @param ${className?uncap_first}List
	 *            ${table.comment!}表list
	 * @return ResultData
	 * @throws ServiceException
	 */
	@Override
	public ResultData delete${className}(List<${className}> ${className?uncap_first}List)
			throws ServiceException {
		String methodName = "delete${className}";
		info(methodName, "param[${className?uncap_first}List]: " + ${className?uncap_first}List);

		// 定义返回信息
		ResultData rtData = new ResultData();

		if (null == ${className?uncap_first}List) {
			rtData.setSuccess(false);
			rtData.setResultMessage("参数为空");
			return rtData;
		}
		try {
			for (${className} ${className?uncap_first} : ${className?uncap_first}List) {
				baseDao.saveOrUpdate(${className?uncap_first});
				rtData.setSuccess(true);
			}
		}
		catch (DaoException ex) {
			throw processException(methodName, "删除${table.comment!}表错误", ex);
		}

		return rtData;
	}

	@Override
	public void saveOrUpdate(${className} ${className?uncap_first}) throws ServiceException {
		String methodName = "saveOrUpdate";
		try {
			baseDao.saveOrUpdate(${className?uncap_first});
		} catch (DaoException ex) {
			throw processException(methodName, ex.getMessage(), ex);
		}
	}

	@Override
	public List<${className}> find${className}(${className} ${className?uncap_first}) throws ServiceException {
		String methodName = "find${className}";
		info(methodName, "param[${className?uncap_first}]=" + ${className?uncap_first});

		String hql = "from ${className} where effectflag = 'E' ";

		List<Object> params = new ArrayList<Object>();

		if(CommonUtil.isNotEmpty(${className?uncap_first}.getOrgid())) {
			hql += " and orgid = ?";
			params.add(${className?uncap_first}.getOrgid());
		}

		if(CommonUtil.isNotEmpty(${className?uncap_first}.get${pkname?lower_case?cap_first}())) {
			hql += " and ${pkname?lower_case} != ?";
			params.add(${className?uncap_first}.get${pkname?lower_case?cap_first}());
		}
		try {
			List<${className}> ${className?uncap_first}s = baseDao.findByParams(hql, params.toArray());
			return ${className?uncap_first}s;
		} catch (DaoException e) {
			String msg = "查询${table.comment!}信息错误";
			throw processException(methodName, msg, e);
		}
	}
}
