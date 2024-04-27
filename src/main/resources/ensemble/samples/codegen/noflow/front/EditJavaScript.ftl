var curpage = {
    init: function(){
		//初始化下拉框
		initSelect();
    },
    /**********************新增/编辑******************************/
    edit: function(){
        this.init();
    },
	/**********************查看******************************/
	view:function(){
    	this.init();
        $(':input[type!="hidden"]').each(function(){
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


