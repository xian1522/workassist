<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>计提管理页面</title>
		<%@include file="/pages/common/meta.jsp"%>
		<script src="${"${pageContext.request.contextPath}"}/javascript${packageName?replace(".","/")}/${className?uncap_first}Manager.js" type="text/javascript"></script>
		<script type="text/javascript">
			var Resource={
				// select start	
				seldeal:"<%=WebConstant.OptionType.DEAL%>",//办理.
				selquery:"<%=WebConstant.OptionType.QUERY%>",//查询.
				// select end	
				// 模块名称
				dealModuleName:'${table.comment!}'
			};
		</script>
	</head>
	<body>
		<div>
			<!-- 当前模块 -->
			<form id="queryForm" method="post">
				<!-- 隐藏域 start -->
				<input type="hidden" name="moduleid" value="<s:property value="moduleid"/>" />
				<input type="hidden" name="optype" id="optype" value="<s:property value="optype"/>" />
				<input type="hidden" id="loginorgid"  value="<s:property value="${className?uncap_first}Dto.loginOrgid"/>" />
				<input type="hidden" id="loginorgtype" name="loginorgtype" value="<s:property value="#session.userkey.orgtype"/>" />
				<input type="hidden" id="stopdate" name="${className?uncap_first}Dto.stopdate"  value="<s:property value="${className?uncap_first}Dto.stopdate"/>" class="date" />
				<input type="hidden" id="hidenowdate" value="<%=Ticm.getSystemTime() %>"/>
				<!-- 隐藏域 end -->
				
				<div id="searchbox" class="searchbox" >
					<div class="boxContent" style="display:none">
						<table class="tableStyle" formMode="transparent">
							<tr>
								<td width="80px">
									机构号<s:text name="label.colon"/>
								</td>
								<td  width="210px">
									<div class="suggestion"  url="<%=path%>/util/getOrganListP.do" showList="true" autoCheck="false" id="suggestorgid"></div>
								</td>
								<td width="60px">
									机构名称<s:text name="label.colon"/>
								</td>
								<td  width="210px">
									<input type="text" id="orgname" name="${className?uncap_first}Dto.orgname" value="<s:property value="#session.userkey.orgname"/>" style="width:198px;" disabled="disabled"/>
								</td>
								<td width="80px">
									<s:text name="label.countdraw.bgndate"/><s:text name="label.colon"/>
								</td>
								<td  width="210px">
									<input type="text" id="bgndatefrom" name="${className?uncap_first}Dto.date2From" class="date" />
									<s:text name="label.line"></s:text><s:text name="label.line"></s:text> 
									<input type="text" id="bgndateto"  name="${className?uncap_first}Dto.date2To" class="date"/>
								</td>
								<td>
									
								</td>
							</tr>
							<tr>
								<td>
									<s:text name="sec.label.secfair.drawdate" /><s:text name="label.colon"/>
								</td>
								<td>
									<input type="text" id="date1From" name="${className?uncap_first}Dto.date1From" class="date" />
									<s:text name="label.line"></s:text><s:text name="label.line"></s:text> 
									<input type="text" id="date1To"  name="${className?uncap_first}Dto.date1To" class="date"/>
								</td>
								<td>
									申请编号<s:text name="label.colon"/>
								</td>
								<td>
									<input type="text" id="reqid" name="${className?uncap_first}Dto.reqid" style="width:198px;"/>
								</td>
								<td>
									<s:text name="label.countdraw.enddate"/><s:text name="label.colon"/>
								</td>
								<td>
									<input type="text" id="enddatefrom" name="${className?uncap_first}Dto.date3From" class="date" />
									<s:text name="label.line"></s:text><s:text name="label.line"></s:text> 
									<input type="text" id="enddateto"  name="${className?uncap_first}Dto.date3To" class="date"/>
								</td>
								<td>
									<button type="button" onclick="btnSearch();">
										<span class="icon_find"><s:text name="button.search"></s:text></span>
									</button>
									<button type="button" onclick="resetHandler2();">
										<span class="icon_clear"><s:text name="button.reset"></s:text></span>
									</button>
								</td>
							</tr>
						</table>
					</div>
					<div class="boxContent01">
						<table class="tableStyle" formMode="transparent">
							 <tr>
							 	<td width="80px">
							 		<!-- 上次计提日期 -->
							 		<s:text name="ibl.autobear.label.lstcdrawdate_temp"></s:text><s:text name="label.colon"></s:text>
								</td>
								<td width="130px">
									<input type="text" id="lstdrawdate" name="${className?uncap_first}Dto.lstdrawdate" disabled="disabled"
										value='<s:date name="${className?uncap_first}Dto.lstdrawdate" format="%{getText('date.format')}"/>' class="date input_w120" />
								</td>
								<td width="60px">
									<!-- 本次计提日期 -->
									<s:text name="sec.label.secfair.drawdate" /><s:text name="label.colon" />
								</td>
								<td width="300px">
									<input type="text" id="drawdate" name="${className?uncap_first}Dto.drawdate"
										value='<s:date name="${className?uncap_first}Dto.drawdate" format="%{getText('date.format')}"/>' class="date input_w120" />
									<button type="button" onclick="runTest();">
										<span class="icon_edit"><s:text name="button.runtest"></s:text></span>
									</button>
									<button type="button" onclick="runCount();">
										<span class="icon_edit"><s:text name="button.jiti"></s:text></span>
									</button>
								</td>
								<td>
								</td>
							</tr>
						</table>
					</div>
				</div>
		    </form>
		    
			<div class="padding_right5">
				<div id="dataBasic"></div>
			</div>
		</div>
	</body>
</html>
