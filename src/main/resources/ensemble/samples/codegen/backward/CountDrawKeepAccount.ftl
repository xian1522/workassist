package com.joyin.ticm.ka${packageName?substring(0, packageName?last_index_of("."))};

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
import com.joyin.ticm${packageName}.model.${subClassName};

/**
 * @Description ${table.comment!}记账实体
 */
public class ${className}KeepAccount {
	public SysKeepAccount getSysKeepAccount(KaConfigService kaConfigService,
			${className} ${className?uncap_first},
			List<${subClassName}> ${subClassName?uncap_first}List,
			String isBatch,String opttype) throws ServiceException {
		String orgid = ${className?uncap_first}.getOrgid();
		String orgname = ${className?uncap_first}.getOrgname();

		String accremark = null;
		if (CommonUtil.isNotEmpty(isBatch)&&Constant.DataDictItemCode.CDDS_B.equals(isBatch)) {
			accremark = Constant.OperateType.STRING_BATCH_DRAW;
		}
		else {
			if (CommonUtil.isNotEmpty(${subClassName?uncap_first}List)
					&& CommonUtil.isNotEmpty(${subClassName?uncap_first}List.get(0)))
				accremark = ${subClassName?uncap_first}List.get(0).getAccremark();
			else {
				accremark = "手动计提 ";
			}
		}

		// 记账汇总信息
		SysKeepAccount sysKeepAccount = new SysKeepAccount(FLAG.FLAG_0, // 正常业务标识
				${className?uncap_first}.get${pkname?lower_case?cap_first}().toString(), // 相关业务的编号
				Constant.BusinessType.SL, // 业务类别
				Constant.SysModuleId.SL_MODULE_COUNTDRAW, // 业务子类别
				${className?uncap_first}.get${pkname?lower_case?cap_first}().toString(), ${className?uncap_first}
						.getLstmntuser(), // 经办人
				${className?uncap_first}.getLstmntuser(), // 复核人
				orgid, // 机构编号
				orgname, // 机构名称
				accremark); // 记账摘要
		try {
			sysKeepAccount.setDoType(isBatch);
			
			if (CommonUtil.isNotEmpty(opttype)) {
				//设置发送核心状态
				sysKeepAccount.setSendflag(opttype);
			}

			// 记账明细Model
			List<SysKeepAccountDetail> kadetailSet = new ArrayList<SysKeepAccountDetail>();

			List<SysKeepAccountDetail> sysKeepAccountDetails = new ArrayList<SysKeepAccountDetail>();
			int index = 1;
			for (${subClassName} detail : ${subClassName?uncap_first}List) {

				if (CommonUtil.isEmpty(detail)) {
					continue;
				}
				// =======1.获取场景信息=======
				// 场景Map
				Map<String, List<String>> sceneMap = new HashMap<String, List<String>>();
				// 1.本模块ModuleID
				List<String> lst = new ArrayList<String>();
				lst.add(Constant.SysModuleId.SL_MODULE_COUNTDRAW);
				sceneMap.put((sceneMap.size()+1)+"", lst);

				// =======2.获取参数Map=======
				Map<String, String> paraMap = new HashMap<String, String>();
				//
				paraMap.put("reqid", detail.getReqid());

				paraMap.put("index", String.valueOf(index));
				// 记账摘要
				paraMap.put("Accremark", accremark);
				
				index++;

				// 获取会计分录
				kadetailSet = kaConfigService
						.getKaDetailList(sceneMap, paraMap);
				sysKeepAccountDetails.addAll(kadetailSet);
			}
			sysKeepAccount.setKaDetailList(sysKeepAccountDetails);

		}
		catch (ServiceException e) {
		}
		return sysKeepAccount;
	}
}
