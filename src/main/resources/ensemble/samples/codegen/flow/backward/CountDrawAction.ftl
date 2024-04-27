package com.joyin.ticm${packageName}.action;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import net.sf.ezmorph.MorpherRegistry;
import net.sf.ezmorph.object.DateMorpher;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.util.JSONUtils;

import org.springframework.beans.BeanUtils;
import org.springframework.context.annotation.Scope;
import org.springframework.orm.hibernate3.HibernateOptimisticLockingFailureException;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;

import com.joyin.ticm.bean.ResultData;
import com.joyin.ticm.common.constant.Constant;
import com.joyin.ticm.common.constant.Constant.DataDictClsNo;
import com.joyin.ticm.common.constant.Constant.EffectFlag;
import com.joyin.ticm.common.constant.Constant.OperateType;
import com.joyin.ticm.common.constant.Constant.RESPOND;
import com.joyin.ticm.common.enums.NumericZoom;
import com.joyin.ticm.common.util.CommonUtil;
import com.joyin.ticm.common.util.DateUtils;
import com.joyin.ticm.common.util.JsonUtil;
import com.joyin.ticm.common.util.MessageUtil;
import com.joyin.ticm.excel.ExcelService;
import com.joyin.ticm.page.Pager;
import com.joyin.ticm.service.ServiceException;
import com.joyin.ticm${packageName}.dto.${className}Dto;
import com.joyin.ticm${packageName}.model.${className};
import com.joyin.ticm${packageName}.model.${subClassName};
import com.joyin.ticm${packageName}.service.${className}Service;
import com.joyin.ticm.sysmn.report.ReportFactory;
import com.joyin.ticm.sysmn.user.model.UserInfo;
import com.joyin.ticm.web.action.ActionBase;
import com.joyin.ticm.web.common.WebConstant;
import com.joyin.ticm.web.plugin.Ticm;
import com.joyintech.config.env.EnvConfig;

/**
 * @Description: ${table.comment!}
 */
@Controller("${className?uncap_first}Action")
@Scope("prototype")
public class ${className}Action extends ActionBase{
	
	private static final long serialVersionUID = 1L;
	// 计提
	private ${className}Dto ${className?uncap_first}Dto = new ${className}Dto();
	private ${subClassName} ${subClassName?uncap_first} = new ${subClassName}();
	@Resource
	private ${className}Service ${className?uncap_first}Service;
	@Resource
	private ExcelService excelService;
	// 查询返回结果集
	private Map<String, Object> results = new HashMap<String, Object>();
	//当前登录用户
	UserInfo user = this.getSessionUserInfo();
	// 排序方式
	private String direction;
	// 排序列
	private String sort;
	private String gridData;
	
	/**
	 * @Description: 初始化grid页面
	 * @return SUCCESS  
	 */
	public String init${className}Manager(){
		String methodName = "init${className}Manager";
		info(methodName, "初始化grid页面");
		UserInfo user = this.getSessionUserInfo();
		// 初始化
		if (${className?uncap_first}Dto == null) {
			${className?uncap_first}Dto = new ${className}Dto();
		}
		// 机构类型
		${className?uncap_first}Dto.setLoginOrgtype(user.getOrgtype());
		// 机构号
		${className?uncap_first}Dto.setLoginOrgid(user.getUser().getOrgid());
		${className?uncap_first}Dto.setOrgid(user.getUser().getOrgid());
		// 当前操作模块
		${className?uncap_first}Dto.setOwnedModuleid(moduleid);

		// 默认设置optype为空
		optype = "";

		try {
			${className} issuebCountDraw = ${className?uncap_first}Service
					.findLast${className}(user.getLoginOrgid());

			if (CommonUtil.isNotEmpty(issuebCountDraw)) {
				// 上次计提日
				${className?uncap_first}Dto
						.setLstdrawdate(issuebCountDraw.getDrawdate());
			}
			Date drawDate = DateUtils.formatDate(Ticm.getSystemTime());
			// 本次计提日
			${className?uncap_first}Dto.setDrawdate(drawDate);

			// 本次计提截止日
			${className?uncap_first}Dto.setStopdate(drawDate);
		} catch (ServiceException e) {
			processExceptionIntoDB(methodName, "",
					Constant.OperateType.STRING_VIEW, e.getMessage(), e);
		}
		return SUCCESS;
	}
	
	/**
	 * 计提分页查询
	 * @return
	 */
	public String init${className}FindManager(){
		String methodName = "init${className}FindManager";
		info(methodName, "初始化grid查询页面");
		UserInfo user = this.getSessionUserInfo();
		// 初始化
		if (${className?uncap_first}Dto == null) {
			${className?uncap_first}Dto = new ${className}Dto();
		}
		// 机构类型
		${className?uncap_first}Dto.setLoginOrgtype(user.getOrgtype());
		// 机构号
		${className?uncap_first}Dto.setLoginOrgid(user.getUser().getOrgid());
		${className?uncap_first}Dto.setOrgid(user.getUser().getOrgid());
		// 当前操作模块
		${className?uncap_first}Dto.setOwnedModuleid(moduleid);

		// 默认设置optype为空
		optype = "";

		try {
			${className} issuebCountDraw = ${className?uncap_first}Service
					.findLast${className}(user.getLoginOrgid());

			if (CommonUtil.isNotEmpty(issuebCountDraw)) {
				// 上次计提日
				${className?uncap_first}Dto
						.setLstdrawdate(issuebCountDraw.getDrawdate());
			}
			Date drawDate = DateUtils.formatDate(Ticm.getSystemTime());
			// 本次计提日
			${className?uncap_first}Dto.setDrawdate(drawDate);

			// 本次计提截止日
			${className?uncap_first}Dto.setStopdate(drawDate);
		} catch (ServiceException e) {
			processExceptionIntoDB(methodName, "",
					Constant.OperateType.STRING_VIEW, e.getMessage(), e);
		}
		return SUCCESS;
	}
	
	/**
	* @Description: 编辑页面初始化
	* @return  SUCCESS
	 */
	public String init${className}Edit(){
		String methodName = "init${className}Edit";
		info(methodName, "编辑页面初始化");
		// 初始化Dto
		if (${className?uncap_first}Dto == null) {
			${className?uncap_first}Dto = new ${className}Dto();
		}
		try {
			// 获取申请信息
			${subClassName?uncap_first} = ${className?uncap_first}Service
					.find${subClassName}ById(${className?uncap_first}Dto.getSeqno());

			// 当前操作模块
			${subClassName?uncap_first}.setOwnedModuleid(moduleid);
			// 当前登录用户
			${subClassName?uncap_first}.setLoginUserid(user.getUser().getUserid());
			${subClassName?uncap_first}.setLoginOrgid(user.getUser().getOrgid());

			formatAttributeToView(${subClassName?uncap_first});
		} catch (ServiceException e) {
			processExceptionIntoDB(methodName, "",
					Constant.OperateType.STRING_VIEW, e.getMessage(), e);
		}

		return SUCCESS;
	}
	
	/**
	* @Description 计提查看页面
	 */
	public String init${className}View(){
		String methodName = "init${className}View";
		info(methodName, "查看页面初始化");
		// 初始化Dto
		if (${className?uncap_first}Dto == null) {
			${className?uncap_first}Dto = new ${className}Dto();
		}
		try {
			// 获取申请信息
			${subClassName?uncap_first} = ${className?uncap_first}Service
					.find${subClassName}ById(${className?uncap_first}Dto.getSeqno());
			// 当前登录用户
			${subClassName?uncap_first}.setLoginUserid(user.getUser().getUserid());
			${subClassName?uncap_first}.setLoginOrgid(user.getUser().getOrgid());

			formatAttributeToView(${subClassName?uncap_first});
		} catch (ServiceException e) {
			processExceptionIntoDB(methodName, "",
					Constant.OperateType.STRING_VIEW, e.getMessage(), e);
		}

		return SUCCESS;
	}
	
	/**
	 * @Description: ${table.comment!}查询
	 * @return String  
	 */
	@SuppressWarnings("unchecked")
	public String find${className}OfPage(){
		String methodName = "find${className}OfPage";
		info(methodName, "param[${className?uncap_first}Dto" + ${className?uncap_first}Dto);
		results = new HashMap<String, Object>();

		if (${className?uncap_first}Dto == null) {
			return methodName;
		}

		${className?uncap_first}Dto.setOwnedModuleid(moduleid);
		// 当前登录机构
		${className?uncap_first}Dto.setLoginOrgid(user.getUser().getOrgid());

		List<String> orgids = getOrganPList(${className?uncap_first}Dto.getOrgid());
		${subClassName?uncap_first}.setOrgid(CommonUtil.listToSqlStr(orgids));
		
		if (pager == null) {
			pager = new Pager();
		}
		if (StringUtils.hasText(sort)) {
			pager.setSort(sort);
		} else {
			sort = "lstmntdate";
		}
		if (StringUtils.hasText(direction)) {
			pager.setDirection(direction);
		} else {
			direction = "desc";
		}

		// 查询参数
		${subClassName} ${subClassName?uncap_first} = new ${subClassName}();
		BeanUtils.copyProperties(${className?uncap_first}Dto, ${subClassName?uncap_first});

		// 未组装的业务数据
		ResultData rstBizData = new ResultData();

		// 组装后的业务明细 + 流程明细
		List<${className}Dto> list = new ArrayList<${className}Dto>();
		pager.setPageSize(0);
		try {
			/********************************** 操作类型 *********************************/
			if (CommonUtil.isEmpty(optype)) {
				return methodName;
			}

			// 默认查询试运行数据
			if (optype.equals(WebConstant.OptionType.DEAL)) {
				${subClassName?uncap_first}.setEffectflag(EffectFlag.A);
				// 获取业务数据
				rstBizData = ${className?uncap_first}Service.find${className}OfPage(
						${subClassName?uncap_first}, pager);
			}
			/********************************** 操作类型 *********************************/
			else {
				${subClassName?uncap_first}.setEffectflag(EffectFlag.E);
				// 获取业务数据
				rstBizData = ${className?uncap_first}Service.find${className}OfPage(
						${subClassName?uncap_first}, pager);
			}

			/********************************** 数据组装 *********************************/
			if (CommonUtil.isNotEmpty(rstBizData)) {
				if (CommonUtil.isNotEmpty(rstBizData.getList())) {
					// 获取参数字典
					// Map<String, String> dict = Utils.getDataDictMap();
					${className}Dto dto = null;
					List<${subClassName}> details = (List<${subClassName}>) rstBizData
							.getList();
					for (${subClassName} row : details) {
						dto = new ${className}Dto();

						BeanUtils.copyProperties(row, dto);
						// 格式化数据
						formatAttributeToViewForPage(dto);

						list.add(dto);
					}
				}
				results.put("pager.pageNo", rstBizData.getPager().getPageNo());
				results.put("pager.totalRows", rstBizData.getPager()
						.getTotalRows());
				results.put("rows", list);
				results.put("sort", sort);
				results.put("direction", direction);
			}
		} catch (ServiceException e) {
			results.put(Constant.RESPOND.RESULT, false);
			results.put(Constant.RESPOND.MESSAGE, e.getMessage());
			processExceptionIntoDB(methodName, "",
					Constant.OperateType.STRING_VIEW_LIST, e.getMessage(), e);
		}

		return methodName;
	}
	
	@SuppressWarnings("unchecked")
	public String find${className}FindOfPage(){
		String methodName = "find${className}FindOfPage";
		info(methodName, "param[${className?uncap_first}Dto" + ${className?uncap_first}Dto);
		results = new HashMap<String, Object>();

		if (${className?uncap_first}Dto == null) {
			return methodName;
		}

		${className?uncap_first}Dto.setOwnedModuleid(moduleid);
		// 当前登录机构
		${className?uncap_first}Dto.setLoginOrgid(user.getUser().getOrgid());

		List<String> orgids = getOrganPList(${className?uncap_first}Dto.getOrgid());
		${subClassName?uncap_first}.setOrgid(CommonUtil.listToSqlStr(orgids));
		
		if (pager == null) {
			pager = new Pager();
		}
		if (StringUtils.hasText(sort)) {
			pager.setSort(sort);
		} else {
			sort = "lstmntdate";
		}
		if (StringUtils.hasText(direction)) {
			pager.setDirection(direction);
		} else {
			direction = "desc";
		}

		// 查询参数
		${subClassName} ${subClassName?uncap_first} = new ${subClassName}();
		BeanUtils.copyProperties(${className?uncap_first}Dto, ${subClassName?uncap_first});

		// 未组装的业务数据
		ResultData rstBizData = new ResultData();

		// 组装后的业务明细 + 流程明细
		List<${className}Dto> list = new ArrayList<${className}Dto>();

		try {
			/********************************** 操作类型 *********************************/
			if (CommonUtil.isEmpty(optype)) {
				return methodName;
			}

			// 默认查询试运行数据
			if (optype.equals(WebConstant.OptionType.DEAL)) {
				${subClassName?uncap_first}.setEffectflag(EffectFlag.A);
				// 获取业务数据
				rstBizData = ${className?uncap_first}Service.find${className}OfPage(
						${subClassName?uncap_first}, pager);
			}
			/********************************** 操作类型 *********************************/
			else {
				${subClassName?uncap_first}.setEffectflag(EffectFlag.E);
				// 获取业务数据
				rstBizData = ${className?uncap_first}Service.find${className}OfPage(
						${subClassName?uncap_first}, pager);
			}

			/********************************** 数据组装 *********************************/
			if (CommonUtil.isNotEmpty(rstBizData)) {
				if (CommonUtil.isNotEmpty(rstBizData.getList())) {
					// 获取参数字典
					// Map<String, String> dict = Utils.getDataDictMap();
					${className}Dto dto = null;
					List<${subClassName}> details = (List<${subClassName}>) rstBizData
							.getList();
					for (${subClassName} row : details) {
						dto = new ${className}Dto();
//						String[] ignoreProperties = {"days"};
						BeanUtils.copyProperties(row, dto);
						// 格式化数据
						formatAttributeToViewForPage(dto);

						dto.setBasisName(super.getDictName(dto.getBasis(),
								DataDictClsNo.BASIS));

						list.add(dto);
					}
				}
				results.put("pager.pageNo", rstBizData.getPager().getPageNo());
				results.put("pager.totalRows", rstBizData.getPager()
						.getTotalRows());
				results.put("rows", list);
				results.put("sort", sort);
				results.put("direction", direction);
			}
		} catch (ServiceException e) {
			results.put(Constant.RESPOND.RESULT, false);
			results.put(Constant.RESPOND.MESSAGE, e.getMessage());
			processExceptionIntoDB(methodName, "",
					Constant.OperateType.STRING_VIEW_LIST, e.getMessage(), e);
		}

		return methodName;
	}
	
	/**
	 * @Description: ${table.comment!}试运行
	 * @return String  
	 */
	public String runTest(){
		String methodName = "runTest";
		String infomsg = "计提试运行";
		info(methodName, infomsg);
		// 操作结果
		ResultData rstBiz = new ResultData();

		try {
			// 查询本机构上次计提日期
			Date lastDrawDate = null;
			${className} ${className?uncap_first} = new ${className}();
			${className?uncap_first} = ${className?uncap_first}Service
					.findLast${className}(user.getLoginOrgid());
			if (CommonUtil.isNotEmpty(${className?uncap_first})) {
				lastDrawDate = ${className?uncap_first}.getDrawdate();
			}

			rstBiz = ${className?uncap_first}Service.saveRunTest(user.getLoginOrgid(),
					user.getOrgname(), user, lastDrawDate,
					${className?uncap_first}Dto.getDrawdate());
			${className} collect = new ${className}();
			collect = (${className}) rstBiz.getObject();
			if (CommonUtil.isNotEmpty(collect.get${pkname?lower_case?cap_first}())) {
				// 记录日志
				writeOpLog(collect.get${pkname?lower_case?cap_first}().toString(), moduleid,
						OperateType.STRING_NEW);
			}

			if (rstBiz.isSuccess()) {
				results.put(RESPOND.RESULT, true);
			} else {
				results.put(RESPOND.RESULT, false);
				results
						.put(
								RESPOND.MESSAGE,
								StringUtils.hasText(rstBiz.getResultMessage()) ? rstBiz
										.getResultMessage()
										: MessageUtil
												.getMessage(MessageUtil.Message.TICM_MESSAGE_SAVE_ERROR));
			}
		} catch (ServiceException e) {
			results.put(RESPOND.RESULT, false);
			results.put(RESPOND.MESSAGE, e.getMessage());

			processExceptionIntoDB(methodName, "",
					Constant.OperateType.STRING_NEW, infomsg + e.getMessage(),
					e);
		} catch (HibernateOptimisticLockingFailureException e) {
			results.put(RESPOND.RESULT, false);
			results.put(RESPOND.MESSAGE, MessageUtil
					.getMessage(MessageUtil.Message.OP_LOG_0002));
			processExceptionIntoDB(methodName, "",
					Constant.OperateType.STRING_NEW, infomsg + message, e);
		}
		return methodName;
	}
	
	/**
	* @Description: ${table.comment!}
	* @return String
	 */
	public String runCount() {
		String methodName = "runCount";
		String infomsg = "计提";
		info(methodName, infomsg);

		// 操作结果
		ResultData rstBiz = new ResultData();

		try {
			UserInfo userInfo = getSessionUserInfo();
			ResultData checkResultData = checkCountdrawSwitch(moduleid, userInfo
					.getUser().getOrgid());
			if (!checkResultData.isSuccess()) {
				results.put(RESPOND.RESULT, false);
				results.put(RESPOND.MESSAGE, checkResultData.getResultMessage());
				return methodName;
			}
			
			rstBiz = ${className?uncap_first}Service.saveRunCount(user.getLoginOrgid(),
					user.getLoginUserid());
			${className} ${className?uncap_first} = (${className}) rstBiz
					.getObject();
			if (CommonUtil.isNotEmpty(${className?uncap_first})) {
				// 记录日志
				writeOpLog(${className?uncap_first}.get${pkname?lower_case?cap_first}().toString(), moduleid,
						OperateType.STRING_NEW);
			}

			if (rstBiz.isSuccess()) {
				results.put(RESPOND.RESULT, true);
			} else {
				results.put(RESPOND.RESULT, false);
				results
						.put(
								RESPOND.MESSAGE,
								StringUtils.hasText(rstBiz.getResultMessage()) ? rstBiz
										.getResultMessage()
										: MessageUtil
												.getMessage(MessageUtil.Message.TICM_MESSAGE_SAVE_ERROR));
			}
		} catch (ServiceException e) {
			results.put(RESPOND.RESULT, false);
			results.put(RESPOND.MESSAGE, e.getMessage());
			processExceptionIntoDB(methodName, "",
					Constant.OperateType.STRING_NEW, infomsg + message, e);
		} catch (HibernateOptimisticLockingFailureException e) {
			results.put(RESPOND.RESULT, false);
			results.put(RESPOND.MESSAGE, MessageUtil
					.getMessage(MessageUtil.Message.OP_LOG_0002));
			processExceptionIntoDB(methodName, "",
					Constant.OperateType.STRING_NEW, infomsg + message, e);
		}
		return methodName;
	}
	
	
	/**
	 * @Description: grid显示格式化
	 * @param ${className?uncap_first}Dto   
	 */
	private void formatAttributeToViewForPage(
			${className}Dto ${className?uncap_first}Dto) {


	}
	/**
	* @Description: 编辑页面数据格式化
	* @param ${subClassName?uncap_first}  
	* @author wj
	* @date 2016-8-10 上午10:32:06
	 */
	public void formatAttributeToView(${subClassName} ${subClassName?uncap_first}){

	}
	/**
	* @Description: 保存计提明细
	* @return SUCCESS
	 */
	public String saveDetail() {
		String methodName = "saveDetail";
		String infomsg = "保存计提明细";
		info(methodName, infomsg);

		ResultData rstBiz = new ResultData();
		try {
			// 去除空格
			trimFieldForStr(${subClassName?uncap_first});
			//格式化数据
			format${className}(${subClassName?uncap_first});

			if (CommonUtil.isEmpty(${subClassName?uncap_first})) {
				results.put(RESPOND.RESULT, false);
				results.put(RESPOND.MESSAGE, "保存数据为空");
				return methodName;
			}

			rstBiz = ${className?uncap_first}Service
					.update${subClassName}(${subClassName?uncap_first});

			if (rstBiz.isSuccess()) {
				results.put(RESPOND.RESULT, true);
			} else {
				results.put(RESPOND.RESULT, false);
				results
						.put(
								RESPOND.MESSAGE,
								StringUtils.hasText(rstBiz.getResultMessage()) ? rstBiz
										.getResultMessage()
										: MessageUtil
												.getMessage(MessageUtil.Message.TICM_MESSAGE_EDIT_ERROR));
			}
		} catch (ServiceException e) {
			results.put(RESPOND.RESULT, false);
			results.put(RESPOND.MESSAGE, e.getMessage());
			processExceptionIntoDB(methodName, "",
					Constant.OperateType.STRING_UPDATE, infomsg + message, e);
		} catch (HibernateOptimisticLockingFailureException e) {
			results.put(RESPOND.RESULT, false);
			results.put(RESPOND.MESSAGE, MessageUtil
					.getMessage(MessageUtil.Message.OP_LOG_0002));
			processExceptionIntoDB(methodName, "",
					Constant.OperateType.STRING_UPDATE, infomsg + message, e);
		}
		return methodName;
	}
	/**
	* @Description 格式化数据
	 */
	private void format${className}(${subClassName} ${subClassName?uncap_first}){

	}
	
	/**
	* @Description: 删除计提明细
	* @return  SUCCESS
	 */
	public String delete${className}() {
		String methodName = "delete${className}";
		String infomsg = "删除计提信息";
		info(methodName, infomsg);

		try {
			String strIds = request.getParameter("ids");
			if (CommonUtil.isNotEmpty(strIds)) {
				String[] ids = strIds.split(",");
				for (String idstr : ids) {
					if (CommonUtil.isNotEmpty(idstr)) {
						String[] idsss = idstr.split("#");
						if (CommonUtil.isNotEmpty(idsss) && idsss.length >= 2) {
							Long seqno = Long.valueOf(idsss[0]);
							${className?uncap_first}Service
									.delete${subClassName}(seqno);
							// 记录日志
							writeOpLog(idsss[0], idsss[1],
									OperateType.STRING_DELETE);
						}
					}
				}
			}
			results.put(RESPOND.RESULT, true);
		} catch (ServiceException e) {
			results.put(RESPOND.RESULT, false);
			results.put(RESPOND.MESSAGE, e.getMessage());
			processExceptionIntoDB(methodName, "",
					Constant.OperateType.STRING_DELETE, infomsg + message, e);
		} catch (HibernateOptimisticLockingFailureException e) {
			results.put(RESPOND.RESULT, false);
			results.put(RESPOND.MESSAGE, MessageUtil
					.getMessage(MessageUtil.Message.OP_LOG_0002));
			processExceptionIntoDB(methodName,"",
					Constant.OperateType.STRING_DELETE, infomsg + message, e);
		}

		return methodName;
	}
	

	@SuppressWarnings({ "unchecked" })
	public String exportReportXlsOfPage(){
		String methodName="SLCountDrawAction.exportReportXlsOfPage";
		info(methodName, "导出${table.comment!}数据");
		List<${className}Dto> detailModelList = new ArrayList<${className}Dto>();
		
		if (${className?uncap_first}Dto == null) {
			return methodName;
		}

		${className?uncap_first}Dto.setOwnedModuleid(moduleid);
		// 当前登录机构
		${className?uncap_first}Dto.setLoginOrgid(user.getUser().getOrgid());

		List<String> orgids = getOrganPList(${className?uncap_first}Dto.getOrgid());
		${subClassName?uncap_first}.setOrgid(CommonUtil.listToSqlStr(orgids));
		
		pager.setSort("seqno");
		pager.setDirection("desc");

		// 查询参数
		${subClassName} ${subClassName?uncap_first} = new ${subClassName}();
		BeanUtils.copyProperties(${className?uncap_first}Dto, ${subClassName?uncap_first});

		// 未组装的业务数据
		ResultData rstBizData = new ResultData();

		pager.setPageSize(0);
		try {
			/********************************** 操作类型 *********************************/
			if (CommonUtil.isEmpty(optype)) {
				return methodName;
			}

			// 默认查询试运行数据
			if (optype.equals(WebConstant.OptionType.DEAL)) {
				${subClassName?uncap_first}.setEffectflag(EffectFlag.A);
				// 获取业务数据
				rstBizData = ${className?uncap_first}Service.find${className}OfPage(
						${subClassName?uncap_first}, pager);
			}
			/********************************** 操作类型 *********************************/
			else {
				${subClassName?uncap_first}.setEffectflag(EffectFlag.E);
				// 获取业务数据
				rstBizData = ${className?uncap_first}Service.find${className}OfPage(
						${subClassName?uncap_first}, pager);
			}

			/********************************** 数据组装 *********************************/
			if (CommonUtil.isNotEmpty(rstBizData)) {
				if (CommonUtil.isNotEmpty(rstBizData.getList())) {
					// 获取参数字典
					// Map<String, String> dict = Utils.getDataDictMap();
					${className}Dto dto = null;
					List<${subClassName}> details = (List<${subClassName}>) rstBizData
							.getList();
					for (${subClassName} row : details) {
						dto = new ${className}Dto();
//						String[] ignoreProperties = {"days"};
						BeanUtils.copyProperties(row, dto);
						// 格式化数据
						formatAttributeToViewForPage(dto);

						dto.setBasisName(super.getDictName(dto.getBasis(),
								DataDictClsNo.BASIS));

						detailModelList.add(dto);
					}
				}
			}
		} catch (ServiceException e) {
			results.put(Constant.RESPOND.RESULT, false);
			results.put(Constant.RESPOND.MESSAGE, e.getMessage());
			processExceptionIntoDB(methodName, "",
					Constant.OperateType.STRING_VIEW_LIST, e.getMessage(), e);
		}
		
		// 用户信息取得
        UserInfo user = (UserInfo) request.getSession().getAttribute(
                WebConstant.USER_INFO.USER_KEY);
		// 明细List取得
		List<${className}Dto> ${className?uncap_first}DTOListMX = new ArrayList<${className}Dto>();
		
		${className}Dto tempExcel = null;
		
		//String BZREO ="0.00";
		
		//String BZREO4 ="0.0000";
		// 试用行数据是否为空
		if(detailModelList == null){
			results.put("status", false);
        	results.put("message", "数据为空");
            return SUCCESS;
		} else {
			//债券券面总额(元)
			BigDecimal totalamt = new BigDecimal("0");
			//期初利息余额
			BigDecimal sintamt = new BigDecimal("0");
			//应计利息
			BigDecimal intamt = new BigDecimal("0");
			//应付利息余额(元)
			BigDecimal totalintamt = new BigDecimal("0");
			
			for(${className}Dto dto :detailModelList){
				
				tempExcel =  new ${className}Dto();
				
				tempExcel.setReqid(dto.getReqid());
				
				tempExcel.setAccremark(dto.getAccremark());
				
				// 明细
				${className?uncap_first}DTOListMX.add(tempExcel);
			}
			
			${className}Dto tempExceltotal =  new ${className}Dto();
			
			tempExceltotal.setReqid("合计");
			
			tempExceltotal.setTotalamtName(formatMonYuan(totalamt,2));
			tempExceltotal.setIntamtName(formatMonYuan(intamt,2));
			tempExceltotal.setSintamtName(formatMonYuan(sintamt,2));
			tempExceltotal.setTotalintamtName(formatMonYuan(totalintamt,2));
			
			${className?uncap_first}DTOListMX.add(tempExceltotal);
		}
		
		Map<String, Object> datas = new HashMap<String, Object>();
        datas.put("orgid",user.getOrgname());
        datas.put("date", Ticm.getSystemTime());
        datas.put("temp", ${className?uncap_first}DTOListMX);
        String fileName = ReportFactory.getStringKey() + ".xls";

        try {
			excelService.creatExcelFileMapObj(WebConstant.ExcelTemplete.SLCOUNTDRAWEXCEL, datas, fileName);
		} catch (ServiceException e) {
			processExceptionIntoDB(methodName,null,WebConstant.OptionType.QUERY, e.getMessage(), e); 
        	error(methodName,e.getMessage());
        	results.put("status", false);
        	results.put("message", e.getMessage());
		}

        results.put("status", true);
        results.put("fileName", fileName);
        results.put("targetFileName",WebConstant.ExcelTemplete.SLCOUNTDRAWEXCEL);
		
		return SUCCESS;
	}
	
	/**
	* @Description 初始化上次计提日及本次计提日
	 */
	public String initCountDrawDate() {
		String methodName = "initCountDrawDate";
		String infomsg = "初始化上次计提日及本次计提日.";
		info(methodName, infomsg);

		try {
			${className} ${className?uncap_first} = ${className?uncap_first}Service
					.findLast${className}(user.getLoginOrgid());

			if (CommonUtil.isNotEmpty(${className?uncap_first})) {
				// 上次计提日
				results.put("lstdrawdate", DateUtils
						.formatDateString(${className?uncap_first}.getDrawdate()));
			}
			// 本次计提日
			results.put("drawdate", DateUtils.formatDateString(DateUtils
					.formatDate(Ticm.getSystemTime())));

			// 本次计提截止日
			results.put("stopdate", DateUtils.formatDateString(DateUtils
					.formatDate(Ticm.getSystemTime())));
		} catch (ServiceException e) {
			processExceptionIntoDB(methodName, "",
					Constant.OperateType.STRING_VIEW, infomsg + message, e);
			return ERROR;
		}

		return methodName;
	}
	
	private String formatMonYuan(BigDecimal mon,int number) {
	       return (CommonUtil.isNotEmpty(mon)&& null!=mon) ? CommonUtil.formatNumeric(mon,
	               NumericZoom.Yuan, number) : "0.00";
		}
		
	private BigDecimal formatYuan(BigDecimal mon,int number) {
	       return (CommonUtil.isNotEmpty(mon)&& null!=mon) ? CommonUtil.formatBigDecimal(mon,
	                NumericZoom.Yuan, number) : BigDecimal.ZERO;
	}

	public ${className}Dto get${className}Dto() {
		return ${className?uncap_first}Dto;
	}

	public void set${className}Dto(${className}Dto ${className?uncap_first}Dto) {
		this.${className?uncap_first}Dto = ${className?uncap_first}Dto;
	}

	public Map<String, Object> getResults() {
		return results;
	}

	public void setResults(Map<String, Object> results) {
		this.results = results;
	}

	public String getDirection() {
		return direction;
	}

	public void setDirection(String direction) {
		this.direction = direction;
	}

	public String getSort() {
		return sort;
	}

	public void setSort(String sort) {
		this.sort = sort;
	}

	public void set${subClassName}(${subClassName} ${subClassName?uncap_first}) {
		this.${subClassName?uncap_first} = ${subClassName?uncap_first};
	}

	public ${subClassName} get${subClassName}() {
		return ${subClassName?uncap_first};
	}

	public String getGridData() {
		return gridData;
	}

	public void setGridData(String gridData) {
		this.gridData = gridData;
	}

}
