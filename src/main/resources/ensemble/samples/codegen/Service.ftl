package com.joyin.ticm${packageName}.service;


import java.util.List;

import com.joyin.ticm.bean.ResultData;
import com.joyin.ticm.page.Pager;
import com.joyin.ticm.service.ServiceException;
import com.joyin.ticm${packageName}.model.${className};
import com.joyin.ticm.sysmn.user.model.UserInfo;

/**
*
* @Description  ${table.comment!}业务操作层接口
*/
public interface ${className}Service {
    /**
    * @Description 保存${table.comment!}
    * @param ${className?uncap_first} ${table.comment!}
    * @param isSubmit 是否提交
    * @return ResultData
    * @throws ServiceException
    */
    public ResultData saveAndSubmit(${className} ${className?uncap_first}, boolean isSubmit)throws ServiceException;
    /**
    * @Description 更新${table.comment!}
    * @param ${className?uncap_first} ${table.comment!}
    * @param isSubmit 是否提交
    * @return ResultData
    * @throws ServiceException
    */
    public ResultData updateAndSubmit(${className} ${className?uncap_first}, boolean isSubmit)throws ServiceException;
    /**
    * @Description 查询${table.comment!}信息
    * @param ${className?uncap_first}
    * @param pager 分页信息
    * @param optype 操作类型
    * @param ${className?uncap_first}Reqids  办理数据编号
    * @return ResultData
    * @throws ServiceException
    */
    public ResultData find${className}OfPage(${className} ${className?uncap_first}, Pager pager,String optype, List<String> ${className?uncap_first}Seqids) throws ServiceException;
    /**
    * @Description 根据流水号查询债券借贷到期数据
    * @param seqid 流水号
    * @return ${className} 到期交易
    * @throws ServiceException
    */
    public ${className} findById(String seqid) throws ServiceException;

    /**
    * @Description 删除${table.comment!}
    * @param ${className?uncap_first}List ${table.comment!}list
    * @return ResultData
    * @throws ServiceException
    */
    public ResultData delete${className}(List<${className}> ${className?uncap_first}List)throws ServiceException;
    /**
    * @Description 账务预览
    * @param ${className?uncap_first} ${table.comment!}
    * @param userInfo 当前登录用户信息
    * @return ResultData
    * @throws Exception
    */
    public ResultData saveAccountView(${className} ${className?uncap_first}, UserInfo userInfo)throws Exception;
    /**
    * @Description ${table.comment!}复核退回
    * @param ${className?uncap_first} 到期交易
    * @throws ServiceException
    */
    public ResultData rejectFlow(${className} ${className?uncap_first}) throws ServiceException;
    /**
    * @Description 回滚业务数据
    * @param businessNo
    * @return ResultData
    * @throws ServiceException
    */
    public ResultData rubAccountByBusinessNo(String businessNo) throws ServiceException;
}
