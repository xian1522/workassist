package ensemble.control;

import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;
import javafx.geometry.HPos;
import javafx.geometry.Insets;
import javafx.geometry.VPos;
import javafx.scene.Node;
import javafx.scene.control.Label;
import javafx.scene.layout.HBox;
import javafx.scene.layout.Pane;
import javafx.scene.layout.Priority;

import java.util.Arrays;


public class TitledToolBar extends HBox {
    private String defaultTitle = "JavaFx Ensemble";
    private Label titledLable = new Label(defaultTitle);

    private StringProperty titleText = new SimpleStringProperty(null);

    public String getTitleText() {
        return titleText.get();
    }

    public StringProperty titleTextProperty() {
        return titleText;
    }

    public void setTitleText(String titleText) {
        this.titleText.set(titleText);
    }

    public TitledToolBar() {
        getStyleClass().addAll("tool-bar", "ensmeble-tool-bar");
        titledLable.getStyleClass().add("title");
        titledLable.setManaged(false);
        titledLable.textProperty().bind(titleText);
        getChildren().add(titledLable);

        Pane spacer = new Pane();
        setHgrow(spacer, Priority.ALWAYS);
        getChildren().add(spacer);
    }

    public void addLeftItems(Node ... items) {
        getChildren().addAll(0, Arrays.asList(items));
    }
    public void addRightItems(Node ... items) {
        getChildren().addAll(Arrays.asList(items));
    }

    @Override
    protected void layoutChildren() {
        super.layoutChildren();
        final double w = getWidth();
        final double h = getHeight();
        final double titledWidth = titledLable.prefWidth(h);
        double leftItemWidth = getPadding().getLeft();
        for(Node item : getChildren()) {
            if(item == titledLable) {
                break;
            }
            leftItemWidth += item.getLayoutBounds().getWidth();
            Insets margin = getMargin(item);
            if(margin != null) {
                leftItemWidth += margin.getLeft() + margin.getRight();
            }
            leftItemWidth += getSpacing();
        }
        if ((leftItemWidth + titledWidth/2) < (w/2)) {
            titledLable.setVisible(true);
            layoutInArea(titledLable, 0, 0, getWidth(), h, 0, HPos.CENTER, VPos.CENTER);
        } else {
            titledLable.setVisible(false);
        }
    }
}
