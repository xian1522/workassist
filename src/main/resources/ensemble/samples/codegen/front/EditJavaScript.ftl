var curpage = {
    init: function(){
		//初始化下拉框
		initSelect();
    },
    /**********************新增/编辑******************************/
    edit: function(){
        this.init();
    },
    /**********************审核/审批******************************/
    audit: function(){
    	this.init();
		//置灰控件
        $(':input[id!="flowRemark"][type!="hidden"][id!="accremark"]').each(function(){
            $(this).attr('disabled', true);
        });
    },
	/**********************查看******************************/
	view:function(){
    	this.init();
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
<#if subTableName??>
//---------------------债券借贷交易质押品信息--------------------------------------//
var plegdegrid = null;
var orggrid_data = {rows:[]};

//初始化质押品列表
function initPlegdeGridEdit(){
	 var columns = [
		 {
			 display: '质押债券代码',
			 name: 'secid',
			 align: 'left',
			 width: 180
		 }, {
			 display: '质押债券名称',
			 name: 'secname',
			 align: 'left',
			 width: 180
		 }, {
			 display: '质押债券券面总额(万元)',
			 name: 'totalamtName',
			 align: 'right',
			 width: 180,
			 totalSummary: {
				   type: "sum",
				   render: function(obj){
					   return formatRound(obj.sum, 2);
				   }
			   }
		 }, {
			 display: '估值净价',
			 name: 'cpriceName',
			 align: 'right',
			 width: 180
		 },
		 {hide:true,name:"reqid"},
		 {hide:true,name:"uuid"}
	];
  }
  plegdegrid = $("#detailgrid").quiGrid({
      columns: columns,
      data: orggrid_data,
      //url: contextPath + '/issueb/deal/findIssuebDealPrinorgOfPage.do',
      	checkbox:true,
		method:'post',
		height:'200',
		wigth:'70%',
		sortName:'dbid',
		alternatingRow:true,
		percentWidthMode:true,
		selectRowButtonOnly:false,
		usePager:false,
		onSelectRow:selectRow,
		onUnSelectRow:selectRow,
		toolbar:{
		    items: [{
		    	id:'addbutton',
		        text: Constant.add,
		        click: addSlDealSchedule,
		        iconClass: Constant.icon_add
		    }, {
		        line: true
		    },{
		    	id:'editbutton',
		        text: Constant.edit,
		        click: editSlDealSchedule,
		        iconClass: Constant.icon_edit
		    }, {
		        line: true
		    }, {
		    	id:'deletebutton',
		        text: Constant.deletz,
		        click: deleteSlDealSchedule,
		        iconClass: Constant.icon_delete
		    }]
		}
  });
}

//初始化质押品列表
function initPlegdeGridView(){
  var columns =
	[
		 {
			 display: '质押债券代码',
			 name: 'secid',
			 align: 'left',
			 width: 180
		 }, {
			 display: '质押债券名称',
			 name: 'secname',
			 align: 'left',
			 width: 180
		 }, {
			 display: '质押债券券面总额(万元)',
			 name: 'totalamtName',
			 align: 'right',
			 width: 180,
			 totalSummary: {
				   type: "sum",
				   render: function(obj){
					   return formatRound(obj.sum, 2);
				   }
			   }
		 }, {
			 display: '估值净价',
			 name: 'cpriceName',
			 align: 'right',
			 width: 180
		 },
		 {hide:true,width:100,name:"reqid"}];
  	}
  plegdegrid = $("#detailgrid").quiGrid({
      columns: columns,
      data: orggrid_data,
      //url: contextPath + '/issueb/deal/findIssuebDealPrinorgOfPage.do',
      	checkbox:false,
		method:'post',
		height:'200',
		wigth:'70%',
		sortName:'dbid',
		alternatingRow:true,
		percentWidthMode:true,
		selectRowButtonOnly:false,
		usePager:false,
		onSelectRow:selectRow,
		onUnSelectRow:selectRow
  });
}

//格式化日期
$.quiDefaults.Grid.formatters['date'] = function (value, column) {
	if(value != null){
	    var arr=value.substring(0,10);
	    return arr;
    }
}

//保存质押品信息
function saveSlDealPledge(){
	var valid = $('#issuebdealprinorg_table').validationEngine({returnIsValid: true});
	if(!valid) {
		return;
	}
	
	var slreqid = $("#slreqid").val();
	var uuid = $("#uuid").val();
	if (null == uuid  || uuid == "") {
		
		if(JOYIN.InvesttypeSwich.isOpen()){
			var investtype = $("#investtype").val();
			var existsSec = JOYIN.Grid.isExistRow(plegdegrid,"secid_inv",slsecid+investtype);
			// 如果已经存在，提示
			if(!JOYIN.Comm.isEmpty(existsSec)){
				JOYIN.Prompt.alert("债券代码已经存在");
				return;
			}
		}else{
			var existsSec = JOYIN.Grid.isExistRow(plegdegrid,"secid",$("#slsecid").val());
			// 如果已经存在，提示
			if(!JOYIN.Comm.isEmpty(existsSec)){
				JOYIN.Prompt.alert("债券代码已经存在");
				return;
			}
		}
		
		
		uuid = JOYIN.Comm.getUuid();
	}
	

	row = {
		"secid":$("#slsecid").val(),
		"secname":$("#slsecname").val(),
		"totalamtName":$("#sltotalamt").val(),
		"cpriceName":$("#cprice").val(),
		"reqid":slreqid,
		"uuid":uuid
	};

	var existsRow = JOYIN.Grid.isExistRow(plegdegrid,"uuid",uuid);
	// 如果已经存在，先删除
	if(!JOYIN.Comm.isEmpty(existsRow)){
		JOYIN.Grid.deleteRange(plegdegrid,existsRow);
	}
	
	JOYIN.Grid.addRow(plegdegrid,row);
	
	closeSlDealPledge();
	
	setBtnDisabled("div[toolbarid='editbutton']","div[toolbarid='deletebutton']");
}

//删除认购人信息
function deleteSlDealSchedule(){
	var rows = JOYIN.Grid.getSelectedRows(plegdegrid);
	var len = rows.length;
	if(len != 1){
		JOYIN.Prompt.alert("请选择一行数据");
		return false;
	}
	var row = rows[0];
	JOYIN.Grid.deleteRange(plegdegrid,row);
	// 重新装载数据
	JOYIN.Grid.reLoadData(plegdegrid);
	setBtnDisabled("div[toolbarid='editbutton']","div[toolbarid='deletebutton']");
}

//关闭
function closeSlDealPledge(){
	//隐藏
	$("#issuebdealprinorg_table").attr("style","display:none");
	//清空表格内数据
	var $elms = $("#issuebdealprinorg_table").find(':input[type="text"]');
	$($elms).each(function(i,n){
		$(this).val("");
	});
}


//刷新表格数据
function refreshPrinorg() {
	setBtnDisabled("div[toolbarid='editbutton']","div[toolbarid='deletebutton']");
}

//获取所有选中的业务编号 格式为 ids=1&ids=2
function getSelectId(grid) {
	var selectedRows = grid.getSelectedRows();
	var selectedRowsLength = selectedRows.length;
	var ids = "";
	
	for ( var i = 0; i < selectedRowsLength; i++) {
		ids += selectedRows[i].seqno + ",";
	}
	return {
		"ids" : ids
	};
}
</#if>