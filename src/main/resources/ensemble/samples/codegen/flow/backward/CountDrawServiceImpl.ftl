
package com.joyin.ticm${packageName}.service.impl;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import com.joyin.ticm.accmn.kaconfig.service.KaConfigService;
import com.joyin.ticm.accmn.kamn.kacomm.KaConstant;
import com.joyin.ticm.accmn.kamn.model.SysKeepAccount;
import com.joyin.ticm.accmn.kamn.service.KeepAccountService;
import com.joyin.ticm.batch.comm.BatchPara;
import com.joyin.ticm.bean.ResultData;
import com.joyin.ticm.common.constant.Constant;
import com.joyin.ticm.common.constant.Constant.EffectFlag;
import com.joyin.ticm.common.constant.Constant.StringValue;
import com.joyin.ticm.common.enums.BizParamEnum;
import com.joyin.ticm.common.util.CommCal;
import com.joyin.ticm.common.util.CommonUtil;
import com.joyin.ticm.common.util.DateUtils;
import com.joyin.ticm.dao.BaseDao;
import com.joyin.ticm.dao.DaoException;
import com.joyin.ticm.exception.TicmException;
import com.joyin.ticm.ka${packageName?substring(0, packageName?last_index_of("."))}.${className}KeepAccount;
import com.joyin.ticm.ka.util.KeepAccountUtils;
import com.joyin.ticm.page.Pager;
import com.joyin.ticm.service.ServiceBase;
import com.joyin.ticm.service.ServiceException;
import com.joyin.ticm${packageName}.dao.${className}Dao;
import com.joyin.ticm${packageName}.model.${className};
import com.joyin.ticm${packageName}.model.${subClassName};
import com.joyin.ticm${packageName}.service.${className}Service;
import com.joyin.ticm.sysmn.config.model.SysParameter;
import com.joyin.ticm.sysmn.config.service.SysParameterService;
import com.joyin.ticm.sysmn.organ.model.Organ;
import com.joyin.ticm.sysmn.organ.service.OrganService;
import com.joyin.ticm.sysmn.user.model.User;
import com.joyin.ticm.sysmn.user.model.UserInfo;
import com.joyintech.config.env.EnvConfig;
/**
 * @Description: ${table.comment!}实现类
 */
/**
 * @author Administrator
 *
 */
@Service("${className?uncap_first}Service")
public class ${className}ServiceImpl extends ServiceBase implements ${className}Service{
	@Resource
	private ${className}Dao ${className?uncap_first}Dao;
	@Resource
	private SysParameterService sysParameterService;
	@Resource
	private BaseDao baseDao;
	@Resource
	private KaConfigService kaConfigService;
	@Resource
	private KeepAccountService keepAccountService;
	@Resource
	private OrganService organService;
	/**
	 * @Description: 查询机构最新计提汇总信息
	 * @param orgid 机构号
	 * @return ${className}  
	 * @throws ServiceException  
	 */
	@Override
	public ${className} findLast${className}(String orgid)
			throws ServiceException {
		String methodName = "findLast${className}";
		info(methodName, "param[orgid]" + orgid);
		${className} ${className?uncap_first} = new ${className}();
		try {
			${className?uncap_first} = ${className?uncap_first}Dao.findLast${className}(orgid);
		} catch (DaoException e) {
			processException(methodName, e.getMessage(), e);
		}
		return ${className?uncap_first};
	}
	/**
	 * @Description: ${table.comment!}信息查询
	 * @param ${subClassName?uncap_first} ${table.comment!}明细
	 * @param pager 分页对象
	 * @return ResultData  
	 * @throws ServiceException 
	 */
	@Override
	public ResultData find${className}OfPage(
			${subClassName} ${subClassName?uncap_first}, Pager pager)
			throws ServiceException {
		String methodName = "find${className}OfPage ";
		info(methodName, "查询${table.comment!}信息" + ",params[${subClassName?uncap_first}]="
				+ ${subClassName?uncap_first} + ",[pager]=" + pager);
		ResultData rs = new ResultData();
		if (CommonUtil.isEmpty(pager)) {
			rs.setSuccess(false);
			rs.setResultMessage("分页参数错误");
			return rs;
		}
		if (CommonUtil.isEmpty(${subClassName?uncap_first})) {
			rs.setSuccess(false);
			rs.setResultMessage("查询参数错误");
			return rs;
		}

		try {
			rs = ${className?uncap_first}Dao.find${className}OfPage(
					${subClassName?uncap_first}, pager);
		} catch (DaoException e) {
			throw processException(methodName, e.getMessage(), e);
		}
		return rs;
	}
	/**
	 * @Description ${table.comment!}试运行
	 * @param orgid 机构号
	 * @param orgname 机构名称
	 * @param user 用户
	 * @param lstdrawdate 上次计提日期
	 * @param drawdate 本次计提日期
	 * @return ResultData  
	 * @throws ServiceException  
	 */
	public ResultData saveRunTest(String orgid, String orgname, UserInfo user,
			Date lstdrawdate, Date drawdate) throws ServiceException {
		String methodName = "saveRunTest";
		info(methodName, "params[orgid,orgname,userid,lstdrawdate,drawdate]: "
				+ orgid + "," + orgname + "," + user + "," + lstdrawdate
				+ "," + drawdate);
		// 定义返回信息
		ResultData rst = new ResultData();

		// 汇总
		${className} countDraw = new ${className}();
		// 明细
		List<${subClassName}> details = new ArrayList<${subClassName}>();
		User userinfo = user.getUser();
		try {
			// 删除计提试运行数据
			${className?uncap_first}Dao.deleteCountDraw(orgid);

			// 获取汇总数据
			countDraw = getCountDraw(orgid, orgname, userinfo.getUserid(), lstdrawdate,
					drawdate);
			// 获取明细数据
			details = getCountDrawDetail(orgid, drawdate,userinfo.getUserid(),userinfo.getUsername());

			// 保存计提汇总和明细
			saveCountDraw(countDraw, details, EffectFlag.A);
		} catch (DaoException ex) {
			String msg = "删除计提汇总及明细错误";
			throw processException(methodName + msg, ex.getMessage(), ex);
		} catch (TicmException ex) {
			String msg = "获取计提明细错误";
			throw processException(methodName + msg, ex.getMessage(), ex);
		}

		// 成功
		rst.setSuccess(true);
		rst.setObject(countDraw);
		return rst;
	}
	/**
	* @Description: 组装汇总数据
	* @param orgid 机构号
	* @param orgname 机构名称
	* @param userid 登录用户
	* @param lstDrawDate 上次计提日期 
	* @param drawDate 本次计提日期
	* @return ${className} ${table.comment!}汇总实体
	* @throws
	 */
	private ${className} getCountDraw(String orgid, String orgname,
			String userid, Date lstDrawDate, Date drawDate) {
		${className} countDraw = new ${className}();

		// 机构编号
		countDraw.setOrgid(orgid);
		// 机构名称
		countDraw.setOrgname(orgname);
		// 上次计提日期
		countDraw.setLstdrawdate(lstDrawDate);
		// 计提日期
		countDraw.setDrawdate(drawDate);
		// 更新人员
		countDraw.setLstmntuser(userid);

		return countDraw;
	}
	/**
	* @Description: 组装计提明细信息
	* @param orgid 机构号
	* @param drawDate 计提日期
	* @return List<IssuebCountDrawDetail> 计提明细list
	* @throws ServiceException
	* @throws DaoException  
	 */
	private List<${subClassName}> getCountDrawDetail(String orgid,
			Date drawDate, String userid, String username) throws ServiceException, DaoException {

		List<SlDeal> dealList = new ArrayList<SlDeal>();

		//查询符合条件的债券借贷交易
		dealList = ${className?uncap_first}Dao.findSlDealForCountDraw(orgid,
				drawDate);

		// 本次计提明细
		List<${subClassName}> list = new ArrayList<${subClassName}>();

		// 记账摘要
		String accremark = KeepAccountUtils.getCountDrawAccRemark(
				BizParamEnum.SL, drawDate);

		for (SlDeal deal : dealList) {
			// 获取计提明细数据
			${subClassName} ${subClassName?uncap_first} = getCountDrawDetailForOne(
					orgid, deal, drawDate, accremark, userid, username);
			if (CommonUtil.isNotEmpty(${subClassName?uncap_first})) {
				// 计提额不为零则添加明细
				if ((CommonUtil.isNotEmpty(${subClassName?uncap_first}.getIntamt()) && BigDecimal.ZERO
						.compareTo(${subClassName?uncap_first}.getIntamt()) != 0)) {
					list.add(${subClassName?uncap_first});
				}
			}
		}

		return list;
	}
	/**
	* @Description: 组装计提明细数据
	* @param orgid 机构号
	* @param slDeal 债券借贷交易
	* @param drawDate 计提日期
	* @param accremark 记账摘要
	* @return ${subClassName} 计提明细
	* @throws DaoException
	 */
	private ${subClassName} getCountDrawDetailForOne(String orgid, SlDeal slDeal, Date drawdate, String accremark,String userid, String username) throws DaoException,ServiceException{
		String methodName="getCountDrawDetailForOne";
		String message="组装计提明细数据 ";
		String reqid = slDeal.getReqid();
		${subClassName} lst${subClassName} = ${className?uncap_first}Dao
									.findLast${subClassName}(orgid, reqid);
		//期初应收付利息余额
		BigDecimal sintamt = BigDecimal.ZERO;
		//应收、付利息余额 
		BigDecimal totalintamt = BigDecimal.ZERO;
		//上次计提结束日期
		Date intstartdate = null;
		if(CommonUtil.isNotEmpty(lst${subClassName})){
			sintamt = lst${subClassName}.getTotalintamt();
			intstartdate = lst${subClassName}.getIntenddte();
		}
		${subClassName} ${subClassName?uncap_first} = new ${subClassName}();
		${subClassName?uncap_first}.setOrgid(orgid); //机构号
		Date cdstartdate=null;
		Date cdenddate=null;
		if(Constant.COUNT_DRAW_FLAG.COUNT_DRAW_FLAG_B.equals(EnvConfig.getInstance().getCountdrawflag())){
			//首次结算日期
		    cdstartdate = slDeal.getVdate();
			//做过计提取计提结束日期，无计提取交易起息日
			Date startDate = null;
			if(CommonUtil.isEmpty(intstartdate)){
				startDate = cdstartdate;
			}else{
				//计息起始日 = 上次计息结束日+1
				intstartdate = DateUtils.addDate(intstartdate, 1); 
				startDate = intstartdate;
			}
			//计提结束日期
			cdenddate =CommCal.mathCountDrawMdate(slDeal.getMdate(), drawdate);
			${subClassName?uncap_first}.setIntstrtdte(startDate);//计息开始日期
			${subClassName?uncap_first}.setIntenddte(cdenddate); //计算结束日期
			${subClassName?uncap_first}.setSintamt(sintamt);//期初应收付利息余额
		}else{
			cdstartdate = CommCal.mathCountDrawVdateNew(slDeal.getVdate(), intstartdate,null);
			cdenddate =CommCal.mathCountDrawMdateNew(slDeal.getMdate(), drawdate);
			${subClassName?uncap_first}.setIntstrtdte(cdstartdate);//计息开始日期
			${subClassName?uncap_first}.setIntenddte(DateUtils.addDate(cdenddate, 1)); //计算结束日期
			${subClassName?uncap_first}.setSintamt(sintamt);//期初应收付利息余额
			if(cdstartdate.compareTo(cdenddate) >0){//过滤
				${subClassName?uncap_first}.setIntamt(null);
				return ${subClassName?uncap_first};
			}
		}
		//期末应计利息余额
		try {
			totalintamt = CommCal.
						countRegInterestDef(DateUtils.formatDateString(slDeal.getVdate()), DateUtils.formatDateString(cdenddate), slDeal.getTotalamt(), slDeal.getSlrate(), slDeal.getBasis());
		} catch (ParseException e) {
			throw processException(methodName, message, e);
		}
		BigDecimal intamt = totalintamt.subtract(sintamt);
		${subClassName?uncap_first}.setIntamt(intamt); //应收付利息计提额
		// 应收、付利息余额 
		${subClassName?uncap_first}.setTotalintamt(totalintamt);
		//记账摘要
		${subClassName?uncap_first}.setAccremark(accremark);
		${subClassName?uncap_first}.setRtranuser(userid); //经办柜员号
		${subClassName?uncap_first}.setRtranname(username); //经办柜员名称
		return ${subClassName?uncap_first};
	}
	
	/**
	* @Description: 保存计提汇总及明细
	* @param issuebCountDraw 计提汇总信息
	* @param details 计提明细信息
	* @param effectflag 有效状态 A:试运行，E:计提
	* @throws ServiceException  
	 */
	private void saveCountDraw(${className} ${className?uncap_first},
			List<${subClassName}> details, String effectflag)
		throws ServiceException {
		String methodName = "saveCountDraw";
		info(methodName, "param[${className?uncap_first}]: " + ${className?uncap_first});

		try {
			// 计提明细不为空，则保存汇总和明细数据
			if (CommonUtil.isNotEmpty(details) && details.size() > 0) {
				${className?uncap_first}.setEffectflag(effectflag);
				baseDao.save(${className?uncap_first});

				for (${subClassName} detail : details) {
					detail.setEffectflag(effectflag);
					detail.set${pkname?lower_case?cap_first}(${className?uncap_first}.get${pkname?lower_case?cap_first}());
					baseDao.save(detail);
				}
			}
		} catch (DaoException ex) {
			String msg = "保存计提汇总及明细错误";
			throw processException(methodName + msg, ex.getMessage(), ex);
		}
	}
	/**
	* @Description: 根据流水号查询计提明细
	* @param seqno 计提明细流水号
	* @return ${subClassName} 计提明细
	* @throws ServiceException
	 */
	@Override
	public ${subClassName} find${subClassName}ById(Long seqno)
			throws ServiceException {
		String methodName = "findIssuebCountDrawDetailById";
		info(methodName, "param[seqno]" + seqno);
		${subClassName} ${subClassName?uncap_first} = new ${subClassName}();
		try {
			${subClassName?uncap_first} = ${className?uncap_first}Dao.find${subClassName}ById(seqno);
		} catch (DaoException e) {
			processException(methodName, e.getMessage(), e);
		}
		return ${subClassName?uncap_first};
	}
	/**
	* @Description: 保存计提明细
	* @param ${subClassName?uncap_first} 计提明细
	* @throws ServiceException
	 */
	@Override
	public ResultData update${subClassName}(
			${subClassName} ${subClassName?uncap_first}) throws ServiceException {
		String methodName = "update${subClassName}";
		info(methodName, "param[${subClassName?uncap_first}]: "
				+ ${subClassName?uncap_first});

		ResultData rst = new ResultData();

		try {
			// 更新数据
			baseDao.update(${subClassName?uncap_first});
			rst.setSuccess(true);
			return rst;
		} catch (DaoException ex) {
			String msg = "修改计提明细错误.";
			throw processException(methodName + msg, ex.getMessage(), ex);
		}
	}
	/**
	* @Description: 删除计提明细
	* @param seqno 明细流水号
	* @throws ServiceException  
	 */
	@Override
	public void delete${subClassName}(Long seqno) throws ServiceException {
		String methodName = "delete${subClassName}";
		info(methodName, "param[seqno]: " + seqno);
		try {
			baseDao.deleteById(${subClassName}.class, seqno);
		} catch (DaoException ex) {
			throw processException(methodName, ex.getMessage(), ex);
		}
	}
	/**
	* @Description: 计提
	* @param loginOrgid 计提机构号
	* @param loginUserid 计提账号
	* @throws ServiceException  
	 */
	@Override
	public ResultData saveRunCount(String orgid, String userid)
			throws ServiceException {
		String methodName = "saveRunCount";
		info(methodName, "params[orgid,userid]: " + orgid + "," + userid);
		// 定义返回信息
		ResultData rst = new ResultData();
		${className} ${className?uncap_first} = new ${className}();

		try {
			// 查询本机构最新待计提汇总信息
			${className?uncap_first} = ${className?uncap_first}Dao.findCountDrawForCount(orgid);

			if (CommonUtil.isEmpty(${className?uncap_first})) {
				throw new ServiceException(ServiceException.DATE_NOT_FOUNT,
						"没有可计提数据");
			}

			// 系统平台时间
			SysParameter sysParameter = sysParameterService
					.findByParacode(Constant.SysParamter.SYSTEM_TIME);
			Date currentDate = DateUtils.parseDay(sysParameter.getParavalue());
			Date drawdate = ${className?uncap_first}.getDrawdate();
			// 验证计提日和平台时间
			if (currentDate.getTime() < drawdate.getTime()) {
				throw new ServiceException(
						ServiceException.ERROR_DATA_EXCEPTION, "计提日期"
								+ DateUtils.formatDateString(drawdate)
								+ "不能大于系统平台时间");
			}

			// 根据计提汇总表id查询明细信息
			List<${subClassName}> details = ${className?uncap_first}Dao
					.find${subClassName}ForCount(${className?uncap_first}
							.get${pkname?lower_case?cap_first}(), Constant.EffectFlag.A);

			if (CommonUtil.isEmpty(details)) {
				throw new ServiceException(ServiceException.DATE_NOT_FOUNT,
						"没有可计提明细数据");
			}

			// 保存计提汇总数据
			${className?uncap_first}.setEffectflag(EffectFlag.E);
			${className?uncap_first}.setLstmntuser(userid);
			baseDao.update(${className?uncap_first});

			// 保存计提明细数据
			for (${subClassName} detail : details) {
				detail.setEffectflag(EffectFlag.E);
				baseDao.update(detail);
				
	            //add majx 2017-11-30 计提更新下每日信息表,做下抹账的控制,只更新opertype字段,其他不更新
				TradeDaliy etradeDaliyTemp=tradeDaliyService.findTradeDaliy(detail.getReqid() ,null);
				if(CommonUtil.isNotEmpty(etradeDaliyTemp)){
					// 插入历史表
					TradeDaliyHistory tradeHis = new TradeDaliyHistory();

					BeanUtils.copyProperties(etradeDaliyTemp, tradeHis);

					baseDao.save(tradeHis);
					
					etradeDaliyTemp.setOpertype(Constant.OPERTYPE.OPERTYPE_18);
					etradeDaliyTemp.setSellseqid(${className?uncap_first}.get${pkname?lower_case?cap_first}().toString());
					baseDao.update(etradeDaliyTemp);
				}
				//end
			}

			// 记账
			ResultData rd = keepAccount(${className?uncap_first}, details,StringValue.ZERO, "");
			if (rd.isSuccess() == false) {
				throw new ServiceException(
						ServiceException.SYS_KEEPACCOUNT_EXCEPTION, rd
								.getMessageCode());
			}

			// 成功
			rst.setSuccess(true);
			rst.setObject(${className?uncap_first});

		} catch (DaoException ex) {
			String msg = "计提汇总及明细错误";
			throw processException(methodName + msg, ex.getMessage(), ex);
		} catch (ServiceException e) {
			throw e;
		}
		return rst;
	}
	
	/**
	* @Description 计提记账
	* @param ${className?uncap_first}
	* @param details
	* @param isBatch
	* @param opttype
	* @return
	* @throws ServiceException  
	* ResultData
	* @throws
	 */
	private ResultData keepAccount(${className} ${className?uncap_first},
			List<${subClassName}> details,
			String isBatch, String opttype) throws ServiceException {
		String methodName = "keepAccount";
		info(methodName, "params[${className?uncap_first}]" + ${className?uncap_first});

		${className}KeepAccount countDrawKa = new ${className}KeepAccount();

		try {
			// 会计分录
			SysKeepAccount aje = countDrawKa.getSysKeepAccount(kaConfigService,
					${className?uncap_first}, details, isBatch,
					opttype);
			// 调用创建方法进行记账
			ResultData rd = keepAccountService.createLocal(aje,
					KaConstant.VIEW.NOT_VIEW);
			return rd;
		} catch (ServiceException e) {
			throw e;
		}

	}
	/**
	* @Description ${table.comment!}批处理
	* @param batchPara 批处理参数
	* @return ResultData
	* @throws ServiceException
	 */
	@Override
	public ResultData save${className}RunBatch(BatchPara batchPara)
			throws ServiceException {
		String methodName = "save${className}RunBatch";
		info(methodName, "params[batchPara]: " + batchPara);
		// 定义返回信息
		ResultData rst = new ResultData();
		try {

			// 如果传入的日期和计提频率的日期不一致则结束否则继续跑批
			Date cddate;
			cddate = getBusinessCdDate(BizParamEnum.SL, batchPara
					.getCdate());
			if (CommonUtil.isNotEmpty(cddate)) {
				if (batchPara.getCdate().compareTo(cddate) != 0) {
					// 非计提日
					rst.setSuccess(true);
					return rst;
				}
			} else {
				rst.setSuccess(true);
				return rst;
			}

			// 查询所有机构
			List<Organ> organList = organService.getAllOrgans();

			for (Organ organ : organList) {
				// 汇总
				${className} countDraw = new ${className}();
				// 明细
				List<${subClassName}> details = new ArrayList<${subClassName}>();

				// 查询机构上次计提日期
				Date lastDrawDate = null;
				${className} last${className} = ${className?uncap_first}Dao
						.findLast${className}(organ.getOrgid());
				if (CommonUtil.isNotEmpty(last${className})) {
					lastDrawDate = last${className}.getDrawdate();
				}

				// 删除计提试运行数据
				${className?uncap_first}Dao.deleteCountDraw(organ.getOrgid());

				// 获取汇总数据
				countDraw = getCountDraw(organ.getOrgid(), organ.getOrgname(),
						batchPara.getUserid(), lastDrawDate, batchPara
								.getCdate());
				User user = baseDao.findById(User.class, batchPara.getUserid());
				// 获取明细数据
				details = getCountDrawDetail(organ.getOrgid(), batchPara
						.getCdate(),batchPara.getUserid(),user.getUsername());

				// 计提明细为空则不计提
				if (CommonUtil.isEmpty(details) || details.size() == 0) {
					continue;
				}

				// 保存计提汇总数据
				countDraw.setEffectflag(EffectFlag.E);
				baseDao.save(countDraw);


				// 保存计提明细数据
				for (${subClassName} detail : details) {
					detail.setEffectflag(EffectFlag.E);
					detail.set${pkname?lower_case?cap_first}(countDraw.get${pkname?lower_case?cap_first}());
					baseDao.save(detail);
				}

				rst = keepAccount(countDraw, details,StringValue.ONE, batchPara.getOpttype());

				// 判断记账是否成功
				if (rst.isSuccess()) {

				}

			}

			// 成功
			rst.setSuccess(true);
			return rst;
		} catch (DaoException ex) {
			throw processException(methodName, "执行批处理错误", ex);
		} catch (ServiceException ex) {
			throw ex;
		}
	}
	
	/**
	* @Description 数据回滚
	* @param businessNo 业务编号
	* @return ResultData
	* @throws ServiceException  
	 */
    public ResultData rubAccountByBusinessNo(String businessNo) throws ServiceException {
        String methodName = "rubAccountByBusinessNo";
        ResultData rd = new ResultData();
        // 计提汇总数据
        ${className} ${className?uncap_first} = null;
        try {
        	${className?uncap_first} = this.baseDao.findById(${className}.class, Long.valueOf(businessNo));
        }
        catch (DaoException e) {
            processException(methodName, "获取计提汇总对象出异常..",e);
        }
        ${className?uncap_first}.setEffectflag(Constant.EffectFlag.D);
        try {
            baseDao.saveOrUpdate(${className?uncap_first});
        }
        catch (DaoException e) {
            processException(methodName, "回滚计提汇总操作出异常..", e);
        }
        List<${subClassName}> detailList = new ArrayList<${subClassName}>();
        try {
        	detailList = ${className?uncap_first}Dao.find${subClassName}ForCount(${className?uncap_first}.get${pkname?lower_case?cap_first}(),EffectFlag.E);
        	
        	for (${subClassName} ${subClassName?uncap_first} : detailList) {
        		${subClassName?uncap_first}.setEffectflag(Constant.EffectFlag.D);
				baseDao.update(${subClassName?uncap_first});
			}
        }
        catch (DaoException e) {
            processException(methodName, "回滚计提明细和交易明细信息..", e); 
        }
        rd.setSuccess(true);
        return rd;
    }
}
