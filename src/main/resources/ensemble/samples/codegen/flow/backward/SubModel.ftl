package com.joyin.ticm${packageName}.model;

<#list subImportList as import>
import ${import};
</#list>

import com.joyin.ticm.bean.DataForm;


/**
 *  ${table.comment!}
 */
public class ${subClassName} extends DataForm {

    private static final long serialVersionUID = 1L;

<#list subTable.columns as column>
    private ${column.typeName} ${column.name};  <#if column.comment??> // ${column.comment} </#if>
</#list>

<#list subTable.columns as column>
    public ${column.typeName} get${column.name?cap_first}() {
        return this.${column.name};
    }
    public void set${column.name?cap_first}(${column.typeName} ${column.name}) {
        this.${column.name} = ${column.name};
    }
</#list>
}