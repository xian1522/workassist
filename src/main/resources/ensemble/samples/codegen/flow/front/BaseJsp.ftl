<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.joyin.ticm.common.constant.Constant"%>
<%@taglib uri="/struts-tags" prefix="s"%>
<script type="text/javascript">
	var SubPageSource={
		${pkname?lower_case}:"<s:property value="${className?uncap_first}.${pkname?lower_case}"/>",
	}

</script>
<script src="${r"${pageContext.request.contextPath}"}/javascript${packageName?replace(".","/")}/${className?uncap_first}Edit.js" type="text/javascript"></script>
<input type="hidden" id="lstmntdate" name="${className?uncap_first}.lstmntdate" value="<s:property value="${className?uncap_first}.lstmntdate"/>" />
<input type="hidden" id="createdate" name="${className?uncap_first}.createdate" value="<s:property value="${className?uncap_first}.createdate"/>" />
<input type="hidden" id="effectflag" name="${className?uncap_first}.effectflag" value="<s:property value="${className?uncap_first}.effectflag"/>" />
<input type="hidden" id="taskId" name="${className?uncap_first}.taskId" value="<s:property value="${className?uncap_first}.taskId"/>" />
<input type="hidden" id="curTask" name="${className?uncap_first}.curTask" value="<s:property value="${className?uncap_first}.curTask"/>" />
<input type="hidden" id="maxTask" name="${className?uncap_first}.maxTask" value="<s:property value="${className?uncap_first}.maxTask"/>" />
<input type="hidden" id="moduleid" name="${className?uncap_first}.ownedModuleid" value="<s:property value="moduleid"/>" />
<input type="hidden" name="moduleid" value="<s:property value="moduleid"/>" />
<div class="view">
	<fieldset id="_Container_0">
		<legend>基本信息</legend>
		<table class="tableStyle" formMode="transparent">
		<#list table.columns as column>
			<#if column.comment??>
				<tr>
					<td width="15%">
						<#if column.comment?index_of("字典") gt 0 >
						${column.comment?substring(0,column.comment?index_of("[") - 1)}<s:text name="label.colon"/>
						<#else>
						${column.comment}<s:text name="label.colon"/>
						</#if>
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