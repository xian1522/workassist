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
    }

    public static void main(String[] args) {
        launch(args);
    }
}
