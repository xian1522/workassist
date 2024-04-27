package com.joyin.ticm${packageName}.service;

import java.util.Date;

import com.joyin.ticm.batch.comm.BatchPara;
import com.joyin.ticm.bean.ResultData;
import com.joyin.ticm.page.Pager;
import com.joyin.ticm.service.ServiceException;
import com.joyin.ticm${packageName}.model.${className};
import com.joyin.ticm${packageName}.model.${subClassName};
import com.joyin.ticm.sysmn.user.model.UserInfo;
/**
 * @Description: ${table.comment!}service
 */
public interface ${className}Service {
	/**
	 * @Description: 查询机构最新计提汇总信息
	 * @param orgid 机构号
	 * @return ${className}  
	 * @throws ServiceException  
	 */
	public ${className} findLast${className}(String orgid)throws ServiceException;
	/**
	 * @Description: ${table.comment!}信息查询
	 * @param ${subClassName?uncap_first} ${table.comment!}明细
	 * @param pager 分页对象
	 * @return ResultData  
	 * @throws ServiceException 
	 */
	public ResultData find${className}OfPage(${subClassName} ${subClassName?uncap_first}, Pager pager)throws ServiceException;
	/**
	 * @Description:  ${table.comment!}试运行
	 * @param orgid 机构号
	 * @param orgname 机构名称
	 * @param userid 用户id
	 * @param lstdrawdate 上次计提日期
	 * @param drawdate 本次计提日期
	 * @return ResultData  
	 * @throws ServiceException  
	 */
	public ResultData saveRunTest(String orgid, String orgname, UserInfo user,
			Date lstdrawdate, Date drawdate) throws ServiceException;
	/**
	* @Description: 根据流水号查询计提明细
	* @param seqno 计提明细流水号
	* @return ${subClassName} 计提明细
	* @throws ServiceException
	 */
	public ${subClassName} find${subClassName}ById(Long seqno)throws ServiceException;
	/**
	* @Description: 保存计提明细
	* @param ${subClassName?uncap_first} 计提明细
	* @throws ServiceException
	 */
	public ResultData update${subClassName}(${subClassName} ${subClassName?uncap_first})throws ServiceException;
	/**
	* @Description: 删除计提明细
	* @param seqno 明细流水号
	* @throws ServiceException  
	 */
	public void delete${subClassName}(Long seqno) throws ServiceException;
	/**
	* @Description: 计提
	* @param loginOrgid 计提机构号
	* @param loginUserid 计提账号
	* @throws ServiceException  
	 */
	public ResultData saveRunCount(String loginOrgid, String loginUserid)throws ServiceException;
	/**
	* @Description ${table.comment!}批处理
	* @param batchPara 批处理参数
	* @return ResultData
	* @throws ServiceException
	 */
	public ResultData save${className}RunBatch(BatchPara batchPara)throws ServiceException;
	
	/**
	* @Description 数据回滚
	* @param businessNo 业务编号
	* @return ResultData
	* @throws ServiceException  
	 */
    public ResultData rubAccountByBusinessNo(String businessNo) throws ServiceException; 
}
