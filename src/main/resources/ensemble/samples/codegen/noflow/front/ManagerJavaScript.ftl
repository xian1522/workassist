var ${className?uncap_first}grid = null;
function initComplete(){

    init${className}Grid();
    //删除grid全选按钮
    hideAlCheck.isHidden();
    controlGridBtn();

    initOrgan();
	view(${className?uncap_first}grid);
}

/**
 * 初始化机构
 */
function initOrgan(){
	    //非省联社自动disabled 机构号下拉框
    if (Constant.ORG_TYPE_M != JOYIN.sysinfo.orgtype && Constant.ORG_TYPE_P != JOYIN.sysinfo.orgtype) {
        $("#suggestorgid").attr("disabled", true);
        $("#suggestorgid").render();
    }
    // 下拉框绑定事件
    $("#suggestorgid").bind("listSelect", function(e, obj){
        var value = obj.relText.split("-")[0];
        if ("" != value && null != value) {
            $("#suggestorgid>input:eq(0)").val(value).attr("name", "${className?uncap_first}.orgid");
            $("#orgname").val(obj.relValue);
        }
    })
    
    // 无机构号，清空机构名称
    $("#suggestorgid>input:eq(0)").blur(function(){
        if ($("#suggestorgid>input:eq(0)").val() == '') {
            $("#orgname").val('');
        }
    })
    
    //设置初始值
    $("#suggestorgid>input:eq(0)").val(JOYIN.sysinfo.orgid).attr("name", "${className?uncap_first}.orgid");
}


function init${className}Grid(){
    var columns = [
<#list table.columns as column>
    <#if column.comment??>
        <#if column.typeName == 'BigDecimal'>
            { display: '${column.comment!}', name: '${column.name}', align: 'right', width: 120,
                render: function (rowdata, rowindex, value, column){
                    if( value != null){
                        return formatRound(value,<#if column.size==26>2<#elseif column.size==18>4</#if>);
                    }
                }
            },
        <#else>
            { display: '${column.comment!}', name: '${column.name}', align: <#if column.typeName= 'Date'>'right'<#else>'left'</#if>, <#if column.typeName= 'Date'>type: 'date',</#if> width: 120 },
        </#if>
    </#if>
</#list>
    ];
    columns = columns.concat(gridHide);
    ${className?uncap_first}grid = $("#dataBasic").quiGrid({
        columns: columns,
        url: contextPath +'${packageName?replace(".","/")}/find${className}OfPage.do',
        checkbox: true,
        params: [{
            name: "moduleid",
            value: moduleid
        }],
        sortName: 'lstmntdate',
        height: '100%',
        width: "100%",
        pageSize: pageSize,
        selectRowButtonOnly: Constant.selectRowButtonOnly,
        onCheckAllRow: onGridCheckAllRow,
        onCheckRow: onGridCheckRow,
        onSelectRow: onGridSelectRow,
        onUnSelectRow: onGridUnSelectRow,
        toolbar: {
            items: [{
                text: Constant.add,
                click: add${className},
                iconClass: Constant.icon_add
            }, {
                line: true
            }, {
                text: Constant.edit,
                click: edit${className},
                iconClass: Constant.icon_edit
            }, {
                line: true
            }, {
                text: Constant.deletz,
                click: delete${className},
                iconClass: Constant.icon_delete
            }, {
                line: true
            }]
        },
        onAfterShowData: onAfterShowData
    });
}

//格式化日期
$.quiDefaults.Grid.formatters['date'] = function(value, column){
    if (null != value) {
        var arr = value.substring(0, 10);
        return arr;
    }
}

//新增
function add${className}(){
  	openCustomWindow(
		contextPath +'${packageName?replace(".","/")}/init${className}Add.do?moduleid=' + moduleid,
		Resource.moduleName+Constant.line+Constant.add, 800, 620);
}



//编辑    
function edit${className}(){
    var rows = ${className?uncap_first}grid.getSelectedRows();
    if (rows.length != 1) {
        top.Dialog.alert(Constant.noselect);
        return;
    }
  	openCustomWindow(
		contextPath +'${packageName?replace(".","/")}/init${className}Edit.do?moduleid=' + moduleid + '&${className?uncap_first}.seqno=' + rows[0].seqno,
		Resource.moduleName+Constant.line+Constant.edit, 800, 580);
}

//删除或批量删除
function delete${className}(){
    var rows = ${className?uncap_first}grid.getSelectedRows();
    var rowsLength = rows.length;
    if (rowsLength == 0) {
        top.Dialog.alert(Constant.noselect);
        return;
    }
    top.Dialog.confirm(Constant.deletzMsg, function(){
        $.post(contextPath +"${packageName?replace(".","/")}/delete${className}.do?moduleid="+moduleid, getSelectId(${className?uncap_first}grid), function(data){
            if (data.res) {
                ${className?uncap_first}grid.loadData();
            }
            else {
                top.Dialog.alert(data.message);
            }
        }, "json");
    });
}

function getSelectId(${className?uncap_first}grid){
    var selectedRows = ${className?uncap_first}grid.getSelectedRows();
    var selectedRowsLength = selectedRows.length;
    var ids = "";
    for (var i = 0; i < selectedRowsLength; i++) {
        ids += selectedRows[i].seqno + ",";
    }
    return {
        "ids": ids
    };
}

//查询
function searchHandler(){
    var query = $.getHtmlToArray($("#searchForm"));

    ${className?uncap_first}grid.setOptions({
        params: query
    });
    //页号重置为1
    ${className?uncap_first}grid.setNewPage(1);
    ${className?uncap_first}grid.loadData();//加载数据
}

function resetHandler(){
    //下拉框还原
    $("#searchForm").find("select").render();

    searchHandler();
    // 初始化按钮
    controlGridBtn();
}

//刷新表格数据并重置排序和页数
function refresh(isUpdate){
    $("#" + ${className?uncap_first}grid.id + " tr[class*='l-selected']").removeClass("l-selected");
    if (isUpdate) {
        //重置排序
        ${className?uncap_first}grid.options.sortName = "lstmntdate";
        ${className?uncap_first}grid.options.sortOrder = "desc";
        //页号重置为1
        ${className?uncap_first}grid.setNewPage(1);
    }
    ${className?uncap_first}grid.loadData();
    controlGridBtn();
}

function onGridCheckAllRow(){
    controlGridBtn();
}

function onGridCheckRow(){
    controlGridBtn();
}

function onGridSelectRow(){
    controlGridBtn();
}

function onGridUnSelectRow(){
    controlGridBtn();
}

function controlGridBtn(){
    var obj = {
        "isFlow": false,
        "quigrid": ${className?uncap_first}grid,
    }
    $.getSelectRows(obj);
}

function onAfterShowData(data){
    controlGridBtn();
}
