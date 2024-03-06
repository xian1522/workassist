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
		<action name="init${className}FindManager" class="${className?uncap_first}Action" method="init${className}FindManager">
			<result name="success">
				/pages${packageName?replace(".","/")}/${className?uncap_first}FindManager.jsp
			</result>
		</action>
		<action name="init${className}Edit" class="${className?uncap_first}Action" method="init${className}Edit">
			<result name="success">
				/pages${packageName?replace(".","/")}/${className?uncap_first}Edit.jsp
			</result>
		</action>
		<action name="init${className}View" class="${className?uncap_first}Action" method="init${className}View">
			<result name="success">
				/pages${packageName?replace(".","/")}/${className?uncap_first}View.jsp
			</result>
		</action>
		<action name="updateDetail" class="${className?uncap_first}Action" method="updateDetail">
			<result name="success" type="json">
				<param name="includeProperties">status,message</param>
			</result>
		</action>
		<action name="exportReportXlsOfPage" class="${className?uncap_first}Action" method="exportReportXlsOfPage">
			<result name="success" type="json">
				<param name="root">results</param>
			</result>
		</action>
		<action name="*" class="${className?uncap_first}Action" method="{1}">
            <result name="{1}" type="json">
                <param name="root">results</param>
            </result>
        </action>
	</package>
</struts>


<bean name="${className?uncap_first}Dao" class="com.joyin.ticm${packageName}.dao.impl.${className}DaoImpl">
	<property name="sessionFactory" ref="sessionFactory"></property>
</bean>


INSERT INTO SYS_MODULE (MODULEID, MODULENAME, FUMODULEID, BUSINESSTYPE, INNERITEM, ORDNO, MODULEORDER, MODULELEVEL, WORKFLOWFLAG, ORGPERMIT, TARGETURL, ISCONTROL, ISINTRADAY, ISRUN, ISONLY, OPENTYPE, DETAILURL, LSTMNTDATE, LSTMNTUSER, FIELD1, FIELD2, FIELD3, FIELD4, FIELD5) 
VALUES('1603', '${table.comment!}', '16', 'SL', '1', 0, 3, 2, 'Y', 'C', '${packageName?replace(".","/")}/init${className}Manager.do', ' ', ' ', NULL, 'N', ' ', '', sysdate, 'admin', '', '', '', '', '');
INSERT INTO SYS_MODULE (MODULEID, MODULENAME, FUMODULEID, BUSINESSTYPE, INNERITEM, ORDNO, MODULEORDER, MODULELEVEL, WORKFLOWFLAG, ORGPERMIT, TARGETURL, ISCONTROL, ISINTRADAY, ISRUN, ISONLY, OPENTYPE, DETAILURL, LSTMNTDATE, LSTMNTUSER, FIELD1, FIELD2, FIELD3, FIELD4, FIELD5) VALUES
('1607', '${table.comment!}查询', '16', 'SL', '1', 0, 3, 2, 'Y', 'C', '${packageName?replace(".","/")}/init${className}FindManager.do', ' ', ' ', NULL, 'N', ' ', '', sysdate, 'admin', '', '', '', '', '');
