package ensemble.control;


import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.scene.Cursor;
import javafx.scene.control.Button;
import javafx.scene.control.TextField;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.Region;


public class SearchBox extends TextField implements ChangeListener<String> {
    private Button clearButton = new Button();
    private Region innerBackground = new Region();
    private Region icon = new Region();

    public void changed(ObservableValue<? extends String> observable, String oldValue, String newValue) {
        clearButton.setVisible(newValue.length() > 0);
    }

    public SearchBox() {
        getStyleClass().addAll("search-box");
        icon.getStyleClass().setAll("search-box-icon");
        innerBackground.getStyleClass().setAll("search-box-inner");
        setPromptText("Search");
        textProperty().addListener(this);
        setPrefHeight(30);
        clearButton.getStyleClass().setAll("search-clear-button");
        clearButton.setCursor(Cursor.DEFAULT);
        clearButton.setOnMouseClicked((MouseEvent t) -> {
            setText("");
        });

        clearButton.setVisible(false);
        clearButton.setManaged(false);
        innerBackground.setManaged(false);
        icon.setManaged(false);
    }

    @Override
    public void layoutChildren() {
        super.layoutChildren();
        if(clearButton.getParent() != this) {
            getChildren().add(clearButton);
        }
        if(innerBackground.getParent() != this) {
            getChildren().add(0, innerBackground);
        }
        if(icon.getParent() != this) {
            getChildren().add(icon);
        }
        innerBackground.setLayoutX(0);
        innerBackground.setLayoutY(0);
        innerBackground.resize(getWidth(), getHeight());
        icon.setLayoutY(0);
        icon.setLayoutX(0);
        icon.resize(35, 30);
        clearButton.setLayoutX(getWidth()-30);
        clearButton.setLayoutY(0);
        clearButton.resize(30, 30);
    }
}
