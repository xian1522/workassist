<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<!-- 公共资源start -->
		<%@include file="/pages/common/meta.jsp"%>
		<!-- 公共资源end -->
		<script type="text/javascript">  
	     //初始化
		function initComplete(){
	    	//计息基础
			getDataDict("#basis", "<%=Constant.DataDictClsNo.BASIS%>");
         }
		// 保存
		function saveOrSubmit(){
	    	var valid = $("#myFormId").validationEngine({returnIsValid: true});
            var data = $.getHtmlToArray($('#myFormId'));
            var url = "<%=path%>${packageName?replace(".","/")}/saveDetail.do";
			if (!valid) {
				return;
			}
			$.post(url, data, function(result) {
				if (result.res == true) {
					closeWin();
				} else {
					top.Dialog.alert(result.message);
				}
			}, "json");
		}


		function intamtChange() {
			//本次计提金额
			var intamt = $("#intamt").val();
			if(intamt == null || intamt == ""){
				return;
			}
			// 期初利息
			var sintamt = $("#sintamt").val();
			// 期末利息
			var totalamt = parseFloat(intamt) + parseFloat(sintamt);
			$("#totalintamt").val(totalamt);
			FunFormat(el("totalintamt"));
		}
</script>
	</head>
	<body>
		<form id="myFormId">
			<input type="hidden" id="loginUserid" name="${subClassName?uncap_first}.loginUserid" value='<s:property value="${subClassName?uncap_first}.loginUserid"/>' />
			<input type="hidden" id="loginOrgid" name="${subClassName?uncap_first}.loginOrgid" value='<s:property value="${subClassName?uncap_first}.loginOrgid"/>' />
			<input type="hidden" id="seqno" name="${subClassName?uncap_first}.seqno" value='<s:property value="${subClassName?uncap_first}.seqno"/>' />
			<input type="hidden" id="seqid" name="${subClassName?uncap_first}.seqid" value='<s:property value="${subClassName?uncap_first}.seqid"/>' />
			<input type="hidden" id="orgid" name="${subClassName?uncap_first}.orgid" value='<s:property value="${subClassName?uncap_first}.orgid"/>' />
			<input type="hidden" id="drawdate" name="${subClassName?uncap_first}.drawdate" value='<s:property value="${subClassName?uncap_first}.drawdate"/>' />
			<input type="hidden" id="remark" name="${subClassName?uncap_first}.remark" value='<s:property value="${subClassName?uncap_first}.remark"/>' />
			<input type="hidden" id="rtranuser" name="${subClassName?uncap_first}.rtranuser" value='<s:property value="${subClassName?uncap_first}.rtranuser"/>' />
			<input type="hidden" id="rtranname" name="${subClassName?uncap_first}.rtranname" value='<s:property value="${subClassName?uncap_first}.rtranname"/>' />
			<input type="hidden" id="effectflag" name="${subClassName?uncap_first}.effectflag" value='<s:property value="${subClassName?uncap_first}.effectflag"/>' />

			<div id="formContent" whiteBg="true" class="showbox">
				<div class="btn_area" id="button">
					<div id="btnSave" class="l-toolbar-item l-panel-btn l-toolbar-item-hasicon">
						<div class="l-panel-btn-l"></div>
						<div class="l-panel-btn-r"></div>
						<div class="l-icon icon_save left" onmouseover=setBtnOver(btnSave); onmouseout=setBtnOut(btnSave); onclick=saveOrSubmit();>
							保存
						</div>
					</div>
					<div id="btnCancle" class="l-toolbar-item l-panel-btn l-toolbar-item-hasicon">
						<div class="l-panel-btn-l"></div>
						<div class="l-panel-btn-r"></div>
						<div class="l-icon icon_no left" onmouseover=setBtnOver(btnCancle); onmouseout=setBtnOut(btnCancle); onclick=top.Dialog.close();;>
							取消
						</div>
					</div>
				</div>
				<div class="con_area">
					<div class="view">
						<fieldset id="_Container_1">
							<legend>交易信息</legend>
							<table class="tableStyle" formMode="transparent" id="tb1">
								<tr>

									<td width="20%">
										申请编号
										<s:text name="label.colon"></s:text>
									</td>
									<td width="25%">
										<input name="${subClassName?uncap_first}.reqid" type="text"
											disabled="disabled" id="reqid" class="input_w180"
											value='<s:property value="${subClassName?uncap_first}.reqid"/>' />
									</td>
									<td width="20%">
										成交日期
										<s:text name="label.colon"></s:text>
									</td>
									<td width="25%">
										<input name="${subClassName?uncap_first}.slDeal.dealdate" type="text"
											disabled="disabled" id="dealdate" class="date input_w180"
											value='<s:date name="${subClassName?uncap_first}.slDeal.dealdate"  format="yyyy-MM-dd"/>' />
									</td>
								</tr>

							</table>
						</fieldset>
					</div>
					
					<div class="view">
						<fieldset id="_Container_2">
							<legend>计提信息</legend>
							<table class="tableStyle" formMode="transparent" id="tb2">
								<#list subTable.columns as column>
									<#if column.comment??>
										<tr>
											<td width="15%">
												${column.comment}<s:text name="label.colon"/>
											</td>
											<td width="35%">
												<#if column.comment?index_of("字典") gt 0 >
													<select prompt="<s:text name='label.select.default.value' />"
															id="${column.name}" name="${className?uncap_first}.${column.name}" boxWidth="180"
															selWidth="180" selectedValue='<s:property value="${className?uncap_first}.${column.name}"/>'>
													</select>
												<#elseif column.typeName == "Date">
													<input type="text" id="${column.name}" class="date input_w180"
														   name="${className?uncap_first}.${column.name}" value="<s:date name="${className?uncap_first}.${column.name}" format="yyyy-MM-dd"/>"/>
												<#elseif column.typeName == "BigDecimal">
													<#if column.size == 26>
														<input type="text" id="${column.name}" name="${className?uncap_first}.${column.name}"
															   value="<s:property value="${className?uncap_first}.${column.name}"/>" class="money input_w180_right validate[custom[illegalLetter]]" />
													<#elseif  column.size == 18>
														<input type="text" id="${column.name}" name="${className?uncap_first}.${column.name}"
														<s:if test="${className?uncap_first}.${column.name} != null && '' != ${className?uncap_first}.${column.name}">
															value='<s:text name="rate.format4"><s:param value="${className?uncap_first}.${column.name}"></s:param></s:text>'
														</s:if>
														class="input_w180_right validate[required,custom[moneyRate_2_4]]" onblur="replenish(this,4)"  />
													</#if>
												<#else>
													<input type="text" id="${column.name}" name="${className?uncap_first}.${column.name}" value="<s:property value='${className?uncap_first}.${column.name}' />"  class="input_w180"/>
												</#if>
											</td>
										</tr>
									</#if>
								</#list>
							</table>
						</fieldset>
					</div>
					<div class="view">
					<fieldset>
						<legend>记账摘要</legend> 
						<table class="tableStyle"  formMode="transparent">
							<tr>
								<td width="12%">
									记账摘要<s:text name="label.colon"/>
								</td>
								<td colspan="5" width="87%">
									<textarea id="accremark" name="${subClassName?uncap_first}.accremark" style="width:450px;" class="validate[required]" maxnum="<%=Constant.MaxNum.ACC_REMARK %>"><s:property value='${subClassName?uncap_first}.accremark'/></textarea>
									&nbsp;&nbsp;
								</td>
							</tr>
						</table>
					</fieldset>
				</div>
				</div>
			</div>
		</form>
	</body>
</html>