package ensemble.samples.kaimport;

import ensemble.samples.kaimport.handler.KaSceneConfigHandler;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.layout.AnchorPane;
import javafx.stage.Stage;

import java.io.IOException;

/**
 * 记账配置导入
 */
public class KaImportApp extends Application {

    @Override
    public void start(Stage primaryStage) throws Exception {
        Scene scene = new Scene(createContent());
        primaryStage.setScene(scene);
        primaryStage.show();
    }

    public Parent createContent() {
        FXMLLoader fxmlLoader = new FXMLLoader();
        fxmlLoader.setLocation(this.getClass().getResource("kaimport.fxml"));
        try {
            AnchorPane anchorPane = fxmlLoader.load();

            KaimportController kaImportController = fxmlLoader.getController();
            kaImportController.getImportTable().getItems().addAll(
          "KA_SCENECONFIG",
                    "KA_ACCOUNTENTRY_CONFIG",
                    "KA_SUBSUBJECT_CONFIG",
                    "SYS_INNER_SUBACCOUNT",
                    "SYS_SUBJECT");

            return anchorPane;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }
}
