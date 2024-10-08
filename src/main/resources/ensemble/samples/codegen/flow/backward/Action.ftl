package com.joyin.ticm${packageName}.action;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.orm.hibernate3.HibernateOptimisticLockingFailureException;


import com.joyin.ticm.accmn.kamn.model.SysKeepAccount;
import com.joyin.ticm.accmn.kamn.model.SysKeepAccountDetail;
import com.joyin.ticm.base.Entity;
import com.joyin.ticm.bean.ResultData;
import com.joyin.ticm.common.constant.Constant;
import com.joyin.ticm.common.constant.Constant.FlowStateType;
import com.joyin.ticm.common.constant.Constant.RESPOND;
import com.joyin.ticm.common.util.CommonUtil;
import com.joyin.ticm.common.util.MessageUtil;
import com.joyin.ticm.dao.DaoException;
import com.joyin.ticm.page.Pager;
import com.joyin.ticm.service.ServiceException;

import com.joyin.ticm${packageName}.model.${className};
import com.joyin.ticm${packageName}.service.${className}Service;

import com.joyin.ticm.sysmn.user.model.UserInfo;
import com.joyin.ticm.sysmn.report.ReportFactory;
import com.joyin.ticm.web.action.ActionBase;
<#if isNewFlow == "是">
import com.joyintech.jupiter.workflow.commons.WorkFlowInput;
import com.joyintech.jupiter.workflow.entity.FlowProcess;
import com.joyintech.jupiter.workflow.exception.FlowException;
import org.springframework.beans.BeanUtils;
<#else>
import com.joyin.ticm.workflow.model.FlowState;
</#if>


@Controller("${className?uncap_first}Action")
@Scope("prototype")
public class ${className}Action extends ActionBase {

    private static final long serialVersionUID = 1L;
    @Resource
    private ${className}Service ${className?uncap_first}Service;

    private String direction;
    private String sort;

    private ${className} ${className?uncap_first} = new ${className}();

    private UserInfo user = this.getSessionUserInfo();
    // 返回操作信息
    private Map<String, Object> results = new Hashtable<String, Object>();
<#if isNewFlow == "是">
<#else>
    // 流程状态
    private FlowState flowState;
</#if>

    public String init${className}Manager() {
        String methodName = "init${className}Manager";
        info(methodName, "初始化${table.comment!}管理页面");
        // 机构类型
        ${className?uncap_first}.setLoginOrgtype(user.getOrgtype());
        // 登录机构号
        ${className?uncap_first}.setLoginOrgid(user.getUser().getOrgid());
        // 非省联社机构不可以修改当前机构号和机构名称
        ${className?uncap_first}.setOrgid(user.getUser().getOrgid());
        ${className?uncap_first}.setOrgname(user.getOrgname());
        // 模块id
        ${className?uncap_first}.setOwnedModuleid(moduleid);
        return SUCCESS;
    }

    public String init${className}Add() {
        String methodName = "init${className}Add";
        info(methodName, "初始化${table.comment!}新增页面");

        ${className?uncap_first}.setRtranuser(user.getUser().getUserid());
        ${className?uncap_first}.setRtranname(user.getUser().getUsername());
        ${className?uncap_first}.setOrgid(user.getUser().getOrgid());
        ${className?uncap_first}.setOrgname(user.getOrgname());

        return SUCCESS;
    }

    public String init${className}Edit() {
        String methodName = "init${className}Edit";
        info(methodName, "初始化${table.comment!}编辑页面.");
        // flowState = new FlowState();
        try {

            ${className?uncap_first} = ${className?uncap_first}Service.findById(${className?uncap_first}.get${pkname?lower_case?cap_first}());
<#if isNewFlow == "是">
<#else>
            String taskId = ${className?uncap_first}.getTaskId();
            // 获取流程信息
            flowState = getFlowStateByTaskId(taskId);
            // 流程信息转换
            transferFlowInfo(${className?uncap_first}, flowState);
</#if>

            format${className}ForPage(${className?uncap_first});

        }catch (ServiceException e) {
            processExceptionIntoDB(methodName, ${className?uncap_first}.get${pkname?lower_case?cap_first}(),
            Constant.OperateType.STRING_UPDATE, e.getMessage(), e);
        }
        return SUCCESS;
    }

    public String init${className}View() {
        String methodName = "init${className}View";
        info(methodName, "初始化${table.comment!}查看页面");
        try {
            ${className?uncap_first} = ${className?uncap_first}Service.findById(${className?uncap_first}.get${pkname?lower_case?cap_first}());
            format${className}ForPage(${className?uncap_first});
        }catch (ServiceException e) {
            // 异常处理，异常入库操作
            processExceptionIntoDB(methodName, ${className?uncap_first}.get${pkname?lower_case?cap_first}(),
            Constant.OperateType.STRING_VIEW, e.getMessage(), e);
        }
        return SUCCESS;
    }

    public String save${className}() {
        String methodName = "save${className}";
        info(methodName, "保存${table.comment!}");
        UserInfo user = this.getSessionUserInfo();
        // 当前登录用户机构号
        ${className?uncap_first}.setLoginOrgid(user.getUser().getOrgid());
        // 当前登录用户
        ${className?uncap_first}.setLoginUserid(user.getUser().getUserid());
        // 当前操作用户
        ${className?uncap_first}.setTraUserid(user.getUser().getUserid());
        // 业务更新用户
        ${className?uncap_first}.setLstmntuser(user.getUser().getUserid());
        // 操作结果
        ResultData rstBiz = new ResultData();
        // 去掉实体中所有字段前后空格
        trimFieldForStr(${className?uncap_first});
        try {
        <#if isNewFlow == "是">
            // 流程提交下一步办理主体json字符串转list
            setFlowDealSubjectList(${className?uncap_first});

        </#if>
            format${className}ForSave(${className?uncap_first});
            if (CommonUtil.isNotEmpty(${className?uncap_first}.get${pkname?lower_case?cap_first}())) {
                // 编辑
                rstBiz = ${className?uncap_first}Service.updateAndSubmit(${className?uncap_first}, false);
                // 记录日志
                writeOpLog(${className?uncap_first}.get${pkname?lower_case?cap_first}(), ${className?uncap_first}.getOwnedModuleid(),
                Constant.OperateType.STRING_UPDATE);
            } else {
                ${className?uncap_first}.setEffectflag(Constant.EffectFlag.A);
                // 新增
                rstBiz = ${className?uncap_first}Service.saveAndSubmit(${className?uncap_first}, false);
                // 保存后的存放申请
                ${className} ${className?uncap_first} = (${className}) rstBiz.getObject();
                // 记录日志
                writeOpLog(${className?uncap_first}.get${pkname?lower_case?cap_first}(), ${className?uncap_first}.getOwnedModuleid(),
                Constant.OperateType.STRING_NEW);
            }
            if (rstBiz.isSuccess()) {
                results.put(Constant.RESPOND.RESULT, true);
            }
            else {
                results.put(Constant.RESPOND.RESULT, false);
                results.put(Constant.RESPOND.MESSAGE,MessageUtil.getMessage(MessageUtil.Message.TICM_MESSAGE_SAVE_ERROR));
            }
        } catch (ServiceException e) {
            results.put(Constant.RESPOND.RESULT, false);
            results.put(Constant.RESPOND.MESSAGE, e.getMessage());
            // 异常处理，异常入库操作
            processExceptionIntoDB(methodName, ${className?uncap_first}.get${pkname?lower_case?cap_first}(),
            Constant.OperateType.STRING_UPDATE, e.getMessage(), e);
        } catch (HibernateOptimisticLockingFailureException e) {
            results.put(Constant.RESPOND.RESULT, false);
            results.put(Constant.RESPOND.MESSAGE, MessageUtil
            .getMessage(MessageUtil.Message.OP_LOG_0002));
            processExceptionIntoDB(methodName, ${className?uncap_first}.get${pkname?lower_case?cap_first}(),
            Constant.OperateType.STRING_UPDATE, e.getMessage(), e);
        }
        return methodName;
    }

    public String submit${className}() {
        String methodName = "submit${className}";
        info(methodName, "提交${table.comment!}");
        // 当前登录用户机构号
        ${className?uncap_first}.setLoginOrgid(user.getUser().getOrgid());
        // 当前登录用户
        ${className?uncap_first}.setLoginUserid(user.getUser().getUserid());
        // 当前操作用户
        ${className?uncap_first}.setTraUserid(user.getUser().getUserid());
        // 业务更新用户
        ${className?uncap_first}.setLstmntuser(user.getUser().getUserid());
        // 去掉实体中所有字段前后空格
        trimFieldForStr(${className?uncap_first});
        try {
        <#if isNewFlow == "是">
            // 流程提交下一步办理主体json字符串转list
            setFlowDealSubjectList(${className?uncap_first});

        </#if>
            format${className}ForSave(${className?uncap_first});

            ResultData rstBiz = new ResultData();
            ResultData rst = new ResultData();
            if (CommonUtil.isNotEmpty(${className?uncap_first}.get${pkname?lower_case?cap_first}())) {
                // 更新并提交
                rstBiz = ${className?uncap_first}Service.updateAndSubmit(${className?uncap_first}, true);
                // 记录日志
                writeOpLog(${className?uncap_first}.get${pkname?lower_case?cap_first}(), ${className?uncap_first}.getOwnedModuleid(),
                Constant.OperateType.STRING_UPDATEANDSUBMIT);
            } else {
                ${className?uncap_first}.setEffectflag(Constant.EffectFlag.A);
                // 保存并提交
                rstBiz = ${className?uncap_first}Service.saveAndSubmit(${className?uncap_first}, true);
                // 记录日志
                writeOpLog(${className?uncap_first}.get${pkname?lower_case?cap_first}(), ${className?uncap_first}.getOwnedModuleid(),
                Constant.OperateType.STRING_SUBMIT);
            }
<#if isKeepAccount == "是">
            if (FlowStateType.FLOW_OVER == rstBiz.getTaskOrder()) {
                rst = printVouch((List<SysKeepAccount>) rstBiz.getList());
                if (rst.isSuccess()) {
                    //获取当前登录的机构号，并传到前台页面
                    UserInfo user = this.getSessionUserInfo();
                    String orgid = user.getUser().getOrgid();
                    results.put("orgid", orgid);
                    results.put(Constant.RESPOND.RESULT, true);
                    results.put("key", rst.getObject());
                } else {
                    results.put(Constant.RESPOND.RESULT, false);
                    results.put(Constant.RESPOND.MESSAGE,MessageUtil.getMessage(MessageUtil.Message.TICM_MESSAGE_SUBMIT_ERROR));
                }
            } else {
                if (rstBiz.isSuccess()) {
                    results.put(Constant.RESPOND.RESULT, true);
                    results.put(Constant.RESPOND.MESSAGE,MessageUtil.getMessage(MessageUtil.Message.TICM_MESSAGE_SUBMIT_SUCCESS));
                } else {
                    results.put(Constant.RESPOND.RESULT, false);
                    results.put(Constant.RESPOND.MESSAGE,MessageUtil.getMessage(MessageUtil.Message.TICM_MESSAGE_SUBMIT_ERROR));
                }
            }
<#else>
        if (rstBiz.isSuccess()) {
            results.put(Constant.RESPOND.RESULT, true);
            results.put(Constant.RESPOND.MESSAGE,MessageUtil.getMessage(MessageUtil.Message.TICM_MESSAGE_SUBMIT_SUCCESS));
        } else {
            results.put(Constant.RESPOND.RESULT, false);
            results.put(Constant.RESPOND.MESSAGE,MessageUtil.getMessage(MessageUtil.Message.TICM_MESSAGE_SUBMIT_ERROR));
        }
</#if>
        } catch (ServiceException e) {
            // 返回错误结果
            results.put(Constant.RESPOND.RESULT, false);
            results.put(Constant.RESPOND.MESSAGE, e.getMessage());
            // 异常处理，异常入库操作
            processExceptionIntoDB(methodName, ${className?uncap_first}.get${pkname?lower_case?cap_first}(),
            Constant.OperateType.STRING_SUBMIT, e.getMessage(), e);
        } catch (HibernateOptimisticLockingFailureException e) {
            // 返回错误结果
            results.put(Constant.RESPOND.RESULT, false);
            results.put(Constant.RESPOND.MESSAGE, MessageUtil
            .getMessage(MessageUtil.Message.OP_LOG_0002));
            processExceptionIntoDB(methodName, ${className?uncap_first}.get${pkname?lower_case?cap_first}(),
            Constant.OperateType.STRING_SUBMIT, e.getMessage(), e);
        }
        return methodName;
    }

<#if isKeepAccount == "是">
    public String saveAccountView(){
        String methodName = "saveAccountView";
        info(methodName, "${table.comment!}账务预览");

        UserInfo user = this.getSessionUserInfo();
        try {
            // 当前登录用户机构号
            ${className?uncap_first}.setLoginOrgid(user.getUser().getOrgid());
            // 当前登录用户
            ${className?uncap_first}.setLoginUserid(user.getUser().getUserid());
            // 当前操作用户
            ${className?uncap_first}.setTraUserid(user.getUser().getUserid());
            // 业务更新用户
            ${className?uncap_first}.setLstmntuser(user.getUser().getUserid());

            //去掉实体中所有字段前后空格
            trimFieldForStr(${className?uncap_first});

            ResultData rs = ${className?uncap_first}Service.saveAccountView(${className?uncap_first},user);
            if (rs.isSuccess() == false) {
                results.put(RESPOND.RESULT, false);
                results.put(RESPOND.MESSAGE, rs.getResultMessage());
            } else {
                List<SysKeepAccountDetail> kadetailSet = new ArrayList<SysKeepAccountDetail>();
                List<SysKeepAccount> sysKeepList = (List<SysKeepAccount>) rs.getList();
                for (SysKeepAccount sysKeepAccount : sysKeepList) {
                    kadetailSet.addAll(sysKeepAccount.getKaDetailList());
                }
                String key = ReportFactory.saveReportData(kadetailSet);
                results.put(RESPOND.KEY, key);
                results.put(RESPOND.RESULT, true);

            }
        } catch (Exception e) {
            processExceptionIntoDB(methodName,${className?uncap_first}.get${pkname?lower_case?cap_first}(),Constant.OperateType.STRING_KEEPACCOUNT,e.getMessage(), e);
            results.put(RESPOND.RESULT, false);
            results.put(RESPOND.MESSAGE, e.getMessage());
        }
        return methodName;
    }
</#if>

    /**
    * ${table.comment!}流程操作页面跳转
    */
    public String ${className?uncap_first}Flow() {
        String methodName = "${className?uncap_first}Flow";
        info(methodName, "${table.comment!}流程操作页面跳转");
    <#if isNewFlow == "是">
        FlowProcess flowProcess = null;
    <#else>
        flowState = new FlowState();
    </#if>
        String url = "";
        try {
            ${className?uncap_first} = new ${className}();
            // 查询流程状态信息
    <#if isNewFlow == "是">
            WorkFlowInput workFlowInput = new WorkFlowInput(getSessionUserInfo().getUser().getUserid(), moduleid, linkid);
            flowProcess = taskFlowControlService.getFlowProcessForDeal(workFlowInput, false);
            url = flowProcess.getPageid();
            ${className?uncap_first} = ${className?uncap_first}Service.findById(linkid);
            url = url.substring(url.lastIndexOf("/") + 1, url.lastIndexOf("_"));
    <#else>
            flowState = getFlowStateByTaskId(taskId);
            url = flowState.getField1();
            // 查询业务数据
            ${className?uncap_first} = ${className?uncap_first}Service.findById(flowState.getLinkid());
    </#if>
            if(CommonUtil.isEmpty(${className?uncap_first}.getRtranuser())){
                ${className?uncap_first}.setRtranuser(user.getUser().getUserid());
                ${className?uncap_first}.setRtranname(user.getUser().getUsername());
                ${className?uncap_first}.setOrgid(user.getUser().getOrgid());
                ${className?uncap_first}.setOrgname(user.getOrgname());
            }
            // 流程信息转换
            transferFlowInfo<#if isNewFlow == "是">New</#if>(${className?uncap_first},<#if isNewFlow == "是">flowProcess<#else>flowState</#if>);

            format${className}ForPage(${className?uncap_first});
        } catch (ServiceException e) {
            // 异常处理，异常入库操作
            processExceptionIntoDB(methodName, ${className?uncap_first}.get${pkname?lower_case?cap_first}(),
            Constant.OperateType.STRING_FLOW_FORWARD, e.getMessage(), e);
        } catch (HibernateOptimisticLockingFailureException e) {
            // 异常处理，异常入库操作
            processExceptionIntoDB(methodName, ${className?uncap_first}.get${pkname?lower_case?cap_first}(),
            Constant.OperateType.STRING_REJECT, e.getMessage(), e);
        }
        return url;
    }
                    
                    
    public String rollBack${className}() {
        String methodName = "rollBack${className}";
        info(methodName, "退回${table.comment!}");
        // 当前登录用户机构号
        ${className?uncap_first}.setLoginOrgid(user.getUser().getOrgid());
        // 当前登录用户
        ${className?uncap_first}.setLoginUserid(user.getUser().getUserid());
        // 业务最后更新用户
        ${className?uncap_first}.setLoginUserid(user.getUser().getUserid());
        // 去掉实体中所有字段前后空格
        trimFieldForStr(${className?uncap_first});
        ResultData rstBiz = new ResultData();
        try {
            // 退回
            rstBiz = ${className?uncap_first}Service.rejectFlow(${className?uncap_first});
            // 记录日志
            writeOpLog(${className?uncap_first}.get${pkname?lower_case?cap_first}(), ${className?uncap_first}.getOwnedModuleid(),Constant.OperateType.STRING_REJECT);
            if (rstBiz.isSuccess()) {
                // 返回前台结果集
                results.put(Constant.RESPOND.RESULT, true);
                results.put( Constant.RESPOND.MESSAGE, MessageUtil.getMessage(MessageUtil.Message.TICM_MESSAGE_REJECT_SUCCESS));
            } else {
                // 返回前台结果集
                results.put(Constant.RESPOND.RESULT, false);
                results.put(Constant.RESPOND.MESSAGE,MessageUtil.getMessage(MessageUtil.Message.TICM_MESSAGE_REJECT_SUCCESS));
            }
        } catch (ServiceException e) {
            // 返回前台结果集
            results.put(Constant.RESPOND.RESULT, false);
            results.put(Constant.RESPOND.MESSAGE, e.getMessage());
            // 异常处理，异常入库操作
            processExceptionIntoDB(methodName, ${className?uncap_first}.get${pkname?lower_case?cap_first}(),
            Constant.OperateType.STRING_REJECT, e.getMessage(), e);
        } catch (HibernateOptimisticLockingFailureException e) {
            // 返回前台结果集
            results.put(Constant.RESPOND.RESULT, false);
            results.put(Constant.RESPOND.MESSAGE, MessageUtil
            .getMessage(MessageUtil.Message.OP_LOG_0002));
            // 异常处理，异常入库操作
            processExceptionIntoDB(methodName, ${className?uncap_first}.get${pkname?lower_case?cap_first}(),
            Constant.OperateType.STRING_REJECT, e.getMessage(), e);
        }
        return methodName;
    }

    public String find${className}OfPage() {
        String methodName = "find${className}OfPage";
        info(methodName, "查询${table.comment!}信息");
        if (pager == null) {
            pager = new Pager();
        }
        trimFieldForStr(${className?uncap_first});
        pager.setSort(sort);
        pager.setDirection(direction);
        // 设置：第一次从菜单栏点击默认是查询办理中的
        if (CommonUtil.isEmpty(${className?uncap_first})) {
            ${className?uncap_first} = new ${className}();
            ${className?uncap_first}.setEffectflag(Constant.EffectFlag.A);
            ${className?uncap_first}.setOrgid(user.getUser().getOrgid());
        }
        List<${className}> ${className?uncap_first}List = new ArrayList<${className}>();
        ResultData rs = new ResultData();

    <#if isNewFlow == "是">
        Map<String, FlowProcess> flowMap = new HashMap<String, FlowProcess>();
        WorkFlowInput workFlowInput = new WorkFlowInput(getSessionUserInfo().getUser().getUserid(), moduleid);
    <#else>
        ResultData flowResultData = new ResultData();
        Map<String, Object> flowMap = new HashMap<String, Object>();
    </#if>
        List<${className}Dto> dtoList = new ArrayList<${className}Dto>();

        String opt = Constant.OperateType.STRING_VIEW_LIST;
        try {
            if (CommonUtil.isEmpty(optype) || optype.equals(Constant.OptionType.DEAL)) {
        <#if isNewFlow == "是">
                flowMap = taskFlowControlService.pageForDeal(workFlowInput);
                List<?> linkids = new ArrayList<Object>(flowMap.keySet());
                if (CommonUtil.isNotEmpty(linkids)) {
                    rs = ${className?uncap_first}Service.find${className}OfPage(${className?uncap_first}, pager, optype,(List<String>) linkids);
                }
        <#else>
                flowResultData = getActiveFlowState();
                if (CommonUtil.isNotEmpty(flowResultData.getList())) {
                    rs = ${className?uncap_first}Service.find${className}OfPage(${className?uncap_first}, pager, optype,(List<String>) flowResultData.getList());
                }
        </#if>
            } else {
                rs = ${className?uncap_first}Service.find${className}OfPage(${className?uncap_first}, pager, optype, null);
        <#if isNewFlow == "是">
                flowMap = taskFlowControlService.pageForQuery(workFlowInput,
                                    (List<Object>) rs.getList(), "${pkname?lower_case}");
        <#else>
                flowResultData = getFlowStateByLinkIds(rs.getList(), "${pkname?lower_case}");
        </#if>
            }
            ${className?uncap_first}List = (List<${className}>) rs.getList();
        <#if isNewFlow == "是">
        <#else>
            flowMap = CommonUtil.isNotEmpty(flowResultData)&& flowResultData.isSuccess() ? (Map<String, Object>) flowResultData.getMap() : new HashMap<String, Object>();
        </#if>
            if (CommonUtil.isNotEmpty(${className?uncap_first}List)) {
                for (${className} ${className?uncap_first}Temp : ${className?uncap_first}List) {
                    ${className}Dto dto = new ${className}Dto();
                    BeanUtils.copyProperties(${className?uncap_first}Temp, dto);
                    // 流程信息赋值
                    transferFlowInfo<#if isNewFlow == "是">New</#if>(dto, flowMap, "${pkname?lower_case}");
                    dtoList.add(dto);
                }
            }
            pager = rs.getPager();
            results.put("pager.pageNo", pager.getPageNo());
            results.put("pager.totalRows", pager.getTotalRows());
            results.put("rows", dtoList);
            results.put("sort", sort);
            results.put("direction", direction);

            writeOpLog("", moduleid, opt);
        } catch (ServiceException e) {
            processExceptionIntoDB(methodName, "", opt, e.getMessage(), e);
        }
        return methodName;
    }

    public String delete${className}() {
        String methodName = "delete${className}";
        info(methodName, "删除${table.comment!}");

        UserInfo user = this.getSessionUserInfo();

        List<${className}> ${className?uncap_first}List = new ArrayList<${className}>();
        String strIds = request.getParameter("ids");
    <#if isNewFlow == "是">
        String moduleid = request.getParameter("moduleid");
    </#if>
        try {
            if (CommonUtil.isNotEmpty(strIds)) {
                String[] ids = strIds.split(",");
                for (String idstr : ids) {
                    if (CommonUtil.isNotEmpty(idstr)) {
                        String[] idsss = idstr.split("#");
                        if (CommonUtil.isNotEmpty(idsss) && idsss.length >= 2) {
                            ${className} ${className?uncap_first} = ${className?uncap_first}Service.findById(idsss[0]);
                            ${className?uncap_first}.setTaskId(idsss[1]);
                            ${className?uncap_first}.setLstmntdate(getTimestampNow());
                            ${className?uncap_first}.setLoginUserid(user.getUser().getUserid());
                            ${className?uncap_first}.setLstmntuser(user.getUser().getUserid());
                            ${className?uncap_first}.setEffectflag(Constant.EffectFlag.D);
                        <#if isNewFlow == "是">
                            // 设置：模块id
                            ${className?uncap_first}.setOwnedModuleid(moduleid);
                        </#if>
                            ${className?uncap_first}List.add(${className?uncap_first});
                        }
                    }
                }
                ${className?uncap_first}Service.delete${className}(${className?uncap_first}List);
            }
            // 记录日志
            writeOpLog(strIds, moduleid,Constant.OperateType.STRING_DELETE);
            results.put(RESPOND.RESULT, true);
        } catch (ServiceException e) {
            results.put(RESPOND.RESULT, false);
            results.put(RESPOND.MESSAGE, e.getMessage());
            processExceptionIntoDB(methodName, strIds,
            Constant.OperateType.STRING_DELETE, e.getMessage(), e);
        }
        return methodName;
    }

<#if isSafeFlow == "是">
    public String check${className}() {
        String methodName = "check${className}";
        info(methodName, "判断该条${table.comment!}是否在做维护.");
        List<${className}> list = null;
        if (CommonUtil.isEmpty(${className?uncap_first})
            || CommonUtil.isEmpty(${className?uncap_first}.getPlanid())) {
            results.put("res", false);
            results.put("message", "请选择一条数据 ");
            return methodName;
        }
        try {
            list = ${className?uncap_first}Service.find${className}A(${className?uncap_first});
            if (CommonUtil.isNotEmpty(list) && list.size() > 1) {
                results.put("res", false);
                results.put("message", "流水号[" + list.get(0).getSeqid()+ "]正在维护此记录");
            } else {
                results.put("res", true);
            }
        }catch (ServiceException e) {
            results.put("res", false);
            results.put("message", e.getMessage());
            processException(methodName, e.getMessage(), e);
        }
        return methodName;
    }

    public String safe${className}() {
        String methodName = "safe${className}";
        info(methodName, "初始化${table.comment!}维护页面.");
        try {
            ${className?uncap_first} = ${className?uncap_first}Service.findById(${className?uncap_first}.get${pkname?lower_case?cap_first}());
            format${className}ForPage(${className?uncap_first});
            ${className?uncap_first}.set${pkname?lower_case?cap_first}(null);
        }catch (ServiceException e) {
            processExceptionIntoDB(methodName, ${className?uncap_first}.get${pkname?lower_case?cap_first}(),
            Constant.OperateType.STRING_UPDATE, e.getMessage(), e);
        }
        return SUCCESS;
    }

    public String saveSafe${className}() {
        String methodName = "saveSafe${className}";
        info(methodName, "维护 保存${table.comment!}信息");

        UserInfo user = this.getSessionUserInfo();
        // 当前登录用户机构号
        ${className?uncap_first}.setLoginOrgid(user.getUser().getOrgid());
        // 当前登录用户
        ${className?uncap_first}.setLoginUserid(user.getUser().getUserid());
        // 当前操作用户
        ${className?uncap_first}.setTraUserid(user.getUser().getUserid());
        // 业务更新用户
        ${className?uncap_first}.setLstmntuser(user.getUser().getUserid());

        // 操作结果
        ResultData rs = new ResultData();
        try {
            if (CommonUtil.isNotEmpty(${className?uncap_first}.get${pkname?lower_case?cap_first}())) {
                opt = Constant.OperateType.STRING_UPDATE;
                // 编辑
                rs = ${className?uncap_first}Service.updateAndSubmit(${className?uncap_first}, false);
            } else {
                opt = Constant.OperateType.STRING_NEW;
                ${className?uncap_first}.setEffectflag(Constant.EffectFlag.A);
                ${className?uncap_first}.setCreateuser(this.getSessionUser().getUserid());
                // 新增
                rs = ${className?uncap_first}Service.saveSafeAndSubmit(${className?uncap_first}, false);
            }
            // 记录日志
            writeOpLog(${className?uncap_first}.get${pkname?lower_case?cap_first}() + "", moduleid, opt);
            if (rs.isSuccess()) {
                results.put("res", true);
            }else {
                results.put("res", false);
                results.put("message", rs.getResultMessage());
            }
        }
        catch (ServiceException e) {
            processExceptionIntoDB(methodName, ${className?uncap_first}.get${pkname?lower_case?cap_first}() + "",
            opt, e.getMessage(), e);
            results.put("res", false);
            results.put("message", e.getMessage());
        }
        catch (HibernateOptimisticLockingFailureException e) {
            processExceptionIntoDB(methodName, ${className?uncap_first}.get${pkname?lower_case?cap_first}() + "", opt, e.getMessage(), e);
            results.put("res", false);
            results.put("message", MessageUtil.getMessage(MessageUtil.Message.OP_LOG_0002));
        }
        return methodName;
    }

    public String submitSafe${className}() {
        String methodName = "submitSafe${className}";
        info(methodName, "维护 提交${table.comment!}信息");

        UserInfo user = this.getSessionUserInfo();
        // 当前登录用户机构号
        ${className?uncap_first}.setLoginOrgid(user.getUser().getOrgid());
        // 当前登录用户
        ${className?uncap_first}.setLoginUserid(user.getUser().getUserid());
        // 当前操作用户
        ${className?uncap_first}.setTraUserid(user.getUser().getUserid());
        // 业务更新用户
        ${className?uncap_first}.setLstmntuser(user.getUser().getUserid());

        // 操作结果
        ResultData rs = new ResultData();
        try {
            if (CommonUtil.isNotEmpty(${className?uncap_first}.get${pkname?lower_case?cap_first}())) {
            opt = Constant.OperateType.STRING_UPDATEANDSUBMIT;
            // 编辑
            rs = ${className?uncap_first}Service.updateAndSubmit(${className?uncap_first}, true);
            } else {
                opt = Constant.OperateType.STRING_UPDATEANDSUBMIT;
                ${className?uncap_first}.setEffectflag(Constant.EffectFlag.A);
                ${className?uncap_first}.setCreateuser(this.getSessionUser().getUserid());
                // 新增
                rs = ${className?uncap_first}Service.saveSafeAndSubmit(${className?uncap_first}, true);
            }
            // 记录日志
            writeOpLog(${className?uncap_first}.get${pkname?lower_case?cap_first}() + "", moduleid, opt);
            if (rs.isSuccess()) {
                results.put("res", true);
            }else {
                results.put("res", false);
                results.put("message", rs.getResultMessage());
            }
        }catch (ServiceException e) {
            processExceptionIntoDB(methodName, ${className?uncap_first}.get${pkname?lower_case?cap_first}() + "",
            opt, e.getMessage(), e);
            results.put("res", false);
            results.put("message", e.getMessage());
        }
        catch (HibernateOptimisticLockingFailureException e) {
            processExceptionIntoDB(methodName, ${className?uncap_first}.get${pkname?lower_case?cap_first}() + "", opt, e.getMessage(), e);
            results.put("res", false);
            results.put("message", MessageUtil.getMessage(MessageUtil.Message.OP_LOG_0002));
        }
        return methodName;
    }

</#if>
<#if subTable??>
    public String find${subClassName}List() {
        String methodName = "find${subClassName}List";
        info(methodName,"查询${subTable.comment!}信息");
        try {
            if(CommonUtil.isEmpty(${className?uncap_first}.get${pkname?lower_case?cap_first}())) {
                return methodName;
            }

            List<${subClassName}> ${subClassName?uncap_first}List
                    = ${className?uncap_first}Service.find${subClassName}List(${className?uncap_first});
            for(${subClassName} ${subClassName?uncap_first} : ${subClassName?uncap_first}List){

            }
            results.put("rows", ${subClassName?uncap_first}List);
        } catch (ServiceException e) {
            processException(methodName, e.getMessage(), e);
        }
        return methodName;
    }
</#if>
    /**
    * 格式化页面展示信息
    */
    private void format${className}ForPage(${className} ${className?uncap_first}){
                                
    }

    private void format${className}ForSave(${className} ${className?uncap_first}){
<#if subTable??>
        String ${subClassName?lower_case}gridStr = request.getParameter("${subClassName?lower_case}gridStr");
        List<${subClassName}> ${subClassName?uncap_first}List = new ArrayList<${subClassName}>();
        ${subClassName?uncap_first}List = JsonUtil.jsonToObjectList(${subClassName?lower_case}gridStr,${subClassName}.class);
        ${className?uncap_first}.set${subClassName}List(${subClassName?uncap_first}List);
</#if>
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
    public ${className} get${className}() {
        return ${className?uncap_first};
    }

    public void set${className}(${className} ${className?uncap_first}) {
        this.${className?uncap_first} = ${className?uncap_first};
    }
}