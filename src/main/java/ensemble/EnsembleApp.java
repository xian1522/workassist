package ensemble;

import ensemble.control.Popover;
import ensemble.control.SearchBox;
import ensemble.control.TitledToolBar;
import generated.Samples;
import javafx.application.Application;
import javafx.event.ActionEvent;
import javafx.geometry.Insets;
import javafx.geometry.Point2D;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.ToggleButton;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.HBox;
import javafx.scene.layout.Pane;
import javafx.scene.layout.Region;
import javafx.scene.paint.Color;
import javafx.stage.Stage;


public class EnsembleApp extends Application {

    private Pane root;
    private Scene scene;
    private TitledToolBar titledToolBar;
    private Button backButton;
    private Button forwardButton;
    private Button homeButton;
    private ToggleButton listButton;
    private SearchBox searchBox = new SearchBox();
    private Popover simpleListPopover;
    private PageBrowser pageBrowser;

    private static final int TOOL_BAR_BUTTON_SIZE = 30;

    @Override
    public void init(){
        root = new Pane(){
            @Override
            protected void layoutChildren(){
                super.layoutChildren();
                final double w = getWidth();
                final double h = getHeight();
                final double toolBarHeight = titledToolBar.prefHeight(w);
                titledToolBar.resizeRelocate(0, 0, w, toolBarHeight);

                pageBrowser.setLayoutY(toolBarHeight);
                pageBrowser.resize(w, h - toolBarHeight);
                simpleListPopover.autosize();
                Point2D listBtnBottomCenter = listButton.localToScene(listButton.getWidth() / 2, listButton.getHeight());
                simpleListPopover.setLayoutX((int)(listBtnBottomCenter.getX() - 50));
                simpleListPopover.setLayoutY((int)(listBtnBottomCenter.getY() + 20));
            }
        };


        titledToolBar = new TitledToolBar();

        backButton = new Button();
        backButton.setId("back");
        backButton.getStyleClass().add("left-pill");
        backButton.setPrefSize(TOOL_BAR_BUTTON_SIZE, TOOL_BAR_BUTTON_SIZE);
        forwardButton = new Button();
        forwardButton.setId("forward");
        forwardButton.getStyleClass().add("center-pill");
        forwardButton.setPrefSize(TOOL_BAR_BUTTON_SIZE, TOOL_BAR_BUTTON_SIZE);
        homeButton = new Button();
        homeButton.setId("home");
        homeButton.getStyleClass().add("right-pill");
        homeButton.setPrefSize(TOOL_BAR_BUTTON_SIZE, TOOL_BAR_BUTTON_SIZE);
        HBox navButtons = new HBox(backButton, forwardButton, homeButton);
        backButton.setGraphic(new Region());
        forwardButton.setGraphic(new Region());
        homeButton.setGraphic(new Region());

        listButton = new ToggleButton();
        listButton.setId("list");
        listButton.setPrefSize(TOOL_BAR_BUTTON_SIZE, TOOL_BAR_BUTTON_SIZE);
        HBox.setMargin(listButton, new Insets(0, 0, 0, 7));
        listButton.setGraphic(new Region());

        titledToolBar.addLeftItems(navButtons, listButton);
        searchBox.setPrefWidth(200);
        titledToolBar.addRightItems(searchBox);
        root.getChildren().add(titledToolBar);

        pageBrowser = new PageBrowser();
        root.getChildren().add(0, pageBrowser);
        pageBrowser.goHome();

        simpleListPopover = new Popover();
        simpleListPopover.setPrefWidth(440);
        root.getChildren().add(simpleListPopover);

        SamplePopoverTreeList rootPage = new SamplePopoverTreeList(Samples.ROOT, pageBrowser);

        forwardButton.disableProperty().bind(pageBrowser.forwardPossibleProperty().not());
        forwardButton.setOnAction((ActionEvent event) -> {
            pageBrowser.forward();
        });
        backButton.disableProperty().bind(pageBrowser.backPossibleProperty().not());
        backButton.setOnAction((ActionEvent event) -> {
            pageBrowser.backward();
        });
        homeButton.disableProperty().bind(pageBrowser.atHomeProperty());
        homeButton.setOnAction((ActionEvent event) -> {
            pageBrowser.goHome();
        });


        listButton.setOnMouseClicked((MouseEvent e) -> {
            if(simpleListPopover.isVisible()) {
                simpleListPopover.hide();
            }else {
                simpleListPopover.clearPages();
                simpleListPopover.pushPage(rootPage);
                simpleListPopover.show(() -> {
                    listButton.setSelected(false);
                });
            }
        });

    }

    @Override
    public void start(Stage primaryStage) throws Exception {
        scene = new Scene(root, 1024, 768, Color.web("#f4f4f4"));

        setStyleSheets();

        primaryStage.setScene(scene);
        primaryStage.setTitle("Ensemble App");
        primaryStage.show();
    }

    private void setStyleSheets() {
        scene.getStylesheets().addAll("/ensemble/EnsembleStylesCommon.css");
    }


    public static void main(String[] args) {
        launch(args);
    }
}
