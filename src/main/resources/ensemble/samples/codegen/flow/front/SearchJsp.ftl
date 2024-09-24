<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.joyin.ticm.common.constant.Constant"%>
<!-- 模块编号 -->
<input type="hidden" id="moduleid" name="moduleid" value="<s:property value="moduleid"/>" />
<div class="boxContent" style="display:none">
    <table class="tableStyle" formMode="transparent" width="100%">
            <tr >
            	<td width="80px" >
                     交易日期<s:text name="label.colon"></s:text>
                </td>
                <td width="210px" >
                    <input type="text" id="date1From"  name="${className?uncap_first}.date1From" class="date" />--
                    <input type="text" id="date1To"  name="${className?uncap_first}.date1To" class="date" />
                </td>
                <td width="80px" >
              	   	 券面总额(万元)<s:text name="label.colon"></s:text>
                </td>
                <td width="210px" >
                    <input type="text" id="bigDecimal1From" unit="wy" onblur="replenish2(this)" name="${className?uncap_first}.bigDecimal1From" class="money " style="width:90px;text-align: right;"/>--
                    <input type="text" id="bigDecimal1To" unit="wy" onblur="replenish2(this)"  name="${className?uncap_first}.bigDecimal1To" class="money " style="width:90px;text-align: right;"/>
                </td>
           		<td width="80px">
                  	 申请编号<s:text name="label.colon"></s:text>
                </td>
                <td width="210px">
                   <input type="text" id="reqid" name="${className?uncap_first}.reqid" style="width:130px;"  />
                </td>
               
            </tr>
            <tr >
                <td width="80px" >
                    <s:text name="label.organ.no"></s:text><s:text name="label.colon"></s:text>
                </td>
                <td width="210px">
                    <div class="suggestion"   url="${"${pageContext.request.contextPath}"}/util/getOrganListP.do" showList="true" inputWidth="130" autoCheck="false" id="suggestorgid" ></div>
                </td>
                <td width="80px" >
                    <s:text name="label.organ.name"></s:text><s:text name="label.colon"></s:text>
                </td>
                <td width="210px">
                    <input type="text" id="orgname" name="${className?uncap_first}.orgname" disabled="disabled" style="width:130px;" />
                </td>
                <td width="80px" >
                 </td>
                <td width="210px" >
                </td>
            </tr>
    </table>
</div>

<div class="boxContent01">
    <table class="tableStyle" formMode="transparent">
         <tr>
	         <td width="80px" >
	          	    申请日期<s:text name="label.colon"></s:text>
	         </td>
	         <td width="210px">
	             <input type="text" id=date2From  name="${className?uncap_first}.date2From" class="date" />--
	             <input type="text" id="date2To"  name="${className?uncap_first}.date2To" class="date" />
	         </td>
             <td width="80px">
               	债券代码<s:text name="label.colon"/> 
             </td>
             <td width="210px">
                 <input type="text" id="secid" name="${className?uncap_first}.secid" style="width:130px;"  />
             </td>
             <td></td>
        </tr>
        <tr>
            <td width="80px">
                <s:text name="label.optype"></s:text><s:text name="label.colon"></s:text></td>
            <td width="210px">
                <select name="optype" id="optype" selectedValue="<s:property value="optype"/>" 
                        onchange="optOnChange()" selWidth="130" ></select> 
            </td>
            <td width="90px">
                                                     流程状态<s:text name="label.colon"/><!-- 状态-->
            </td>
            <td width="80px">
                <select id="effectflag" name="${className?uncap_first}.effectflag"  selWidth="130"  selectedValue="<s:property value="${className?uncap_first}.effectflag"/>" />
            </td>
            <td></td>
            <td align="right">
                <button type="button" id="searchButn" onclick="searchHandler();">
                    <span class="icon_find"><s:text name="button.search"/></span>
                </button>
            
                <button type="button" onclick="resetHandler();">
                    <span class="icon_clear"><s:text name="button.reset"/></span>
                </button>
            </td>
        </tr>
        
    </table>
</div>