<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!-- 模块编号 -->
<input type="hidden" id="moduleid" name="moduleid" value="<s:property value="moduleid"/>" />

<div class="boxContent01">
    <table class="tableStyle" formMode="transparent">
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