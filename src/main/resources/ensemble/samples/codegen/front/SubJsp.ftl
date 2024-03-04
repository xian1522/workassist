<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.joyin.ticm.common.constant.Constant"%>
<div class="view">
	<fieldset >
	<legend>${subTable.comment!}信息</legend>
		<table class="tableStyle" formMode="transparent" id="${subClassName?lower_case}_table" style="display:none">
			<input type="hidden" id="uuid" name="uuid" value=""  class="input_w180"/>
			<input type="hidden" id="${subClassName?uncap_first}_index" value="" />

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
			<tr>
				<td></td>
				<td>
					<input id="buttonOK" type="button" onClick="save${subClassName}();return false;" value="保存" />
					<input id="buttonCancel" type="button" onClick="close${subClassName}();return false;" value="关闭" />
				</td>
				<td></td>
				<td></td>
			</tr>
		</table>
		<div id="${subClassName?uncap_first}Grid"></div>
	</fieldset>
</div>