var curpage = {
    init: function(){
		//初始化下拉框
		initSelect();
    },
    /**********************新增/编辑******************************/
    edit: function(){
        this.init();
<#if subTable??>
        init${subClassName}GridData(SubPageSource.${pkname?lower_case}, "EDIT");
</#if>
    },
    /**********************审核/审批******************************/
    audit: function(){
    	this.init();
<#if subTable??>
    init${subClassName}GridData(SubPageSource.${pkname?lower_case}, "VIEW");
</#if>
		//置灰控件
        $(':input[id!="flowRemark"][type!="hidden"][id!="accremark"]').each(function(){
            $(this).attr('disabled', true);
        });
    },
	/**********************查看******************************/
	view:function(){
    	this.init();
<#if subTable??>
    init${subClassName}GridData(SubPageSource.${pkname?lower_case}, "VIEW");
</#if>
        $(':input[id!="flowRemark"][type!="hidden"]').each(function(){
            $(this).attr('disabled', true);
        });
	}
}

/**
 * 初始化下拉框
 */
function initSelect(){
<#list table.columns as column>
	<#if column.comment?? && column.comment?index_of("字典") gt 0 >
		getDataDict("#${column.name}", "<#if column.comment??> ${column.comment?substring(column.comment?index_of("["),column.comment?index_of("]"))} </#if>");
	</#if>
</#list>
}

/**
* 清除退回原因中的属性
*/
function clearFlowRemark(){
    var $j = $("#flowRemark");
    $j.removeClass("validate[required]");
    $j.val('');
    $j.removeClass("error-field").attr("title", " ");
    $j.attr("textContent", "");
    addTooltip($j[0]);
}

<#if isKeepAccount == "是">
/**
 * 账务预览
 */
function onKaView(){
    var data = $.getHtmlToArray($("#edit_form"));
    $.post(contextPath + "${packageName?replace(".","/")}/saveAccountView.do", data, function(data){
        if (data.res) {
            accReportView(data.key);
        }
        else {
            top.Dialog.alert(data.message);
        }
    }, "json");
}
</#if>

<#if subTable??>
    <#include "subEditJavaScript.ftl"/>
</#if>