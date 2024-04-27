package com.joyin.ticm${packageName}.service;


import com.joyin.ticm.bean.ResultData;
import com.joyin.ticm${packageName}.model.${className};
import com.joyin.ticm.page.Pager;
import com.joyin.ticm.service.ServiceException;

import java.util.List;

/**
*
*  ${table.comment!}业务操作层接口
*/
public interface ${className}Service {
    /**
    * 查询${table.comment!}信息
    * @param ${className?uncap_first}
    * @param pager 分页信息
    * @return ResultData
    * @throws ServiceException
    */
    public ResultData find${className}OfPage(${className} ${className?uncap_first}, Pager pager) throws ServiceException;
    /**
    * 根据流水号查询债券借贷到期数据
    * @param ${pkname?lower_case} 主键
    * @return ${className} 到期交易
    * @throws ServiceException
    */
    public ${className} findById(Long ${pkname?lower_case}) throws ServiceException;

    /**
    * 删除${table.comment!}
    * @param ${className?uncap_first}List ${table.comment!}list
    * @return ResultData
    * @throws ServiceException
    */
    public ResultData delete${className}(List<${className}> ${className?uncap_first}List)throws ServiceException;

    void saveOrUpdate(${className} ${className?uncap_first}) throws ServiceException;

    public List<${className}> find${className}(${className} ${className?uncap_first}) throws ServiceException;
}
