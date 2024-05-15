<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE struts PUBLIC "-//Apache Software Foundation//DTD Struts Configuration 2.1//EN" 
	"http://struts.apache.org/dtds/struts-2.1.dtd">
<struts>
	<package name="${className?uncap_first}" namespace="${packageName?replace(".","/")}" extends="abstract_struts">
		<action name="init${className}Manager" class="${className?uncap_first}Action" method="init${className}Manager">
			<result name="success">
				/pages${packageName?replace(".","/")}/${className?uncap_first}Manager.jsp
			</result>
		</action>
		
		<action name="init${className}Add" class="${className?uncap_first}Action" method="init${className}Add">
			<result name="success">
				/pages${packageName?replace(".","/")}/${className?uncap_first}Edit.jsp
			</result>
		</action>
		
		<action name="init${className}Edit" class="${className?uncap_first}Action" method="init${className}Edit">
			<result name="success">
				/pages${packageName?replace(".","/")}/${className?uncap_first}Edit.jsp
			</result>
		</action>
<#if isSafeFlow == "是">
		<action name="safe${className}" class="${className?uncap_first}Action" method="safe${className}">
			<result name="success">
				/pages${packageName?replace(".","/")}/${className?uncap_first}SafeEdit.jsp
			</result>
		</action>
</#if>
		<action name="init${className}View" class="${className?uncap_first}Action" method="init${className}View">
			<result name="success">
				/pages${packageName?replace(".","/")}/${className?uncap_first}View.jsp
			</result>
		</action>
		<action name="*" class="${className?uncap_first}Action" method="{1}">
            <result name="{1}" type="json">
                <param name="root">results</param>
            </result>
        </action>
	</package>
	<package name="${className?uncap_first}Flow" namespace="${packageName?replace(".","/")}/flow" extends="abstract_struts">
        <action name="*_*" class="${className?uncap_first}Action" method="{2}">
			<result name="{1}">/pages${packageName?replace(".","/")}/{1}.jsp</result>
			<result name="error">/pages/common/errors/error.jsp</result>
		</action>
	</package>
</struts>



<bean name="${className?uncap_first}Dao" class="com.joyin.ticm${packageName}.dao.impl.${className}DaoImpl">
	<property name="sessionFactory" ref="sessionFactory"></property>
</bean>


DELETE FROM SYS_MODULE WHERE MODULEID = '21';
DELETE FROM SYS_MODULE WHERE MODULEID = '2101';
INSERT INTO SYS_MODULE (MODULEID, MODULENAME, FUMODULEID, BUSINESSTYPE, INNERITEM, ORDNO, MODULEORDER, MODULELEVEL, WORKFLOWFLAG, ORGPERMIT, TARGETURL, ISCONTROL, ISINTRADAY, ISRUN, ISONLY, OPENTYPE, DETAILURL, LSTMNTDATE, LSTMNTUSER, FIELD1, FIELD2, FIELD3, FIELD4, FIELD5)
VALUES('21', '预期收益型产品', '0', 'EXPECT', '0', 0, 0, 2, 'Y', 'C', '', ' ', ' ', NULL, 'N', ' ', '', sysdate, 'admin', '', '', '', '', '');
INSERT INTO SYS_MODULE (MODULEID, MODULENAME, FUMODULEID, BUSINESSTYPE, INNERITEM, ORDNO, MODULEORDER, MODULELEVEL, WORKFLOWFLAG, ORGPERMIT, TARGETURL, ISCONTROL, ISINTRADAY, ISRUN, ISONLY, OPENTYPE, DETAILURL, LSTMNTDATE, LSTMNTUSER, FIELD1, FIELD2, FIELD3, FIELD4, FIELD5)
VALUES('2101', '${table.comment!}', '21', 'EXPECT', '1', 0, 1, 3, 'Y', 'C', '${packageName?replace(".","/")}/init${className}Manager.do', ' ', ' ', NULL, 'N', ' ', '', sysdate, 'admin', '', '', '', '', '');

DELETE FROM SYS_FLOW_TASK WHERE FLOW_KEY = '${className}Flow';
INSERT INTO SYS_FLOW_TASK (MODULEID, FLOW_KEY, TASK_NAME, GROUPID, ORGPERMIT, DETAILURL, TASK_ORDER, LSTMNTDATE, LSTMNTUSER, EFFECTFLAG, FIELD1, FIELD2, FIELD3, FIELD4, FIELD5, OPORGKEY, OPTTYPE, SERVICENAME)
VALUES('2101', '${className}Flow', '经办', 1, NULL, '${packageName?replace(".","/")?substring(1)}/flow/${className?uncap_first}Edit_${className?uncap_first}Flow', 1, sysdate, 'gqliu', 'E', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO SYS_FLOW_TASK (MODULEID, FLOW_KEY, TASK_NAME, GROUPID, ORGPERMIT, DETAILURL, TASK_ORDER, LSTMNTDATE, LSTMNTUSER, EFFECTFLAG, FIELD1, FIELD2, FIELD3, FIELD4, FIELD5, OPORGKEY, OPTTYPE, SERVICENAME)
VALUES('2101', '${className}Flow', '复核', 1, NULL, '${packageName?replace(".","/")?substring(1)}/flow/${className?uncap_first}Audit_${className?uncap_first}Flow', 2, sysdate, 'gqliu', 'E', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

<#if isNewFlow == "是">
DELETE FROM SYS_MODULE_BTN WHERE MODULEID = '3101';
INSERT INTO SYS_MODULE_BTN (MODULEID, PROCID, BTNNAME, BTNJS, FIELD1, FIELD2, FIELD3, FIELD4, FIELD5) VALUES('3101', 1, '新增 ', '$("#scrollContent .icon_add").slice(0,1).parent("div").hide();$("#scrollContent .icon_add").slice(0,1).parent("div").next().hide();', NULL, NULL, NULL, NULL, NULL);
INSERT INTO SYS_MODULE_BTN (MODULEID, PROCID, BTNNAME, BTNJS, FIELD1, FIELD2, FIELD3, FIELD4, FIELD5) VALUES('3101', 2, '编辑', '$("#scrollContent .icon_edit").slice(0,1).parent("div").hide();$("#scrollContent .icon_edit").slice(0,1).parent("div").next().hide();', NULL, NULL, NULL, NULL, NULL);
INSERT INTO SYS_MODULE_BTN (MODULEID, PROCID, BTNNAME, BTNJS, FIELD1, FIELD2, FIELD3, FIELD4, FIELD5) VALUES('3101', 3, '删除', '$("#scrollContent .icon_delete").slice(0,1).parent("div").hide();$("#scrollContent .icon_delete").slice(0,1).parent("div").next().hide();', NULL, NULL, NULL, NULL, NULL);
INSERT INTO SYS_MODULE_BTN (MODULEID, PROCID, BTNNAME, BTNJS, FIELD1, FIELD2, FIELD3, FIELD4, FIELD5) VALUES('3101', 4, '查看流程', '$("#scrollContent .icon_viewflow").slice(0,1).parent("div").hide();$("#scrollContent .icon_viewflow").slice(0,1).parent("div").next().hide();', NULL, NULL, NULL, NULL, NULL);
INSERT INTO SYS_MODULE_BTN (MODULEID, PROCID, BTNNAME, BTNJS, FIELD1, FIELD2, FIELD3, FIELD4, FIELD5) VALUES('3101', 5, '办理流程', '$("#scrollContent .icon_ok").slice(0,1).parent("div").hide();$("#scrollContent .icon_ok").slice(0,1).parent("div").next().hide();', NULL, NULL, NULL, NULL, NULL);
INSERT INTO SYS_MODULE_BTN (MODULEID, PROCID, BTNNAME, BTNJS, FIELD1, FIELD2, FIELD3, FIELD4, FIELD5) VALUES('3101', 6, '审批单', '$("#scrollContent .icon_print").slice(0,1).parent("div").hide();$("#scrollContent .icon_print").slice(0,1).parent("div").next().hide();', NULL, NULL, NULL, NULL, NULL);
INSERT INTO SYS_MODULE_BTN (MODULEID, PROCID, BTNNAME, BTNJS, FIELD1, FIELD2, FIELD3, FIELD4, FIELD5) VALUES('3101', 7, '查询', '$("#searchForm .icon_find").slice(0,1).parent("button").hide();$("#searchForm .icon_find").slice(0,1).parent("button").next().hide();', NULL, NULL, NULL, NULL, NULL);
INSERT INTO SYS_MODULE_BTN (MODULEID, PROCID, BTNNAME, BTNJS, FIELD1, FIELD2, FIELD3, FIELD4, FIELD5) VALUES('3101', 8, '重置', '$("#searchForm .icon_clear").slice(0,1).parent("button").hide();$("#searchForm .icon_clear").slice(0,1).parent("button").next().hide();', NULL, NULL, NULL, NULL, NULL);

delete from SYS_ROLEPERMIT t where t.moduleid IN ('3101') ;
insert  into SYS_ROLEPERMIT
select S_SYS_ROLEPERMIT.nextval,ROLEID,'3101' ,'',null,null from SYS_ROLE  where ROLENAME = 'admin1';

INSERT INTO SYS_ROLEPERMIT(ID, ROLEID, MODULEID, PROCID)
SELECT S_SYS_ROLEPERMIT.nextval, ROLEID, MODULEID, PROCID
FROM SYS_MODULE_BTN
LEFT JOIN SYS_ROLE ON ROLENAME = 'admin1'
where moduleid IN ('3101');
</#if>