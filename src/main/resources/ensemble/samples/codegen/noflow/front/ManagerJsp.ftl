<%@ page language="java" pageEncoding="UTF-8"%>
<%@taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <%@include file="/pages/common/meta.jsp"%>
    <script src="${r"${pageContext.request.contextPath}"}/javascript${packageName?replace(".","/")}/${className?uncap_first}Manager.js" type="text/javascript"></script>
    <script type="text/javascript">
        var Resource={
            moduleName:"${table.comment!}",
        }
    </script>
</head>
<body>
<div id="searchForm" method="post">
    <div id="searchbox" class="searchbox">
        <div class="topbg">
            <div class="panelname"><s:text name='button.search'/></div>
        </div>
        </div>
            <%@include file="${className?uncap_first}Search.jsp" %>
        </div>
    </div>
</form>
<div id="scrollContent">
    <div class="padding_right5">
        <div id="dataBasic"></div>
    </div>
</div>

</body>
</html>


