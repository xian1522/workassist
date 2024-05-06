<%@ page language="java" pageEncoding="UTF-8"%>
<%@taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />	
    <title>${table.comment!}申请</title>
	<%@include file="/pages/common/meta.jsp"%>
	<script type="text/javascript" src="<%=path%>/libs/js/form/selectCustom.js"></script>
	<script type="text/javascript">
		function initComplete(){
			curpage.edit();
		}

		// 提交
		function save${className}(){
			var valid = $('#edit_form').validationEngine({returnIsValid: true});
			if(!valid) {
				return;
			}
			var data = $.getHtmlToArray($('#edit_form'));
			$.post("<%=path%>${packageName?replace(".","/")}/save${className}.do", data , function(result) {
				if (result.res == true) {
					closeWin();
				} else {
					Ticm.resubmit.exec(false);
					top.Dialog.alert(result.message);
				}
			}, "json");
		}
	</script>
  </head>
  <body>
  	<form id="edit_form" target="frmright">
		<div id="formContent" whiteBg="true" class="showbox">
			<div class="btn_area" id="button">
				<div id="toolbarBtn" class="l-toolbar-item l-panel-btn l-toolbar-item-hasicon" >
					<div class="l-panel-btn-l"></div>
					<div class="l-panel-btn-r"></div>
					<div class="l-icon icon_save left" onmouseover="setBtnOver(toolbarBtn)" onmouseout="setBtnOut(toolbarBtn)" onclick="save${className}();return false;">
						<s:text name="button.save"/></div>
				</div>
				<div id="toolbarBtn2"  class="l-toolbar-item l-panel-btn l-toolbar-item-hasicon">
					<div class="l-panel-btn-l"></div>
					<div class="l-panel-btn-r"></div>
					<div class="l-icon icon_no left" onmouseover="setBtnOver(toolbarBtn2)" onmouseout="setBtnOut(toolbarBtn2)" onclick="top.Dialog.close();">
					<s:text name="button.cancel"/></div>
				</div>
			</div>
			<div class="con_area">
				<%@include file="/pages${packageName?replace(".","/")}/${className?uncap_first}Base.jsp"%>
			</div>
		</div>
  	</form>
  </body>
</html>