<#list table.columns as column>
	<#if column.comment??>
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


	</#if>
</#list>