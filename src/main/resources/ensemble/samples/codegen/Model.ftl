package com.joyin.ticm${packageName}.model;

<#list importList as import>
import ${import};
</#list>

import com.joyin.ticm.bean.DataForm;

public class ${className} extends DataForm {

    private static final long serialVersionUID = 1L;

<#list table.columns as column>
    private ${column.typeName} ${column.name};  <#if column.comment??> // ${column.comment} </#if>
</#list>

<#list table.columns as column>
    public ${column.typeName} get${column.name?cap_first}() {
        return this.${column.name};
    }
    public void set${column.name?cap_first}(${column.typeName} ${column.name}) {
        this.${column.name} = ${column.name};
    }
</#list>
}