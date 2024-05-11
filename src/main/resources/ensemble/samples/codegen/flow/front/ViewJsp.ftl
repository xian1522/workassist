<%@ page language="java" pageEncoding="UTF-8"%>
<%@taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />	
    <title>${table.comment!}查看</title>
	<%@include file="/pages/common/meta.jsp"%>
	<script type="text/javascript" src="<%=path%>/libs/js/form/selectCustom.js"></script>
	<script type="text/javascript">
		function initComplete(){
			curpage.view();
		}
	</script>
  </head>
  <body>
  	<form id="edit_form" target="frmright">
		<div id="formContent" whiteBg="true" class="showbox">
			<div class="con_area">
				<%@include file="/pages${packageName?replace(".","/")}/${className?uncap_first}Base.jsp"%>
				<%@include file="/pages${packageName?replace(".","/")}/${className?uncap_first}Remark.jsp"%>
				<%@include file="/pages${packageName?replace(".","/")}/${className?uncap_first}UserInfo.jsp"%>
			</div>
		</div>
  	</form>
  </body>
</html>