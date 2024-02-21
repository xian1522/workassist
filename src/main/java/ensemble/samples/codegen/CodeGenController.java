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
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import freemarker.template.TemplateExceptionHandler;
import javafx.fxml.FXML;
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
    public void generateCode() {

        String tablename = this.tablename.getText();
        if(tablename == null || tablename.trim().length() == 0) {
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
                }else {
                    generateFilePath += templateName.replace("ftl","java");
                }
                out = new FileOutputStream(generateFilePath);

                Writer writer = new OutputStreamWriter(out);

                template.process(root, writer);

                BufferedWriter bufferedWriter = new BufferedWriter(writer);//缓冲
                String s = "";
                bufferedWriter.write(s);

                System.out.println("------------"+ template.getName() +" generation success--------------");

                bufferedWriter.flush();
                bufferedWriter.close();
            }
        } catch (IOException | TemplateException e) {
            e.printStackTrace();
        }
    }

    public static List<Template> processTemplate() {

        List<Template> templateList = new ArrayList<>();

        Configuration configuration = new Configuration(Configuration.VERSION_2_3_22);

        try {
            configuration.setDirectoryForTemplateLoading(new File("E:/Users/Administrator/workassist/target/classes/ensemble/samples/codegen"));
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

            templateList.add(actionTemplate);
            templateList.add(serviceTemplate);
            templateList.add(serviceImplTemplate);
            templateList.add(daoTemplate);
            templateList.add(daoimplTemplate);
            templateList.add(modelTemplate);
            templateList.add(hibenateTemplate);
            templateList.add(configTemplate);

        } catch (IOException e) {
            e.printStackTrace();
        }
        return templateList;
    }

    public static Map processDataBaseMeta(String tableName) {

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

        return root;
    }

}