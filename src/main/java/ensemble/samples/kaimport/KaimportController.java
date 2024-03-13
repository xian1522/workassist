package ensemble.samples.kaimport;

import cn.hutool.db.Db;
import cn.hutool.db.Entity;
import cn.hutool.db.Session;
import cn.hutool.db.ds.DSFactory;
import com.alibaba.excel.EasyExcel;
import com.alibaba.excel.read.listener.PageReadListener;
import ensemble.samples.kaimport.handler.*;
import ensemble.samples.kaimport.model.KaSceneConfig;
import javafx.fxml.FXML;
import javafx.scene.control.Alert;
import javafx.scene.control.ComboBox;
import javafx.scene.control.Label;
import javafx.stage.FileChooser;
import org.apache.commons.lang3.StringUtils;

import javax.sql.DataSource;
import java.io.File;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class KaimportController {
    @FXML
    private ComboBox importTable;
    @FXML
    private Label fileName;

    private static final Map<String, DataModelHandler> DATA_MODEL_HANDLER_MAP
            = new HashMap<String, DataModelHandler>();

    static {
        DATA_MODEL_HANDLER_MAP.put("KA_SCENECONFIG", new KaSceneConfigHandler());
        DATA_MODEL_HANDLER_MAP.put("KA_ACCOUNTENTRY_CONFIG", new KaAccountentryConfigHandler());
        DATA_MODEL_HANDLER_MAP.put("KA_SUBSUBJECT_CONFIG", new KaSubSubjectConfigHandler());
        DATA_MODEL_HANDLER_MAP.put("SYS_INNER_SUBACCOUNT", new SysInnerSubAccountHandler());
        DATA_MODEL_HANDLER_MAP.put("SYS_SUBJECT", new SubjectHandler());
    }

    @FXML
    public void openFile() {
        FileChooser fileChooser = new FileChooser();

        if(StringUtils.isNotEmpty(fileName.getText())) {
            String tempFileName = fileName.getText();
            tempFileName = StringUtils.substringBeforeLast(tempFileName, "\\");
            fileChooser.setInitialDirectory(new File(tempFileName));
        }
        File choosenFile = fileChooser.showOpenDialog(null);
        if(choosenFile != null) {
            fileName.setText(choosenFile.getAbsolutePath());
        }

    }

    @FXML
    public void saveKa() {
        if(importTable.getValue() == null) {
            Alert warning = new Alert(Alert.AlertType.WARNING);
            warning.setContentText("表名不能为空!");
            warning.showAndWait();
            return;
        }
        if(StringUtils.isEmpty(fileName.getText())) {
            Alert warning = new Alert(Alert.AlertType.WARNING);
            warning.setContentText("文件不能为空!");
            warning.showAndWait();
            return;
        }

        String tableName = importTable.getValue().toString();

        try {
            Db.use().execute("DELETE FROM " + tableName);

            DataModelHandler dataModelHandler = DATA_MODEL_HANDLER_MAP.get(tableName);
            dataModelHandler.processExcelData(fileName.getText());

            Alert alert = new Alert(Alert.AlertType.INFORMATION);
            alert.setContentText(tableName + "导入成功");
            alert.showAndWait();

        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }

    @FXML
    public void resetKa() {
        importTable.setValue("请选择");
        fileName.setText(null);
    }


    public ComboBox getImportTable() {
        return importTable;
    }

    public void setImportTable(ComboBox importTable) {
        this.importTable = importTable;
    }
}
