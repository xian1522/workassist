<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE hibernate-mapping PUBLIC "-//Hibernate/Hibernate Mapping DTD 3.0//EN"
        "http://hibernate.sourceforge.net/hibernate-mapping-3.0.dtd">
<hibernate-mapping>
    <class name="com.joyin.ticm${packageName}.model.${className}" table="${table.tableName}">
<#list table.columns as column>
    <#if column.isPk() == true>
        <id name="${column.name}" type="${column.typeName}">
            <column name="${column.name?upper_case}" length="${column.size}" />
            <generator class="assigned"></generator>
        </id>
    <#elseif column.name == "lstmntdate">
        <timestamp name="${column.name}" column="${column.name?upper_case}" source="db"/>
    <#elseif column.name == "createdate">
        <property name="${column.name}" generated="insert" not-null="true">
            <column name="${column.name?upper_case}" sql-type="timestamp" default="CURRENT_TIMESTAMP" />
        </property>
    <#elseif column.typeName == "BigDecimal">
        <property name="${column.name}" type="java.math.BigDecimal">
            <column name="${column.name?upper_case}" precision="${column.size}" scale="${column.digit}">
            </column>
        </property>
    <#else>
        <property name="${column.name}" type="${column.typeName?uncap_first}">
            <column name="${column.name?upper_case}" length="${column.size}">
            </column>
        </property>
    </#if>
</#list>
    </class>
</hibernate-mapping>
