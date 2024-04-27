package com.joyin.ticm.ka${packageName?substring(0, packageName?last_index_of("."))};

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.joyin.ticm.accmn.kaconfig.service.KaConfigService;
import com.joyin.ticm.accmn.kamn.kacomm.KaConstant.FLAG;
import com.joyin.ticm.accmn.kamn.model.SysKeepAccount;
import com.joyin.ticm.accmn.kamn.model.SysKeepAccountDetail;
import com.joyin.ticm.common.constant.Constant;
import com.joyin.ticm.common.util.BigDecimalUtil;
import com.joyin.ticm.common.util.CommonUtil;
import com.joyin.ticm.service.ServiceException;
import com.joyin.ticm${packageName}.model.${className};

/**
 * @Description ${table.comment!}记账实体
 */
public class ${className}KeepAccount {
	/**
	* @Description 获取会计分录
	* @param kaConfigService 记账服务
	* @return SysKeepAccount 会计分录
	* @throws ServiceException  
    */
	public SysKeepAccount getSysKeepAccount(KaConfigService kaConfigService,
			${className} ${className?uncap_first}) throws ServiceException{
		String orgid = ${className?uncap_first}.getOrgid();
		String orgname = ${className?uncap_first}.getOrgname();
		String accremark = ${className?uncap_first}.getAccremark();
		
		// 记账汇总信息
		SysKeepAccount sysKeepAccount = new SysKeepAccount(FLAG.FLAG_0, // 正常业务标识
				${className?uncap_first}.getReqid(), // 相关业务的编号
				Constant.BusinessType., // 业务类别
				Constant.SysModuleId.SL_, // 业务子类别
				${className?uncap_first}.get${pkname?lower_case?cap_first}(),
				${className?uncap_first}.getTraUserid(), // 经办人
				${className?uncap_first}.getLoginUserid(), // 复核人
				orgid, // 机构编号
				orgname, // 机构名称
				accremark); // 记账摘要
		try {
			sysKeepAccount.setJbpmProcessid(${className?uncap_first}.getJbpmProcessid());
			// 记账明细Model
			List<SysKeepAccountDetail> kadetailSet = new ArrayList<SysKeepAccountDetail>();

			// =======1.获取场景信息=======
			// 场景Map
			Map<String, List<String>> sceneMap = new HashMap<String, List<String>>();
			// 1.本模块ModuleID
			List<String> lst = new ArrayList<String>();
			sceneMap.put((sceneMap.size()+1)+"", lst);
			

			// =======2.获取参数Map=======
			Map<String, String> paraMap = new HashMap<String, String>();

            // 记账摘要
            paraMap.put("Accremark", accremark);
			
			// 获取会计分录
			kadetailSet = kaConfigService.getKaDetailList(sceneMap, paraMap);
			sysKeepAccount.setKaDetailList(kadetailSet);
		}
		catch (ServiceException e) {
			throw e;
		}
		return sysKeepAccount;
	}
}
