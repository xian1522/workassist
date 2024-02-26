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
import javafx.scene.control.Alert;
import javafx.scene.control.ComboBox;
import javafx.scene.control.TextField;
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
    private ComboBox isKeepAccount; //是否记账
    @FXML
    private ComboBox isSafeFlow; //是否维护流程

    @FXML
    public void generateCode() {

        String tablename = this.tablename.getText();
        if(tablename == null || tablename.trim().length() == 0) {
            Alert warning = new Alert(Alert.AlertType.WARNING);
            warning.setContentText("表名不能为空!");
            warning.showAndWait();
            return;
        }
        Map root = processDataBaseMeta(tablename);

        try {
            List<Template> templateList = processTemplate();

            OutputStream out = null;

            for (Template template: templateList) {

                String generateFilePath = "D:\\freemarker/" + root.get("className").toString();

                String templateName = template.getName();

                if("Model.ftl".equals(templateName)) {
                    generateFilePath += ".java";
                }else if("Hibernate.ftl".equals(templateName)) {
                    generateFilePath += ".hbm.xml";
                }else if("Config.ftl".equals(templateName)){
                    generateFilePath += ".xml";
                }else if("ManagerJs.ftl".equals(templateName)){
                    generateFilePath += "Manager.js";
                }else if("ManagerJsp.ftl".equals(templateName)){
                    generateFilePath += "Manager.jsp";
                }else if("BaseInfo.ftl".equals(templateName)){
                    generateFilePath += "BaseInfo.html";
                }else {
                    generateFilePath += templateName.replace("ftl","java");
                }
                out = new FileOutputStream(generateFilePath);

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

    public List<Template> processTemplate() {

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

            Template actionTemplate = configuration.getTemplate("Action.ftl");
            Template serviceTemplate = configuration.getTemplate("Service.ftl");
            Template serviceImplTemplate = configuration.getTemplate("ServiceImpl.ftl");
            Template daoTemplate = configuration.getTemplate("Dao.ftl");
            Template daoimplTemplate = configuration.getTemplate("DaoImpl.ftl");
            Template modelTemplate = configuration.getTemplate("Model.ftl");
            Template hibenateTemplate = configuration.getTemplate("Hibernate.ftl");
            Template configTemplate = configuration.getTemplate("Config.ftl");
            Template keepAccountTemplate = configuration.getTemplate("KeepAccount.ftl");

            Template jsTemplate = configuration.getTemplate("ManagerJs.ftl");
            Template jspTemplate = configuration.getTemplate("ManagerJsp.ftl");
            Template baseInfoTemplate = configuration.getTemplate("BaseInfo.ftl");

            templateList.add(actionTemplate);
            templateList.add(serviceTemplate);
            templateList.add(serviceImplTemplate);
            templateList.add(daoTemplate);
            templateList.add(daoimplTemplate);
            templateList.add(modelTemplate);
            templateList.add(hibenateTemplate);
            templateList.add(configTemplate);
            if(isKeepAccount.getValue().equals("是")) {
                templateList.add(keepAccountTemplate);
            }

            templateList.add(jspTemplate);
            templateList.add(jsTemplate);
            templateList.add(baseInfoTemplate);

        } catch (IOException e) {
            e.printStackTrace();
        }
        return templateList;
    }

    public Map processDataBaseMeta(String tableName) {

        Map root = new HashMap();

        DataSource ds = DSFactory.get();
        Table table = MetaUtil.getTableMeta(ds, tableName);

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
            }
            column.setTypeName(javaType);
        }

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
        root.put("importList", importList);
        root.put("pkname",table.getPkNames().stream().findFirst().get());

        root.put("isKeepAccount", isKeepAccount.getValue());
        root.put("isSafeFlow", isSafeFlow.getValue());

        return root;
    }

    public ComboBox getIsKeepAccount() {
        return isKeepAccount;
    }

    public ComboBox getIsSafeFlow() {
        return isSafeFlow;
    }
}
