package com.joyin.ticm${packageName}.action;

import com.joyin.ticm.bean.ResultData;
import com.joyin.ticm.common.constant.Constant;
import com.joyin.ticm.common.constant.Constant.RESPOND;
import com.joyin.ticm.common.util.CommonUtil;
import com.joyin.ticm.common.util.MessageUtil;
import com.joyin.ticm${packageName}.model.${className};
import com.joyin.ticm${packageName}.service.${className}Service;
import com.joyin.ticm.page.Pager;
import com.joyin.ticm.service.ServiceException;
import com.joyin.ticm.sysmn.user.model.UserInfo;
import com.joyin.ticm.web.action.ActionBase;
import com.joyin.ticm.workflow.model.FlowState;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import javax.annotation.Resource;
import java.util.*;


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

        ${className?uncap_first}.setOrgid(user.getUser().getOrgid());
        ${className?uncap_first}.setOrgname(user.getOrgname());

        return SUCCESS;
    }

    public String init${className}Edit() {
        String methodName = "init${className}Edit";
        info(methodName, "初始化${table.comment!}编辑页面.");
        try {
            ${className?uncap_first} = ${className?uncap_first}Service.findById(${className?uncap_first}.get${pkname?lower_case?cap_first}());
            format${className}ForPage(${className?uncap_first});
        }catch (ServiceException e) {
            processExceptionIntoDB(methodName, ${className?uncap_first}.get${pkname?lower_case?cap_first}().toString(),
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
            processExceptionIntoDB(methodName, ${className?uncap_first}.get${pkname?lower_case?cap_first}().toString(),
            Constant.OperateType.STRING_VIEW, e.getMessage(), e);
        }
        return SUCCESS;
    }

    public String save${className}() {
        String methodName = "save${className}";
        info(methodName, "保存${table.comment!}");
        UserInfo user = this.getSessionUserInfo();
        // 业务更新用户
        ${className?uncap_first}.setLstmntuser(user.getUser().getUserid());
        // 去掉实体中所有字段前后空格
        trimFieldForStr(${className?uncap_first});
        try {

            List<${className}> ${className?uncap_first}s = ${className?uncap_first}Service.find${className}(${className?uncap_first});
            if(CommonUtil.isNotEmpty(${className?uncap_first}s)) {
                results.put(Constant.RESPOND.RESULT, false);
                results.put(Constant.RESPOND.MESSAGE, "该类型门槛金额已设置");
                return methodName;
            }

            format${className}ForSave(${className?uncap_first});
            if (CommonUtil.isNotEmpty(${className?uncap_first}.get${pkname?lower_case?cap_first}())) {
                ${className?uncap_first}Service.saveOrUpdate(${className?uncap_first});

                writeOpLog(${className?uncap_first}.get${pkname?lower_case?cap_first}().toString(),moduleid,Constant.OperateType.STRING_UPDATE);
            } else {
                ${className?uncap_first}.setEffectflag(Constant.EffectFlag.E);
                ${className?uncap_first}Service.saveOrUpdate(${className?uncap_first});

                writeOpLog(${className?uncap_first}.get${pkname?lower_case?cap_first}().toString(),moduleid,Constant.OperateType.STRING_NEW);
            }
            results.put(Constant.RESPOND.RESULT, true);
        }  catch (ServiceException e) {
            results.put(Constant.RESPOND.RESULT, false);
            results.put(Constant.RESPOND.MESSAGE, MessageUtil.getMessage(MessageUtil.Message.OP_LOG_0002));
            processExceptionIntoDB(methodName, ${className?uncap_first}.get${pkname?lower_case?cap_first}().toString(),Constant.OperateType.STRING_UPDATE, e.getMessage(), e);
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
            ${className?uncap_first}.setEffectflag(Constant.EffectFlag.E);
            ${className?uncap_first}.setOrgid(user.getUser().getOrgid());
        }
        List<${className}> ${className?uncap_first}List = new ArrayList<${className}>();
        ResultData rs = new ResultData();
        ResultData flowResultData = new ResultData();
        Map<String, Object> flowMap = new HashMap<String, Object>();

        String opt = Constant.OperateType.STRING_VIEW_LIST;
        try {
            rs = ${className?uncap_first}Service.find${className}OfPage(${className?uncap_first}, pager);
            if(CommonUtil.isNotEmpty(rs.getList())) {
                ${className?uncap_first}List = (List<${className}>) rs.getList();
                for (${className} approvel : ${className?uncap_first}List) {
                    approvel.setBusisubtype(this.getDictName(approvel.getBusisubtype(), approvel.getBusitype()));
                    approvel.setBusitype(this.getDictName(approvel.getBusitype(), "APPROVALTYPE"));
                }
            }

            pager = rs.getPager();
            results.put("pager.pageNo", pager.getPageNo());
            results.put("pager.totalRows", pager.getTotalRows());
            results.put("rows", ${className?uncap_first}List);
            results.put("sort", sort);
            results.put("direction", direction);

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
        try {
            if (CommonUtil.isNotEmpty(strIds)) {
                String[] ids = strIds.split(",");
                for (String idstr : ids) {
                    if (CommonUtil.isNotEmpty(idstr)) {
                        ${className} ${className?uncap_first} = ${className?uncap_first}Service.findById(Long.valueOf(idstr));
                        ${className?uncap_first}.setLstmntdate(getTimestampNow());
                        ${className?uncap_first}.setLstmntuser(user.getUser().getUserid());
                        ${className?uncap_first}.setEffectflag(Constant.EffectFlag.D);
                        ${className?uncap_first}List.add(${className?uncap_first});
                    }
                }
                ${className?uncap_first}Service.delete${className}(${className?uncap_first}List);
            }
            results.put(RESPOND.RESULT, true);
        } catch (ServiceException e) {
            results.put(RESPOND.RESULT, false);
            results.put(RESPOND.MESSAGE, e.getMessage());
            processExceptionIntoDB(methodName, strIds,
            Constant.OperateType.STRING_DELETE, e.getMessage(), e);
        }
        return methodName;
    }

    /**
    * 格式化页面展示信息
    */
    private void format${className}ForPage(${className} ${className?uncap_first}){
                                
    }

    private void format${className}ForSave(${className} ${className?uncap_first}){
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