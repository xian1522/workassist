<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.joyin.ticm.common.constant.Constant"%>
<!-- 模块编号 -->
<input type="hidden" id="moduleid" name="moduleid" value="<s:property value="moduleid"/>" />

<div class="boxContent01">
    <table class="tableStyle" formMode="transparent">
         <tr>
	         <td width="80px" >
                 业务类型<s:text name="label.colon"></s:text>
	         </td>
	         <td width="210px">
                 <select prompt="<s:text name='label.select.default.value'/>" selWidth="160" name="fiveclassApprovel.busitype" id="busitype">
                 </select>
	         </td>
             <td width="80px">
                 业务子类型<s:text name="label.colon"/>
             </td>
             <td width="210px">
                 <select prompt="<s:text name="label.select.default.value" />" selWidth="160" id="busisubtype" name="fiveclassApprovel.busisubtype"
                         data='{"list":[]}'></select>
             </td>
             <td>
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