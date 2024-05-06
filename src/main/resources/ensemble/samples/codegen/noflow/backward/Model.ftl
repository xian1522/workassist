package com.joyin.ticm${packageName}.model;

import com.joyin.ticm.bean.DataForm;

<#list importList as import>
import ${import};
</#list>

/**
 *  ${table.comment!}
 */
public class ${className} extends DataForm {

    private static final long serialVersionUID = 1L;

<#list table.columns as column>
    private ${column.typeName} ${column.name};  <#if column.comment??> // ${column.comment} </#if>
</#list>


<#if subTable??>
    private List<${subClassName}> ${subClassName?uncap_first}List;
</#if>

<#list table.columns as column>
    public ${column.typeName} get${column.name?cap_first}() {
    return this.${column.name};
    }
    public void set${column.name?cap_first}(${column.typeName} ${column.name}) {
    this.${column.name} = ${column.name};
    }
</#list>
<#if subTable??>
    public List<${subClassName}> get${subClassName}List() {
    return ${subClassName?uncap_first}List;
    }

    public void set${subClassName}List(List<${subClassName}> ${subClassName?uncap_first}List) {
    this.${subClassName?uncap_first}List = ${subClassName?uncap_first}List;
    }
</#if>
}