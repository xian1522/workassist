<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<div class="view">
     <fieldset>
         <legend>申请事由</legend>
         <table class="tableStyle" formMode="transparent">
             <tr>
                 <td width="15%">
                     申请事由<s:text name="label.colon"/>
                 </td>
                 <td width="85%">
                     <textarea id="remark" name="${className?uncap_first}.remark"  maxnum="200" > <s:property value="${className?uncap_first}.remark"/> </textarea>
                 </td>
             </tr>
         </table>
     </fieldset>
 </div>