package ensemble.samples.codegen;

import cn.hutool.db.Db;
import cn.hutool.db.Entity;
import cn.hutool.db.ds.DSFactory;
import cn.hutool.db.ds.simple.SimpleDataSource;
import cn.hutool.db.handler.EntityListHandler;
import cn.hutool.db.meta.Column;
import cn.hutool.db.meta.MetaUtil;
import cn.hutool.db.meta.Table;
import cn.hutool.db.sql.SqlExecutor;
import freemarker.cache.ClassTemplateLoader;
import freemarker.cache.FileTemplateLoader;
import freemarker.cache.MultiTemplateLoader;
import freemarker.cache.TemplateLoader;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import freemarker.template.TemplateExceptionHandler;
import javafx.fxml.FXML;
import javafx.scene.control.*;
import javafx.stage.DirectoryChooser;
import javafx.stage.FileChooser;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;

import javax.sql.DataSource;
import java.io.*;
import java.net.URL;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.SQLException;
import java.util.*;

public class CodeGenController {
    @FXML
    private TextField tablename;
    @FXML
    private TextField subTableName;
    @FXML
    private TextField cdTablename;
    @FXML
    private TextField subCdTablename;
    @FXML
    private ComboBox isKeepAccount; //是否记账
    @FXML
    private ComboBox isSafeFlow; //是否维护流程
    @FXML
    private TabPane tabPane;
    @FXML
    private Label fileDirectory;

    private final String BUSINESS_PATH = "Ticm_Business/src/main/java/com/joyin/ticm";

    @FXML
    public void generateCode(){
        Tab selectedItem = tabPane.getSelectionModel().getSelectedItem();

        String fileDirectoryText = fileDirectory.getText();
        if(StringUtils.isEmpty(fileDirectoryText)) {
            Alert warning = new Alert(Alert.AlertType.WARNING);
            warning.setContentText("文件路径不能为空!");
            warning.showAndWait();
            return;
        }

        if(selectedItem.getId().equals("dealTab")) {
            generateDealCode();
        }else if(selectedItem.getId().equals("countdrawTab")){
            generateCountDrawCode();
        }
    }

    @FXML
    public void openFileDialog() {
        DirectoryChooser directoryChooser = new DirectoryChooser();
        if(StringUtils.isNotEmpty(fileDirectory.getText())) {
            directoryChooser.setInitialDirectory(new File(fileDirectory.getText()));
        }
        directoryChooser.setTitle("项目路径");
        File file = directoryChooser.showDialog(null);
        if(file != null) {
            fileDirectory.setText(file.getAbsolutePath());
        }
    }

    @FXML
    public void reset() {
        fileDirectory.setText(null);
        tablename.setText(null);
        subTableName.setText(null);
        cdTablename.setText(null);
        subCdTablename.setText(null);
        isKeepAccount.setValue(null);
        isSafeFlow.setValue(null);
    }


    public void generateDealCode() {

        String tablename = this.tablename.getText();
        if(tablename == null || tablename.trim().length() == 0) {
            Alert warning = new Alert(Alert.AlertType.WARNING);
            warning.setContentText("主表不能为空!");
            warning.showAndWait();
            return;
        }
        if(isKeepAccount.getValue() == null) {
            Alert warning = new Alert(Alert.AlertType.WARNING);
            warning.setContentText("是否记账不能为空!");
            warning.showAndWait();
            return;
        }
        if(isSafeFlow.getValue() == null) {
            Alert warning = new Alert(Alert.AlertType.WARNING);
            warning.setContentText("是否维护流程不能为空!");
            warning.showAndWait();
            return;
        }

        Map root = new HashMap();

        TableGen table = processDataBaseMeta(tablename);
        processTableData(table, root);
        //处理子表
        if(StringUtils.isNotEmpty(subTableName.getText())) {
            TableGen subTable = processDataBaseMeta(subTableName.getText());
            processTableDataSub(subTable, root);
        }
        try {
            List<Template> templateList = processTemplate("DEAL");

            OutputStream out = null;

            String packageName = root.get("packageName").toString().replace(".", "/") ;


            for (Template template: templateList) {

                String generateFilePath = fileDirectory.getText() + "/";

                String templateName = template.getName();

                String className = root.get("className").toString();
                Object subClassName = root.get("subClassName");

                if(templateName.indexOf("JavaScript") > 0 || templateName.indexOf("Jsp") > 0) {
                    if(templateName.startsWith("Sub")) {
                        className = StringUtils.uncapitalize(subClassName.toString());
                    }else{
                        className = StringUtils.uncapitalize(className);
                    }
                }

                if("Model.ftl".equals(templateName)) {
                    generateFilePath += BUSINESS_PATH + packageName + "/model/" + className + ".java";
                }else if("SubModel.ftl".equals(templateName)){
                    generateFilePath += BUSINESS_PATH + packageName + "/model/" + subClassName + ".java";
                }else if("Hibernate.ftl".equals(templateName)) {
                    generateFilePath += className + ".hbm.xml";
                }else if("SubHibernate.ftl".equals(templateName)) {
                    generateFilePath += subClassName + ".hbm.xml";
                }else if("Config.ftl".equals(templateName)){
                    generateFilePath += className + ".xml";
                }else if(templateName.indexOf("JavaScript") > 0){
                    int endIndex = templateName.indexOf("JavaScript");
                    generateFilePath += "Ticm/WebRoot/javascript" + packageName + "/"
                            +className + templateName.substring(0, endIndex) + ".js";
                }else if(templateName.indexOf("Jsp") > 0){
                    int endIndex = templateName.indexOf("Jsp");
                    generateFilePath += "Ticm/WebRoot/pages" + packageName + "/"
                            +className + templateName.substring(0, endIndex) + ".jsp";
                }else {
                    if("Dao.ftl".equals(templateName)) {
                        generateFilePath += BUSINESS_PATH + packageName + "/dao/" + className + templateName.replace("ftl","java");
                    }else if("DaoImpl.ftl".equals(templateName)) {
                        generateFilePath += BUSINESS_PATH + packageName + "/dao/impl/" + className + templateName.replace("ftl","java");
                    }else if("Service.ftl".equals(templateName)) {
                        generateFilePath += BUSINESS_PATH + packageName + "/service/" + className + templateName.replace("ftl","java");
                    }else if("ServiceImpl.ftl".equals(templateName)) {
                        generateFilePath += BUSINESS_PATH + packageName + "/service/impl/" + className + templateName.replace("ftl","java");
                    }else if("Action.ftl".equals(templateName)) {
                        generateFilePath += "Ticm/src/main/java/com/joyin/ticm"
                                + packageName + "/action/" + className + templateName.replace("ftl","java");
                    }else if("KeepAccount.ftl".equals(templateName)) {
                        generateFilePath += BUSINESS_PATH + "/ka/" + packageName.substring(1, packageName.lastIndexOf("/")) + "/"
                                + className +templateName.replace("ftl","java");
                    }
                }


                File generateFile = new File(generateFilePath);

                out = FileUtils.openOutputStream(generateFile);

                Writer writer = new OutputStreamWriter(out);

                template.process(root, writer);

                BufferedWriter bufferedWriter = new BufferedWriter(writer);//缓冲
                String s = "";
                bufferedWriter.write(s);
                bufferedWriter.flush();
                bufferedWriter.close();
            }
        } catch (IOException | TemplateException e) {
            e.printStackTrace();
        }

        Alert success = new Alert(Alert.AlertType.INFORMATION);
        success.setContentText("模板数据生成成功");
        success.show();
    }

    /**
     * 生成计提模块代码
     */
    public void generateCountDrawCode() {

        String tablename = this.cdTablename.getText();
        if(tablename == null || tablename.trim().length() == 0) {
            Alert warning = new Alert(Alert.AlertType.WARNING);
            warning.setContentText("主表名不能为空!");
            warning.showAndWait();
            return;
        }

        String subTablename = this.subCdTablename.getText();
        if(subTablename == null || subTablename.trim().length() == 0) {
            Alert warning = new Alert(Alert.AlertType.WARNING);
            warning.setContentText("子表名不能为空!");
            warning.showAndWait();
            return;
        }

        //设置默认值
        isKeepAccount.setValue("是");
        isSafeFlow.setValue("否");

        Map root = new HashMap();

        TableGen table = processDataBaseMeta(tablename);
        processTableData(table, root);
        //处理子表
        if(StringUtils.isNotEmpty(subTablename)) {
            TableGen subTable = processDataBaseMeta(subTablename);
            processTableDataSub(subTable, root);
        }
        try {
            List<Template> templateList = processTemplate("COUNTDRAW");

            OutputStream out = null;

            String packageName = root.get("packageName").toString().replace(".", "/") ;

            for (Template template: templateList) {

                String generateFilePath = fileDirectory.getText() + "/";

                String templateName = template.getName();

                String className = root.get("className").toString();
                Object subClassName = root.get("subClassName");

                if(templateName.indexOf("JavaScript") > 0 || templateName.indexOf("Jsp") > 0) {
                    if(templateName.startsWith("Sub")) {
                        className = StringUtils.uncapitalize(subClassName.toString());
                    }else{
                        className = StringUtils.uncapitalize(className);
                    }
                    generateFilePath += "front/";
                }else {
                    generateFilePath += "backward/";
                }
                if("Model.ftl".equals(templateName)) {
                    generateFilePath += BUSINESS_PATH + packageName + "/model/" + className + ".java";
                }else if("SubModel.ftl".equals(templateName)){
                    generateFilePath += BUSINESS_PATH + packageName + "/model/" + subClassName + ".java";
                }else if("Hibernate.ftl".equals(templateName)) {
                    generateFilePath += className + ".hbm.xml";
                }else if("SubHibernate.ftl".equals(templateName)) {
                    generateFilePath += subClassName + ".hbm.xml";
                }else if("Config.ftl".equals(templateName)){
                    generateFilePath += className + ".xml";
                }else if(templateName.indexOf("JavaScript") > 0){
                    int endIndex = templateName.indexOf("JavaScript");
                    generateFilePath += "Ticm/WebRoot/javascript" + packageName + "/"
                            +className + templateName.substring(0, endIndex) + ".js";
                }else if(templateName.indexOf("Jsp") > 0){
                    int endIndex = templateName.indexOf("Jsp");
                    generateFilePath += "Ticm/WebRoot/pages" + packageName + "/"
                            +className + templateName.substring(0, endIndex) + ".jsp";
                }else {
                    templateName = StringUtils.substringAfter(templateName,"CountDraw");

                    if("Dao.ftl".equals(templateName)) {
                        generateFilePath += BUSINESS_PATH + packageName + "/dao/" + className +templateName.replace("ftl","java");
                    }else if("DaoImpl.ftl".equals(templateName)) {
                        generateFilePath += BUSINESS_PATH + packageName + "/dao/impl/" + className + templateName.replace("ftl","java");
                    }else if("Service.ftl".equals(templateName)) {
                        generateFilePath += BUSINESS_PATH + packageName + "/service/"+ className + templateName.replace("ftl","java");
                    }else if("ServiceImpl.ftl".equals(templateName)) {
                        generateFilePath += BUSINESS_PATH + packageName + "/service/impl/"+ className + templateName.replace("ftl","java");
                    }else if("Action.ftl".equals(templateName)) {
                        generateFilePath += "Ticm/src/main/java/com/joyin/ticm"
                                + packageName + "/action/" + className + templateName.replace("ftl","java");
                    }else if("KeepAccount.ftl".equals(templateName)) {
                        generateFilePath += BUSINESS_PATH + "/ka/" + packageName.substring(1, packageName.lastIndexOf("/")) + "/"
                                + className +templateName.replace("ftl","java");
                    }
                }


                File generateFile = new File(generateFilePath);

                out = FileUtils.openOutputStream(generateFile);

                Writer writer = new OutputStreamWriter(out);

                template.process(root, writer);

                BufferedWriter bufferedWriter = new BufferedWriter(writer);//缓冲
                String s = "";
                bufferedWriter.write(s);
                bufferedWriter.flush();
                bufferedWriter.close();
            }
        } catch (IOException | TemplateException e) {
            e.printStackTrace();
        }

        Alert success = new Alert(Alert.AlertType.INFORMATION);
        success.setContentText("模板数据生成成功");
        success.show();
    }


    public List<Template> processTemplate(String templateType) {

        List<Template> templateList = new ArrayList<>();

        Configuration configuration = new Configuration(Configuration.VERSION_2_3_22);

        try {

            FileTemplateLoader ftl1 = new FileTemplateLoader(new File("E:/Users/Administrator/workassist/target/classes/ensemble/samples/codegen/backward"));
            FileTemplateLoader ftl2 = new FileTemplateLoader(new File("E:/Users/Administrator/workassist/target/classes/ensemble/samples/codegen/front"));
            TemplateLoader[] loaders = new TemplateLoader[] { ftl1, ftl2 };
            MultiTemplateLoader mtl = new MultiTemplateLoader(loaders);
            configuration.setTemplateLoader(mtl);
//            configuration.setDirectoryForTemplateLoading(new File("E:/Users/Administrator/workassist/target/classes/ensemble/samples/codegen"));
            configuration.setDefaultEncoding("UTF-8");
            configuration.setTemplateExceptionHandler(TemplateExceptionHandler.RETHROW_HANDLER);

            if("DEAL".equals(templateType)) {
                Template actionTemplate = configuration.getTemplate("Action.ftl");
                Template serviceTemplate = configuration.getTemplate("Service.ftl");
                Template serviceImplTemplate = configuration.getTemplate("ServiceImpl.ftl");
                Template daoTemplate = configuration.getTemplate("Dao.ftl");
                Template daoimplTemplate = configuration.getTemplate("DaoImpl.ftl");
                Template modelTemplate = configuration.getTemplate("Model.ftl");
                Template hibenateTemplate = configuration.getTemplate("Hibernate.ftl");
                Template configTemplate = configuration.getTemplate("Config.ftl");
                Template keepAccountTemplate = configuration.getTemplate("KeepAccount.ftl");

                Template managerJsTemplate = configuration.getTemplate("ManagerJavaScript.ftl");
                Template editJsTemplate = configuration.getTemplate("EditJavaScript.ftl");
                Template managerJspTemplate = configuration.getTemplate("ManagerJsp.ftl");
                Template searchJspTemplate = configuration.getTemplate("SearchJsp.ftl");
                Template baseTemplate = configuration.getTemplate("BaseJsp.ftl");
                Template editTemplate = configuration.getTemplate("EditJsp.ftl");
                Template remarkTemplate = configuration.getTemplate("RemarkJsp.ftl");
                Template userInfoTemplate = configuration.getTemplate("UserInfoJsp.ftl");

                Template subModelTemplate = configuration.getTemplate("SubModel.ftl");
                Template subHiberateTemplate = configuration.getTemplate("SubHibernate.ftl");
                Template subJspTemplate = configuration.getTemplate("SubJsp.ftl");

                templateList.add(actionTemplate);
                templateList.add(serviceTemplate);
                templateList.add(serviceImplTemplate);
                templateList.add(daoTemplate);
                templateList.add(daoimplTemplate);
                templateList.add(modelTemplate);
                templateList.add(hibenateTemplate);
                templateList.add(configTemplate);
                if (isKeepAccount.getValue().equals("是")) {
                    templateList.add(keepAccountTemplate);
                }
                if (StringUtils.isNotEmpty(subTableName.getText())) {
                    templateList.add(subModelTemplate);
                    templateList.add(subHiberateTemplate);
                    templateList.add(subJspTemplate);
                }

                templateList.add(managerJsTemplate);
                templateList.add(editJsTemplate);
                templateList.add(managerJspTemplate);
                templateList.add(baseTemplate);
                templateList.add(editTemplate);
                templateList.add(remarkTemplate);
                templateList.add(userInfoTemplate);
                templateList.add(searchJspTemplate);
            } else if("COUNTDRAW".equals(templateType)) {
                Template countdrawEditTemplate = configuration.getTemplate("CountDrawEditJsp.ftl");
                Template countdrawFindManagerTemplate = configuration.getTemplate("CountDrawFindManagerJsp.ftl");
                Template countdrawFindManagerJsTemplate = configuration.getTemplate("CountDrawFindManagerJavaScript.ftl");
                Template countdrawManagerTemplate = configuration.getTemplate("CountDrawManagerJsp.ftl");
                Template countdrawManagerJsTemplate = configuration.getTemplate("CountDrawManagerJavaScript.ftl");
                Template countdrawViewTemplate = configuration.getTemplate("CountDrawViewJsp.ftl");

                templateList.add(countdrawEditTemplate);
                templateList.add(countdrawFindManagerTemplate);
                templateList.add(countdrawFindManagerJsTemplate);
                templateList.add(countdrawManagerTemplate);
                templateList.add(countdrawManagerJsTemplate);
                templateList.add(countdrawViewTemplate);


                Template modelTemplate = configuration.getTemplate("Model.ftl");
                Template hibenateTemplate = configuration.getTemplate("Hibernate.ftl");
                Template configTemplate = configuration.getTemplate("CountDrawConfig.ftl");
                Template keepAccountTemplate = configuration.getTemplate("CountDrawKeepAccount.ftl");
                Template subModelTemplate = configuration.getTemplate("SubModel.ftl");
                Template subHiberateTemplate = configuration.getTemplate("SubHibernate.ftl");


                Template actionTemplate = configuration.getTemplate("CountDrawAction.ftl");
                Template serviceTemplate = configuration.getTemplate("CountDrawService.ftl");
                Template serviceImplTemplate = configuration.getTemplate("CountDrawServiceImpl.ftl");
                Template daoTemplate = configuration.getTemplate("CountDrawDao.ftl");
                Template daoimplTemplate = configuration.getTemplate("CountDrawDaoImpl.ftl");

                templateList.add(keepAccountTemplate);
                templateList.add(subModelTemplate);
                templateList.add(subHiberateTemplate);
                templateList.add(modelTemplate);
                templateList.add(hibenateTemplate);
                templateList.add(configTemplate);

                templateList.add(actionTemplate);
                templateList.add(serviceTemplate);
                templateList.add(serviceImplTemplate);
                templateList.add(daoTemplate);
                templateList.add(daoimplTemplate);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return templateList;
    }

    public TableGen processDataBaseMeta(String tableName) {

        tableName = StringUtils.upperCase(tableName);

        DataSource ds = DSFactory.get();
        Table table =  MetaUtil.getTableMeta(ds, tableName);

        HashSet<String> importList = new HashSet<String>();

        for(Column column : table.getColumns()) {
            String name = StringUtils.lowerCase(column.getName());
            column.setName(name);

            int jdbcType = column.getType();
            String javaType = "";
            if(jdbcType == Db2ColumnType.VARCHAR.getJdbcType()){
                javaType = Db2ColumnType.VARCHAR.getJavaType();
            }else if(jdbcType == Db2ColumnType.CHAR.getJdbcType()) {
                javaType = Db2ColumnType.CHAR.getJavaType();
            }else if(jdbcType == Db2ColumnType.DATE.getJdbcType()) {
                javaType = Db2ColumnType.DATE.getJavaType();
                importList.add("java.util.Date");
            }else if(jdbcType == Db2ColumnType.DECIMAL.getJdbcType()) {
                javaType = Db2ColumnType.DECIMAL.getJavaType();
                importList.add("java.math.BigDecimal");
            }else if(jdbcType == Db2ColumnType.TIMESTAPME.getJdbcType()) {
                javaType = Db2ColumnType.TIMESTAPME.getJavaType();
                importList.add("java.sql.Timestamp");
            }else if(jdbcType == Db2ColumnType.INTEGER.getJdbcType()) {
                javaType = Db2ColumnType.INTEGER.getJavaType();
            }else if(jdbcType == Db2ColumnType.BIGINT.getJdbcType()) {
                javaType = Db2ColumnType.BIGINT.getJavaType();
            }
            column.setTypeName(javaType);
        }

        TableGen tableGen = new TableGen();
        tableGen.setImportList(importList);
        tableGen.setTable(table);

        return tableGen;
    }

    private void processTableData(TableGen tableGen, Map root){
        Table table = tableGen.getTable();
        root.put("table",table);

        String[] tableNames = table.getTableName().split("_");
        String packageName = "";
        String className = "";
        for(String tempTableName : tableNames){
            tempTableName = tempTableName.toLowerCase();
            className += StringUtils.capitalize(tempTableName);
            packageName += "." + tempTableName;
        }

        root.put("className", className);
        root.put("packageName", packageName);
        root.put("importList", tableGen.getImportList());
        root.put("pkname",table.getPkNames().stream().findFirst().get());

        root.put("isKeepAccount", isKeepAccount.getValue());
        root.put("isSafeFlow", isSafeFlow.getValue());
    }

    private void processTableDataSub(TableGen tableGen, Map root) {
        Table subTable = tableGen.getTable();

        root.put("subTable",subTable);

        String[] tableNames = subTable.getTableName().split("_");
        String packageName = "";
        String className = "";
        for(String tempTableName : tableNames){
            tempTableName = tempTableName.toLowerCase();
            className += StringUtils.capitalize(tempTableName);
            packageName += "." + tempTableName;
        }

        root.put("subImportList", tableGen.getImportList());

        HashSet<String> importList = (HashSet<String>)root.get("importList");
        importList.add("java.util.List");

        root.put("subClassName", className);
    }

    public ComboBox getIsKeepAccount() {
        return isKeepAccount;
    }

    public ComboBox getIsSafeFlow() {
        return isSafeFlow;
    }
}
