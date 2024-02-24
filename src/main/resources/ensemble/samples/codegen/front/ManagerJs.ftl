var ${className}grid = null;
function initComplete(){
    //流程状态
    getDataDict("#effectflag", Constant.EFFECTFLAG);
    //操作类型
    getDataDict("#optype", Constant.OPTYPE);
    $("#effectflag").attr("disabled", true);
    
    init${className}Grid();
    //删除grid全选按钮
    hideAlCheck.isHidden();
    controlGridBtn();

    initOrgan();
	view(${className}grid);
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
            $("#suggestorgid>input:eq(0)").val(value).attr("name", "${className}.orgid");
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
    $("#suggestorgid>input:eq(0)").val(JOYIN.sysinfo.orgid).attr("name", "${className}.orgid");
}


function init${className}Grid(){
    var columns = [
        {display: '状态', name: 'stateName', align: 'left', width: 180,frozen: "true"},
<#list table.columns as column>
    { dispaly: '${column.comment!}', name: '${column.name}', align: <#if column.typeName='Date' || column.typeName='BigDecimal'>'right'<#else>'left'</#if>, <#if column.typeName= 'Date'>type: 'date',</#if> width: 120 },
</#list>
    ];
    columns = columns.concat(gridHide);
    ${className}grid = $("#dataBasic").quiGrid({
        columns: columns,
        url: contextPath +'${packageName?replace(".","/")}/find${className}OfPage().do',
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
            }, {
                text: Constant.viewflow,
                click: viewFlow,
                iconClass: Constant.icon_viewflow
            }, {
                line: true
            }, {
                text: Constant.deal,
                click: function(){
                    onDeal(${className}grid);
                },
                iconClass: Constant.icon_deal
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
function addAssetInfo(){
  	openCustomWindow(
		contextPath +'${packageName?replace(".","/")}/add${className}.do?moduleid=' + moduleid,
		Resource.moduleName+Constant.line+Constant.add, 800, 620);
}

//查看流程
function viewFlow(){
    var rows = ${className}grid.getSelectedRows();
    onViewFlow(rows[0].jbpmProcessid, rows[0].ownedModulename);
}

//编辑    
function editAssetInfo(){
    var rows = ${className}grid.getSelectedRows();
    if (rows.length != 1) {
        top.Dialog.alert(Constant.noselect);
        return;
    }
  	openCustomWindow(
		contextPath +'${packageName?replace(".","/")}/edit${className}.do?moduleid=' + moduleid + '&${packageName?replace(".","/")}.${pkname}=' + rows[0].${pkname}
			+ '&${packageName?replace(".","/")}.taskId=' + rows[0].taskId,
		Resource.moduleName+Constant.line+Constant.edit, 800, 580);
}

//删除或批量删除
function delete${className}(){
    var rows = ${className}grid.getSelectedRows();
    var rowsLength = rows.length;
    if (rowsLength == 0) {
        top.Dialog.alert(Constant.noselect);
        return;
    }
    top.Dialog.confirm(Constant.deletzMsg, function(){
        $.post(contextPath +"${packageName?replace(".","/")}/delete${className}.do?moduleid="+moduleid, getSelectId(${className}grid), function(data){
            if (data.res) {
                ${className}grid.loadData();
            }
            else {
                top.Dialog.alert(data.message);
            }
        }, "json");
    });
}

function getSelectId(${className}grid){
    var selectedRows = ${className}grid.getSelectedRows();
    var selectedRowsLength = selectedRows.length;
    var ids = "";
    for (var i = 0; i < selectedRowsLength; i++) {
        ids += selectedRows[i].${pkname} + "#" + selectedRows[i].taskId + ",";
    }
    return {
        "ids": ids
    };
}

//查询
function searchHandler(){
    var query = $.getHtmlToArray($("#searchForm"));

    ${className}grid.setOptions({
        params: query
    });
    //页号重置为1
    ${className}grid.setNewPage(1);
    ${className}grid.loadData();//加载数据
}

function resetHandler(){
    //表单常规元素还原
    var organid = $("#loginorgid").val();
    $("#searchForm")[0].reset();
    //自动提示框还原
    $("#searchForm").find("#suggestorgid>input:eq(0)").val(organid);
    //下拉框还原
    $("#searchForm").find("select").render();
    searchHandler();
    // 初始化按钮
    controlGridBtn();
}

//刷新表格数据并重置排序和页数
function refresh(isUpdate){
    $("#" + ${className}grid.id + " tr[class*='l-selected']").removeClass("l-selected");
    if (isUpdate) {
        //重置排序
        ${className}grid.options.sortName = "lstmntdate";
        ${className}grid.options.sortOrder = "desc";
        //页号重置为1
        ${className}grid.setNewPage(1);
    }
    ${className}grid.loadData();
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
        "isFlow": true,
        "quigrid": ${className}grid,
        "isCustom": true,
        "customModel": "assetinfo"
    }
    $.getSelectRows(obj);
}

function onAfterShowData(data){
    controlGridBtn();
}


