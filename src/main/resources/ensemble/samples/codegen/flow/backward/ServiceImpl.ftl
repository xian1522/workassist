package com.joyin.ticm${packageName}.service.impl;

import java.util.ArrayList;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
<#if isKeepAccount == "是">
import com.joyin.ticm.accmn.kaconfig.service.KaConfigService;
import com.joyin.ticm.accmn.kamn.kacomm.KaConstant;
import com.joyin.ticm.accmn.kamn.model.SysKeepAccount;
import com.joyin.ticm.accmn.kamn.service.KeepAccountService;
import com.joyin.ticm.ka${packageName?substring(0, packageName?last_index_of("."))}.${className}KeepAccount;
</#if>
import com.joyin.ticm.common.util.CommonUtil;
import com.joyin.ticm.bean.ResultData;
import com.joyin.ticm.common.constant.Constant;
import com.joyin.ticm.common.constant.Constant.FlowStateType;
import com.joyin.ticm.dao.BaseDao;
import com.joyin.ticm.dao.DaoException;
import com.joyin.ticm.page.Pager;
import com.joyin.ticm.service.ServiceBase;
import com.joyin.ticm.service.ServiceException;
import com.joyin.ticm${packageName}.dao.${className}Dao;
import com.joyin.ticm${packageName}.model.${className};
import com.joyin.ticm${packageName}.service.${className}Service;
import com.joyin.ticm.sysmn.user.model.UserInfo;
<#if isNewFlow == "是">
import com.joyintech.jupiter.workflow.commons.WorkFlowInput;
import com.joyintech.jupiter.workflow.entity.FlowProcess;
import com.joyin.ticm.common.util.ConvertUtils;
<#else>
import com.joyin.ticm.workflow.service.FlowProcessService;
</#if>
<#if subTable??>
import com.joyin.ticm${packageName}.model.${subClassName};
import java.util.HashMap;
import java.util.Map;
</#if>


/**
 * ${table.comment!}业务操作层实现类
 */
@Service("${className?uncap_first}Service")
public class ${className}ServiceImpl extends ServiceBase implements ${className}Service {
	@Resource
	private ${className}Dao ${className?uncap_first}Dao;
<#if isNewFlow == "是">
<#else>
	@Resource
	private FlowProcessService flowProcessService;
</#if>
	@Resource
	private BaseDao baseDao;
<#if isKeepAccount == "是">
	@Resource
	private KaConfigService kaConfigService;
	@Resource
	private KeepAccountService keepAccountService;
</#if>

	/**
	 * 保存${table.comment!}
	 * @param ${className?uncap_first}
	 *            ${table.comment!}
	 * @param isSubmit
	 *            是否提交
	 * @return ResultData
	 * @throws ServiceException
	 */
	@Override
	public ResultData saveAndSubmit(${className} ${className?uncap_first}, boolean isSubmit)
			throws ServiceException {
		String methodName = "saveAndSubmit";
		info(methodName, "param[${className?uncap_first}]: " + ${className?uncap_first} + " param[isSubmit]: "
				+ isSubmit);

		ResultData rst = new ResultData();

		String ${pkname?lower_case} = this.getBusinessId(Constant.BusinessIdType.${table.tableName},
				${className?uncap_first}.getOrgid());
		${className?uncap_first}.set${pkname?lower_case?cap_first}(${pkname?lower_case});

		${className?uncap_first}.setLinkid(${className?uncap_first}.get${pkname?lower_case?cap_first}());

	<#if isNewFlow == "是">
		WorkFlowInput workFlowInput = new WorkFlowInput(${className?uncap_first}.getLoginUserid(),${className?uncap_first}.getOwnedModuleid(), ${className?uncap_first}.get${pkname?lower_case?cap_first}(),
		${className?uncap_first}.getLoginOrgid(), ConvertUtils.beanToMap(${className?uncap_first}));
		// 设置：审批意见
		if (CommonUtil.isNotEmpty(${className?uncap_first}.getFlowRemark())) {
			workFlowInput.setDealmesg(${className?uncap_first}.getFlowRemark());
		}
	</#if>

		// 流程返回结果
		ResultData rstFlow = new ResultData();
		// 保存数据
		try {
			if (isSubmit) {
				// 新建并提交流程
<#if isNewFlow == "是">
				taskFlowControlService.submit(workFlowInput);
<#else>
				rstFlow = flowProcessService.startProcessTask(
						Constant.FlowKey.SLDUEFLOW, null, ${className?uncap_first});
				if (rstFlow.isSuccess() == false) {
					return rstFlow;
				}
</#if>
			}else {
				// 新建流程
<#if isNewFlow == "是">
				taskFlowControlService.save(workFlowInput);
<#else>
				rstFlow = flowProcessService.startByKey(
						Constant.FlowKey.SLDUEFLOW, null, ${className?uncap_first});
				if (rstFlow.isSuccess() == false) {
					return rstFlow;
				}
</#if>
			}
			baseDao.saveOrUpdate(${className?uncap_first});

<#if subTable??>
			delete${subClassName}By${pkname?lower_case?cap_first}(${className?uncap_first}.get${pkname?lower_case?cap_first}());
			for (${subClassName} ${subClassName?uncap_first} : ${className?uncap_first}.get${subClassName}List()) {
				${subClassName?uncap_first}.set${pkname?lower_case?cap_first}(${className?uncap_first}.get${pkname?lower_case?cap_first}());
				baseDao.save(${subClassName?uncap_first});
			}
</#if>
<#if isNewFlow == "是">
			rst.setLinkid(${className?uncap_first}.get${pkname?lower_case?cap_first}());
</#if>
			
			rst.setSuccess(true);
			rst.setObject(${className?uncap_first});
		}
		catch (DaoException ex) {
			String msg = "保存${table.comment!}错误";
			throw processException(methodName, msg, ex);
		}
		catch (ServiceException ex) {
			throw processException(methodName, ex.getMessage(), ex);
		}
<#if isNewFlow == "是">
		catch (Exception ex) {
			throw processException(methodName, ex.getMessage(), ex);
		}
</#if>
		return rst;
	}
	

	/**
	 * 更新${table.comment!}
	 * @param ${className?uncap_first}
	 *            ${table.comment!}
	 * @param isSubmit
	 *            是否提交
	 * @return ResultData
	 * @throws ServiceException
	 */
	public ResultData updateAndSubmit(${className} ${className?uncap_first}, boolean isSubmit)
			throws ServiceException {
		String methodName = "updateAndSubmit";
		info(methodName, "param[${className?uncap_first}]: " + ${className?uncap_first} + " param[isSubmit]: "
				+ isSubmit);

		ResultData rst = new ResultData();
		// 流程返回结果
		ResultData rstFlow = new ResultData();
		// 更新数据
		try {
<#if isNewFlow == "是">
			WorkFlowInput workFlowInput = new WorkFlowInput(${className?uncap_first}.getLoginUserid(),${className?uncap_first}.getOwnedModuleid(),
				${className?uncap_first}.get${pkname?lower_case?cap_first}(), ${className?uncap_first}.getNextNodeId());
			// 设置办理主体
			if (CommonUtil.isNotEmpty(${className?uncap_first}.getDealSubjects())) {
				workFlowInput.setDealSubjects(${className?uncap_first}.getDealSubjects());
			}
			// 设置：审批意见
			if (CommonUtil.isNotEmpty(${className?uncap_first}.getFlowRemark())) {
				workFlowInput.setDealmesg(${className?uncap_first}.getFlowRemark());
			}
			// 设置：场景参数
			workFlowInput.putVariables("$" + ${className?uncap_first}.getOwnedModuleid(),
			ConvertUtils.beanToMap(${className?uncap_first}));

			FlowProcess flowProcess = null;
</#if>
			if (isSubmit) {
				// 提交流程
<#if isNewFlow == "是">
			flowProcess = taskFlowControlService.agree(workFlowInput);
<#else>
				rstFlow = flowProcessService.complateTask(null, ${className?uncap_first});
</#if>

			}else {
<#if isNewFlow == "是">
			flowProcess	= taskFlowControlService.save(workFlowInput);
<#else>
				// 更新流程名称
				rstFlow = flowProcessService.updateFlowStateName(${className?uncap_first});
</#if>
			}
			// 流程执行后状态
			int flowRstStatus = FlowStateType.NOT_OVER;
			if (null != rstFlow
					&& CommonUtil.isNotEmpty(rstFlow.getResultStatus())) {
				flowRstStatus = rstFlow.getResultStatus();
			}
			// 流程结束
<#if isNewFlow == "是">
			if (flowProcess.over()) {
<#else>
			if (flowRstStatus == FlowStateType.FLOW_OVER) {
</#if>
				${className?uncap_first}.setEffectflag(Constant.EffectFlag.E);
<#if isSafeFlow == "是">
			if(CommonUtil.isNotEmpty(${className?uncap_first}.getSrcid()) {
				${className} old${className?uncap_first} = this.findById(${className?uncap_first}.getSrcid());
				old${className?uncap_first}.setEffectflag(Constant.EffectFlag.D);
			}
</#if>
<#if isKeepAccount == "是">
				// 记账
				rst = keepAccount(${className?uncap_first}, KaConstant.VIEW.NOT_VIEW);
</#if>
				rst.setTaskOrder(FlowStateType.FLOW_OVER);
			}
			// 更新业务信息
			baseDao.saveOrUpdate(${className?uncap_first});
<#if subTable??>
			delete${subClassName}By${pkname?lower_case?cap_first}(${className?uncap_first}.get${pkname?lower_case?cap_first}());
			for (${subClassName} ${subClassName?uncap_first} : ${className?uncap_first}.get${subClassName}List()) {
				${subClassName?uncap_first}.set${pkname?lower_case?cap_first}(${className?uncap_first}.get${pkname?lower_case?cap_first}());
				baseDao.save(${subClassName?uncap_first});
			}
</#if>
<#if isNewFlow == "是">
			rst.setLinkid(${className?uncap_first}.get${pkname?lower_case?cap_first}());
</#if>
			rst.setSuccess(true);
		}
		catch (DaoException ex) {
			String msg = "更新并提交${table.comment!}错误.";
			throw processException(methodName, msg, ex);
		}
		catch (ServiceException ex) {
			throw processException(methodName, ex.getMessage(), ex);
		}
		catch (Exception e) {
			throw processException(methodName, e.getMessage(), e);
		}

		return rst;
	}

	/**
	 * 查询${table.comment!}信息
	 * @param ${className?uncap_first}
	 * @param pager
	 *            分页信息
	 * @param optype
	 *            操作类型
	 * @param ${className?uncap_first}Reqids
	 *            办理数据编号
	 * @return ResultData
	 * @throws ServiceException
	 */
	@Override
	public ResultData find${className}OfPage(${className} ${className?uncap_first}, Pager pager, String optype,
			List<String> ${className?uncap_first}Reqids) throws ServiceException {
		String methodName = "find${className}OfPage ";
		info(methodName, "查询${table.comment!}信息" + ",params[${className?uncap_first}]=" + ${className?uncap_first} + ",[pager]="
				+ pager + ",[optype]=" + optype + ",[${className?uncap_first}Reqids]="
				+ ${className?uncap_first}Reqids);
		ResultData rs = new ResultData();
		if (CommonUtil.isEmpty(pager)) {
			rs.setSuccess(false);
			rs.setResultMessage("分页参数错误");
			return rs;
		}
		if (CommonUtil.isEmpty(${className?uncap_first}) || CommonUtil.isEmpty(optype)) {
			rs.setSuccess(false);
			rs.setResultMessage("查询参数错误");
			return rs;
		}
		try {
			rs = ${className?uncap_first}Dao.find${className}OfPage(${className?uncap_first}, pager, optype, ${className?uncap_first}Reqids);
		}
		catch (DaoException e) {
			throw processException(methodName, e.getMessage(), e);
		}
		return rs;
	}

	/**
	 * 根据流水号查询${className}数据
	 * @param ${pkname?lower_case} 主键
	 * @return ${className} 数据
	 * @throws ServiceException
	 */
	@Override
	public ${className} findById(String ${pkname?lower_case}) throws ServiceException {
		String methodName = "findById";
		info(methodName, "param[${pkname?lower_case}]: " + ${pkname?lower_case});

		try {
			${className} ${className?uncap_first} = baseDao.findById(${className}.class, ${pkname?lower_case});
			return ${className?uncap_first};
		}
		catch (DaoException ex) {
			String message = "查询${table.comment!}错误";
			throw processException(methodName, message, ex);
		}
	}

	/**
	 * 删除${table.comment!}
	 * @param ${className?uncap_first}List
	 *            ${table.comment!}list
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
	<#if isNewFlow == "是">
				WorkFlowInput workFlowInput = new WorkFlowInput(${className?uncap_first}.getLoginUserid(),
				${className?uncap_first}.getOwnedModuleid(), ${className?uncap_first}.get${pkname?lower_case?cap_first}());
				taskFlowControlService.delete(workFlowInput);
	<#else>

				// 调用删除流程
				ResultData rstFlow = flowProcessService
						.deleteProcessInstance(${className?uncap_first});
				if (rstFlow.isSuccess() == false) {
					return rstFlow;
				}
	</#if>
				baseDao.saveOrUpdate(${className?uncap_first});
				rtData.setSuccess(true);
			}
		}
		catch (DaoException ex) {
			throw processException(methodName, "删除${table.comment!}错误", ex);
		}
	<#if isNewFlow == "是">
		catch (Exception ex) {
			throw processException(methodName, ex.getMessage(), ex);
		}
	<#else>
		catch (ServiceException ex) {
			throw processException(methodName, ex.getMessage(), ex);
		}
	</#if>

		return rtData;
	}
	/**
	* ${table.comment!}复核退回
	* @param ${className?uncap_first}
	*            到期交易
	* @throws ServiceException
	*/
	@Override
	public ResultData rejectFlow(${className} ${className?uncap_first}) throws ServiceException {
		String methodName = "rejectFlow";
		info(methodName, "param[${className?uncap_first}]: " + ${className?uncap_first});

		// 定义返回信息
		ResultData rtData = new ResultData();
		// 更新数据
		try {
	<#if isNewFlow == "是">
			WorkFlowInput workFlowInput = new WorkFlowInput(${className?uncap_first}.getLoginUserid(),
		${className?uncap_first}.getOwnedModuleid(), ${className?uncap_first}.get${pkname?lower_case?cap_first}(), ${className?uncap_first}.getNextNodeId());
			// 设置：审批意见
			if (CommonUtil.isNotEmpty(${className?uncap_first}.getFlowRemark())) {
				workFlowInput.setDealmesg(${className?uncap_first}.getFlowRemark());
			}
			// 设置：场景参数
			workFlowInput.putVariables("$" + ${className?uncap_first}.getOwnedModuleid(),
			ConvertUtils.beanToMap(${className?uncap_first}));

			// 流程退回
			taskFlowControlService.reject(workFlowInput);
	<#else>
			// 流程退回
			ResultData rstFlow = flowProcessService.reject(${className?uncap_first});
			if (rstFlow.isSuccess() == false) {
				return rstFlow;
			}
	</#if>
			baseDao.saveOrUpdate(${className?uncap_first});
			// 成功
			rtData.setSuccess(true);
		}
		catch (Exception ex) {
			throw processException(methodName, ex.getMessage(), ex);
		}
		return rtData;
	}
<#if isKeepAccount == "是">
	/**
	 * 账务预览
	 * @param ${className?uncap_first}
	 *            ${table.comment!}
	 * @param userInfo
	 *            当前登录用户信息
	 * @return ResultData
	 * @throws Exception
	 */
	@Override
	public ResultData saveAccountView(${className} ${className?uncap_first}, UserInfo userInfo)
			throws Exception {
		String methodName = "saveAccountView";
		ResultData rsData = new ResultData();
		if (CommonUtil.isEmpty(${className?uncap_first}.get${pkname?lower_case?cap_first}())) {
			rsData.setSuccess(false);
			rsData.setResultMessage("业务ID为空");
			return rsData;
		}
		try {
			// 是否预览
			String ifView = KaConstant.VIEW.IS_VIEW;

			// 账务处理
			${className}KeepAccount ${className?uncap_first}Ka = new ${className}KeepAccount();
			// 记账
			SysKeepAccount sysKeepAccount = new SysKeepAccount();
			sysKeepAccount = ${className?uncap_first}Ka.getSysKeepAccount(kaConfigService, ${className?uncap_first});

			// 调用创建方法进行记账
			rsData = keepAccountService.createLocal(sysKeepAccount, ifView);

		}catch (ServiceException e) {
			throw processException(methodName, e.getMessage(), e);
		}
		return rsData;
	}
	/**
	 * ${table.comment!}记账处理
	 * @param ${className?uncap_first}
	 *            到期交易
	 * @param isView
	 *            是否预览
	 * @return ResultData 结果集
	 * @throws ServiceException
	 */
	public ResultData keepAccount(${className} ${className?uncap_first}, String isView)
			throws ServiceException {
		String methedName = "keepAccount";
		info(methedName, "param[${className?uncap_first}]" + ${className?uncap_first} + " param[isView]" + isView);

		try {
			ResultData rs = new ResultData();
			// 是否预览
			String ifView = KaConstant.VIEW.NOT_VIEW;
			// 账务处理
			${className}KeepAccount ${className?uncap_first}Ka = new ${className}KeepAccount();
			// 记账
			SysKeepAccount sysKeepAccount = new SysKeepAccount();
			sysKeepAccount = ${className?uncap_first}Ka.getSysKeepAccount(kaConfigService, ${className?uncap_first});

			// 调用创建方法进行记账
			rs = keepAccountService.createLocal(sysKeepAccount, ifView);
			if (!rs.isSuccess()) {
				throw new ServiceException(
						ServiceException.SYS_KEEPACCOUNT_EXCEPTION, rs
								.getMessageCode());
			}
			return rs;
		}
		catch (ServiceException e) {
			throw processException(methedName, e.getMessage(), e);
		}

	}
	/**
	* 回滚业务数据
	* @param businessNo
	* @return ResultData
	* @throws ServiceException  
	 */
    public ResultData rubAccountByBusinessNo(String businessNo) throws ServiceException {
        String methodName = "rubAccountByBusinessNo";
        ResultData rd = new ResultData();
        
        ${className} ${className?uncap_first} = null;
        try {
        	//查询交易信息
        	${className?uncap_first} = baseDao.findById(${className}.class, businessNo);
        }
    	catch (DaoException e) {
            processException(methodName, "获取交易信息异常..", e);
        }

    	//回滚交易数据
    	${className?uncap_first}.setEffectflag(Constant.EffectFlag.A);
    	try {
			baseDao.update(${className?uncap_first});
		}
		catch (DaoException e) {
			processException(methodName, "更新交易信息错误", e);
		}
        return rd;
    }
<#if subTable??>
	private void delete${subClassName}By${pkname?lower_case?cap_first}(String ${pkname?lower_case}) throws DaoException,ServiceException {
		String methodName="delete${subClassName}By${pkname?lower_case?cap_first}" ;
		String message="删除${subTable.comment!}明细" ;
		info(methodName, message+",params[${pkname?lower_case}]="+${pkname?lower_case});

		String hql="DELETE ${subClassName} WHERE ${pkname?lower_case}=:${pkname?lower_case} ";
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("${pkname?lower_case}", ${pkname?lower_case});
		baseDao.executeHql(hql, paramMap, null);
	}

	public List<${subClassName}> find${subClassName}List(${className} ${className?uncap_first}) throws ServiceException {
		String methodName = "find${subClassName}List";
		List<${subClassName}> ${subClassName?uncap_first}List = new ArrayList<${subClassName}>();
		// 参数定义
		List<Object> params = new ArrayList<Object>();
		try {
			String queryString = "from ${subClassName} as ${subClassName?uncap_first} where 1=1 ";
			if (CommonUtil.isNotEmpty(${className?uncap_first}.get${pkname?lower_case?cap_first}())) {
				queryString += " and  ${subClassName?uncap_first}.${pkname?lower_case} = ? ";
				params.add(${className?uncap_first}.get${pkname?lower_case?cap_first}());
			}
			${subClassName?uncap_first}List = baseDao.findByParams(queryString, params.toArray());
			// 返回
			return ${subClassName?uncap_first}List;
		}catch (DaoException ex) {
			throw processException(methodName, ex.getMessage(), ex);
		}
	}
</#if>

<#if isSafeFlow == "是">
	public List<${className}> find${className}A(${className} ${className?uncap_first}) throws ServiceException {
		String methodName = "find${className}A";
		List<${className}> ${className?uncap_first}List = new ArrayList<${className}>();
		// 参数定义
		List<Object> params = new ArrayList<Object>();
		try {
			String queryString = "from ${className} as ${className?uncap_first} where 1=1 ";
			String queryWhere = "";
			if (CommonUtil.isNotEmpty(secid)) {
				queryWhere += " and  ${className?uncap_first}.planid = ? ";
				params.add(secid);
			}
			if (CommonUtil.isNotEmpty(orgid)) {
				queryWhere += " and  ${className?uncap_first}.orgid = ? ";
				params.add(orgid);
			}
			queryWhere += " and ${className?uncap_first}.effectflag = 'A'";
			${className?uncap_first}List = baseDao.findByParams(queryString + queryWhere, params.toArray());
			// 返回
			return ${className?uncap_first}List;
		}catch (DaoException ex) {
			throw processException(methodName, ex.getMessage(), ex);
		}
	}
	public ResultData saveSafeAndSubmit(${className} ${className?uncap_first}, boolean isSubmit) throws ServiceException {
		String methodName = "saveSafeAndSubmit";
		info(methodName, "param[${className?uncap_first}]: " + ${className?uncap_first});

		ResultData rst = new ResultData();

		try {
			// 判断是否有维护记录
			List<${className}> list = find${className}A(${className?uncap_first});
			// 存在维护的记录
			if(CommonUtil.isNotEmpty(list) && list.size()>1){
				throw new ServiceException(ServiceException.DATA_HAS_BEEN_EXIST, "流水号["+list.get(0).${pkname?lower_case?cap_first}()+"]正在维护此记录");
			}
		<#if isNewFlow == "是">
			// 原业务编号数据
			Long oldSeqno = ${className?uncap_first}.get${pkname?lower_case?cap_first}();
		</#if>
			baseDao.save(${className?uncap_first});

			${className?uncap_first}.setLinkid(${className?uncap_first}.get${pkname?lower_case?cap_first}() + "");
		<#if isNewFlow == "是">
			WorkFlowInput workFlowInput = new WorkFlowInput(${className?uncap_first}.getLoginUserid(),
			${className?uncap_first}.getOwnedModuleid(), ${className?uncap_first}.getLinkid(),
			${className?uncap_first}.getLoginOrgid(), null);
			// 设置：原业务编号
			workFlowInput.setObusinesskey(oldSeqno + "");
			// 设置：审批意见
			if (CommonUtil.isNotEmpty(${className?uncap_first}.getFlowRemark())) {
				workFlowInput.setDealmesg(${className?uncap_first}.getFlowRemark());
			}
		</#if>
			if (isSubmit) {
		<#if isNewFlow == "是">
				taskFlowControlService.submit(workFlowInput);
		<#else>
				// 新建维护流程并提交流程
				rst = flowProcessService.startModifyProcessTask(Constant.FlowKey.FLOW, null, ${className?uncap_first});
		</#if>
			}else {
		<#if isNewFlow == "是">
				taskFlowControlService.save(workFlowInput);
		<#else>
				// 新建维护流程实例
				rst = flowProcessService.startModifyByKey(Constant.FlowKey.FLOW, null,${className?uncap_first});
		</#if>
			}
			if (rst.isSuccess() == false) {
				return rst;
			}
		}catch (DaoException ex) {
			throw processException(methodName, ex.getMessage(), ex);
		}catch (ServiceException ex) {
			throw processException(methodName, ex.getMessage(), ex);
		}
<#if isNewFlow == "是">
		catch (Exception ex) {
			throw processException(methodName, ex.getMessage(), ex);
		}
</#if>
		rst.setObject(${className?uncap_first});
		rst.setSuccess(true);
		return rst;
	}
</#if>

</#if>
}
