//---------------------${subTable.comment!}信息--------------------------------------//

var ${subClassName?lower_case}Grid = null;
var ${subClassName?lower_case}grid_data = {rows:[]};


function init${subClassName}GridData(${pkname?lower_case}, type){

$.post(contextPath+'${packageName?replace(".","/")}/find${subClassName}List.do' ,
	{"${className?uncap_first}.${pkname?lower_case}": ${pkname?lower_case}} , function (results) {
		${subClassName?lower_case}grid_data = results;
		if(type = "VIEW") {
			init${subClassName}View();
		}else if(type = "EDIT") {
			init${subClassName}Edit();
		}
	}, "json");
}

//初始化${subTable.comment!}信息
function init${subClassName}Edit(){
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
	{hide:true,name:"uuid"}];
  	columns = columns.concat(gridHide);
	${subClassName?lower_case}Grid = $("#${subClassName?uncap_first}Grid").quiGrid({
      columns: columns,
      data: ${subClassName?lower_case}grid_data,
      checkbox:true,
      method:'post',
	  height:'200',
      wigth:'100%',
	  alternatingRow:true,
	  percentWidthMode:false,
	  selectRowButtonOnly:false,
	  usePager:false,
	  selectRowButtonOnly:Constant.selectRowButtonOnly,
	  toolbar:{
			items: [{
				text: Constant.add,
				click: add${subClassName},
				iconClass: Constant.icon_add
			}, {
				line: true
			},{
				id:'editbutton',
				text: Constant.edit,
				click: edit${subClassName},
				iconClass: Constant.icon_edit

			}, {
				line: true
			}, {
				id:'deletebutton',
				text: Constant.deletz,
				click: delete${subClassName},
				iconClass: Constant.icon_delete

			}, {
				line: true
			}
			]
		}
  });
  	
}

/**
 *	${subTable.comment!}查看
 */
function init${subClassName}View(){
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
	{hide:true,name:"uuid"}];
  	columns = columns.concat(gridHide);
	${subClassName?lower_case}Grid = $("#${subClassName?uncap_first}Grid").quiGrid({
      columns: columns,
      data: ${subClassName?lower_case}grid_data,,
      checkbox:false,
	  height:'200',
	  wigth:'100%',
	  alternatingRow:true,
	  percentWidthMode:false,
	  selectRowButtonOnly:false,
	  usePager:false
  });
}

function add${subClassName}(){
	
	$("#${subClassName?lower_case}_table").removeAttr("style");
	$("#${subClassName?uncap_first}_index,#uuid").val('');

	var $elms = $("#${subClassName?lower_case}_table").find(':input[type="text"]');
	$($elms).each(function(i,n){
		$(this).val("");
	});
}

/**
 * 编辑${subTable.comment!}信息
 */
function edit${subClassName}(){
	var rows = ${subClassName?lower_case}Grid.getSelectedRows();
	if(rows.length != 1) {
		top.Dialog.alert("请选中一行!");
		return;
	}
	$("#${subClassName?lower_case}_table").removeAttr("style");

<#list subTable.columns as column>
	<#if column.comment??>
		<#if column.comment?index_of("字典") gt 0 >
	$("#${column.name}").attr('selectedValue',rows[0].${column.name}).render();
		<#elseif column.typeName == "Date">
	$("#${column.name}").val(rows[0].${column.name});
		<#elseif column.typeName == "BigDecimal">
	$("#${column.name}").val(rows[0].${column.name});
		<#else>
	$("#${column.name}").val(rows[0].${column.name});
		</#if>
	</#if>
</#list>
	$("#uuid").val(rows[0].uuid);
	// 选中的序号
	var index = rows[0].__index;
	$("#${subClassName?uncap_first}_index").val(index);
	setBtnDisabled("div[toolbarid='editbutton']","div[toolbarid='deletebutton']");
	
}
//保存${subTable.comment!}信息
function save${subClassName}(){

	var index = $("#${subClassName?uncap_first}_index").val();
	var uuid = $("#uuid").val();

<#list subTable.columns as column>
	<#if column.comment??>
		var ${column.name} = $("#${column.name}").val(); //${column.comment!}
	</#if>
</#list>
	if ((null == uuid  || uuid == "")&&(JOYIN.Comm.isEmpty(index))){
//		if(!JOYIN.Grid.isExist(${subClassName?lower_case}Grid,'billcode',billcodename)){
//			JOYIN.Prompt.alert("票据号["+billcodename+"]已存在");
//			return;
//		}
		uuid = JOYIN.Comm.getUuid();
	}
	var row = {
<#list subTable.columns as column>
	<#if column.comment??>
		"${column.name}":${column.name},
	</#if>
</#list>
		"uuid":uuid
	};
	var existsRow = null;
	if(!JOYIN.Comm.isEmpty(uuid)){
		existsRow = JOYIN.Grid.isExistRow(${subClassName?lower_case}Grid,"uuid",uuid);
	}
	// 如果已经存在，先删除
	if(!JOYIN.Comm.isEmpty(existsRow)){
		JOYIN.Grid.deleteRange(${subClassName?lower_case}Grid, existsRow);
	}
	
	//如果是编辑，取编辑行号
	if(!JOYIN.Comm.isEmpty(index)){
		var rows = JOYIN.Grid.getAllData(${subClassName?lower_case}Grid);
		var temprow = rows[index];
		if(!JOYIN.Comm.isEmpty(temprow)){
//			if(temprow['billcode'] != billcodename){
//				if(!JOYIN.Grid.isExist(${subClassName?lower_case}Grid,'billcode',billcodename)){
//					JOYIN.Prompt.alert("票据号["+billcodename+"]已存在");
//					return;
//				}
//			}
			JOYIN.Grid.deleteRange(${subClassName?lower_case}Grid,temprow);
		}
	}
	
	JOYIN.Grid.addRow(${subClassName?lower_case}Grid,row);
	close${subClassName}();
}

/**
 * 删除${subTable.comment!}信息
 */
function delete${subClassName}(){
	var rows = JOYIN.Grid.getSelectedRows(${subClassName?lower_case}Grid);
	var len = rows.length;
	if(len != 1){
		JOYIN.Prompt.alert("请选择一行数据");
		return false;
	}
	var row = rows[0];
	JOYIN.Grid.deleteRange(${subClassName?lower_case}Grid,row);
	// 重新装载数据
	JOYIN.Grid.reLoadData(${subClassName?lower_case}Grid);
	setBtnDisabled("div[toolbarid='editbutton']","div[toolbarid='deletebutton']");
	close${subClassName}();
}

//关闭
function close${subClassName}(){
	//隐藏
	$("#${subClassName?lower_case}_table").attr("style","display:none");
	//清空表格内数据
	var $elms = $("#${subClassName?lower_case}_table").find(':input[type="text"]');
	$($elms).each(function(i,n){
		$(this).val("");
	});
}