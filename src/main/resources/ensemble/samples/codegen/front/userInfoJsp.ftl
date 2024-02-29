<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!-- 申请人信息 -->
<div class="view">
	<fieldset >
		<legend><s:text name="dc.label.deal.applyusermsg"/></legend>
		<table class="tableStyle" formMode="transparent">
			<tr>
				<td width="10%" >
					<s:text name="label.organ.no"/><s:text name="label.colon"/><!--机构号-->
				</td>
				<td width="35%" >
					<input type="text" id="orgid" name="${className?uncap_first}.orgid" disabled="disabled" value="<s:property value="${className?uncap_first}.orgid"/>"   class="input_w180"/>
				</td>
				<td width="15%" >
					<s:text name="label.organ.name"/><s:text name="label.colon"/><!--机构名称-->
				</td>
				<td width="35%" >
					<input type="text" id="orgname" name="${className?uncap_first}.orgname"  disabled="disabled" value="<s:property value="${className?uncap_first}.orgname"/>"  class="input_w180" />
				</td>
			</tr>
			<tr>
				<td>
					操作员号<s:text name="label.colon"/>
				</td>
				<td>
					<input type="text" id="rtranuser" name="${className?uncap_first}.rtranuser"  disabled="disabled" value="<s:property value="${className?uncap_first}.rtranuser"/>" class="input_w180" />
				</td>
				<td>
					操作员<s:text name="label.colon"/>
				</td>
				<td>
					<input type="text" id="rtranname" name="${className?uncap_first}.rtranname"  disabled="disabled" value="<s:property value="${className?uncap_first}.rtranname"/>"  class="input_w180" />
				</td>
			</tr>
		</table>
	</fieldset>
</div>
				
				
	