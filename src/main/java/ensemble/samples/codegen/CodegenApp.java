package ensemble.samples.codegen;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.GridPane;
import javafx.stage.Stage;

import java.io.IOException;

public class CodegenApp extends Application {

    @Override
    public void start(Stage primaryStage) throws Exception {
        Scene scene = new Scene(createContent());
        primaryStage.setScene(scene);
        primaryStage.show();
    }

    public Parent createContent() {
        FXMLLoader fxmlLoader = new FXMLLoader();
        fxmlLoader.setLocation(this.getClass().getResource("codegen.fxml"));
        try {
            AnchorPane anchorPane = fxmlLoader.load();
            CodeGenController controller = fxmlLoader.getController();

            initComboBox(controller);

            return anchorPane;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    private void initComboBox(CodeGenController controller) {
        controller.getIsKeepAccount().getItems().addAll("是","否");
        controller.getIsSafeFlow().getItems().addAll("是","否");
        controller.getIsFlow().getItems().addAll("是", "否");
        controller.getIsNewFlow().getItems().addAll("是", "否");
        //设置默认值
        controller.getIsKeepAccount().setValue("否");
        controller.getIsSafeFlow().setValue("否");
        controller.getIsFlow().setValue("否");
        controller.getIsNewFlow().setValue("否");
    }

    public static void main(String[] args) {
        launch(args);
    }
}
