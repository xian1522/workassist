/**
 * ${table.comment!}
 */
var grid = null;
function initComplete(){
    
    // 初始化Grid表格
    initGrid();
    // 重置功能按钮
    controlGridBtn();

    // 高级查询隐藏
    view(grid);
    // Enter键查询
    $("#queryForm").keydown(function(event){
        if (event.keyCode == 13) {
            searchHandler();
            return false;
        }
    });
    // 隐藏 gridview 全选
    hideAlCheck.isHidden();
    // 设置机构号 下拉选择的功能.
	var organid = $("#loginorgid").val();
	//省联社登录相关判断
	var orgtype = $("#loginorgtype").val(); 
	
	if (Constant.ORG_TYPE_M != JOYIN.sysinfo.orgtype && Constant.ORG_TYPE_P != Resource.orgtype) {
		$("#suggestorgid").attr("disabled",true);
		$("#suggestorgid").render();
	}
	JOYIN.sysinfo.orgtype_PJT();
	$("#suggestorgid").bind("listSelect",function(e,obj){
		var value = obj.relText.split("-")[0];
		var orgname = obj.relText.split("-")[1];
		$("#suggestorgid>input:eq(0)").val(value).attr("name","slCountDrawDto.orgid");
		$("#orgname").val(orgname);
	});
	
	$("#suggestorgid>input:eq(0)").val(organid).attr("name","slCountDrawDto.orgid");
}

//初始化表格
function initGrid(){
    var columns = [
<#list subTable.columns as column>
    <#if column.comment??>
        <#if column.typeName='BigDecimal'>
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
    grid = $("#dataBasic").quiGrid({
        columns: columns,
        url: contextPath + '${packageName?replace(".","/")}/find${className}FindOfPage.do',
        checkbox: true,
        params: [{
            name: "moduleid",
            value: moduleid
        },
        {
            name: "optype",
            value: ""
        }],
        sortName: 'lstmntdate',
        height: '100%',
        width: '100%',
		percentWidthMode: false,
        usePager: true,
        pageSize: pageSize,
        selectRowButtonOnly: Constant.selectRowButtonOnly,
        onCheckAllRow: onGridCheckAllRow,
        onCheckRow: onGridCheckRow,
        onSelectRow: onGridSelectRow,
        onUnSelectRow: onGridUnSelectRow,
        onAfterShowData: onGridAfterShowData,
        toolbar: {
            items: [{
            	text:Constant.view,
            	click:viewDetail,
            	iconClass:Constant.icon_view
            },{
            	line:true
            },{
                text: "导出",
                click: onReportXls,
                iconClass: Constant.icon_xls
            },{
                line: true
            }]
        }
    });
}

// 格式化日期
$.quiDefaults.Grid.formatters['date'] = function(value, column){
    if (value != null) {
        var arr = value.substring(0, 10);
        return arr;
    }
}

/**
 * 导出当前excel所有数据
 */
function onReportXls(){
	
	var arrData = grid.getData();
    if (arrData.length == 0) {
           top.Dialog.alert("没有数据");
           return;
    }
	
	var query = $.getHtmlToArray($("#queryForm"));
	
	$.post(contextPath + '${packageName?replace(".","/")}/exportReportXlsOfPage.do', query , function(result) {
			if(result.status == true || result.status == "true"){
				var fileName = result.fileName;
				var targetFileName = result.targetFileName;
				exportExcel(fileName, targetFileName);
			}else{
				top.Dialog.alert(result.message);
			}
	}, "json");
}


// 试运行操作、计提操作后刷新grid
function refreshGridAfterRun(query){
    $("#" + grid.id + " tr[class*='l-selected']").removeClass("l-selected");
    grid.setOptions({
        params: query
    });
    //页号重置为1
    grid.setNewPage(1);
    //加载数据
    grid.loadData();
    // 重置功能按钮
    controlGridBtn();
}

// 初始化上次计提日和本次计提日
function initCountDrawDate(){
    $.ajax({
        type: 'POST',
        url: contextPath + "${packageName?replace(".","/")}/initCountDrawDate.do",
        async: false,
        dataType: 'json',
        success: function(results){
            if (results != '') {
                $("#lstdrawdate").val(results.lstdrawdate);
                $("#drawdate").val(results.drawdate);
                $("#stopdate").val(results.stopdate);
            }
            else {
                $("#lstdrawdate").val('');
                $("#drawdate").val('');
                $("#stopdate").val('');
            }
        },
        error: function(){
            top.Dialog.alert("初始化计提日期有误!");
        }
    });
}

/*************************************编辑、删除操作*************************************/
// 编辑
function editDetail(){
    // 编辑按钮不可用
    if ($("div[toolbarid='editbutton'][style*='default']").length != 0) {
        return false;
    }
    var rows = grid.getSelectedRows();
    if (rows.length != 1) {
        top.Dialog.alert(Constant.noselect);
        return;
    }
    var url = contextPath + '${packageName?replace(".","/")}/init${className}Edit.do?slCountDrawDto.${pkname?lower_case}=' + rows[0].${pkname?lower_case} + '&moduleid=' + moduleid;
    openCustomWindow(url, Resource.dealModuleName + Constant.line + Constant.edit, 900, 800);
}

// 删除
function deleteDetail(){
    // 删除按钮不可用
    if ($("div[toolbarid='deletebutton'][style*='default']").length != 0) {
        return false;
    }
    
    var rows = grid.getSelectedRows();
    
    if (rows.length != 1) {
        top.Dialog.alert(Constant.noselect);
        return;
    }
    top.Dialog.confirm(Constant.deletzMsg, function(){
        $.post(contextPath + "${packageName?replace(".","/")}/delete${className}.do", getSelectId(grid), function(){
            refresh(true);
        }, "json");
    });
}

// 获取所有选中的业务编号 格式为 ids=1&ids=2
function getSelectId(grid){
    var selectedRows = grid.getSelectedRows();
    var selectedRowsLength = selectedRows.length;
    var ids = "";
    
    for (var i = 0; i < selectedRowsLength; i++) {
        ids += selectedRows[i].${pkname?lower_case} + "#" +
        moduleid +
        ",";
    }
    return {
        "ids": ids
    };
}

// 查询
function btnSearch(){
    // 查询已计提
    $("#optype").val(Resource.selquery);
    searchHandler();
}

// 查询
function searchHandler(){
    var query = $.getHtmlToArray($("#queryForm"));
    grid.setOptions({
        params: query
    });
    //页号重置为1
    grid.setNewPage(1);
    //加载数据
    grid.loadData();
}

// 重置
function resetHandler2(){
    //表单常规元素还原
    $("#queryForm")[0].reset();
    var loginorgid = $("#loginorgid").val();
     //自动提示框还原
    $("#suggestorgid>input:eq(0)").val(loginorgid);
    //下拉框还原
    $("#queryForm").find("select").render();
    $("#optype").val(Resource.selquery);
    
    // 重新查询
    searchHandler();
    // 重置功能按钮
    controlGridBtn();
}

//刷新表格数据并重置排序和页数
function refresh(isUpdate){
    $("#" + grid.id + " tr[class*='l-selected']").removeClass("l-selected");
    if (isUpdate) {
        //重置排序
        grid.options.sortName = '${pkname?lower_case}';
        grid.options.sortOrder = "desc";
        //页号重置为1
        grid.setNewPage(1);
    }
    grid.loadData();
    // 重置功能按钮
    controlGridBtn();
}

/*****************************************************页面按钮控制*****************************************************/
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
        "quigrid": grid,
        "isCustom": true,
        "customModel": "cd"
    }
    $.getSelectRows(obj);
}

function onGridAfterShowData(data){
    controlGridBtn();
}
/**
 * 查看明细
 */
function viewDetail(){
	var rows = grid.getSelectedRows();
	var rowsLength = rows.length;
	if(rowsLength != 1) {
		top.Dialog.alert('<s:text name="label.select.noselect"></s:text>');
		return;
	}
	var ${pkname?lower_case}=rows[0].${pkname?lower_case};
	if(${pkname?lower_case}=="" || ${pkname?lower_case}==null){
		alert("合计行 不能 编辑、查看、删除!");
		return;
		}
	var url = contextPath+'${packageName?replace(".","/")}/init${className}View.do?slCountDrawDto.${pkname?lower_case}='+${pkname?lower_case};
	
	openBigWindow(url,Resource.dealModuleName + Constant.line + Constant.view, 900, 800);
}
