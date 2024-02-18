package ensemble;


import generated.Samples;
import javafx.beans.property.ReadOnlyBooleanProperty;
import javafx.beans.property.ReadOnlyStringProperty;
import javafx.beans.property.ReadOnlyStringWrapper;
import javafx.beans.property.StringProperty;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.css.PseudoClass;
import javafx.event.ActionEvent;
import javafx.geometry.Pos;
import javafx.scene.Node;
import javafx.scene.control.*;
import javafx.scene.layout.HBox;
import javafx.scene.text.Text;
import javafx.util.Callback;

import java.util.*;


public class HomePage extends ListView<HomePage.HomePageRow> implements Callback<ListView<HomePage.HomePageRow>, ListCell<HomePage.HomePageRow>>, ChangeListener<Number>, Page {

    private static final int ITEM_WIDTH = 216;
    private static final int ITEM_HEIGHT = 162;
    private static final int ITEM_GAP = 32;
    private static final int MIN_MARGIN = 20;


    private static enum RowType {HightLights, Title, Samples};
    private int numberOfColumns = -1;
    private final HomePageRow HIGHTLIGHTS_ROW = new HomePageRow(RowType.HightLights, null, null);
    private final PageBrowser pageBrowser;
    private final ReadOnlyStringProperty titleProperty = new ReadOnlyStringWrapper();

    public HomePage (PageBrowser pageBrowser) {
        this.pageBrowser = pageBrowser;
        setId("HomePage");
        getStyleClass().clear();
        widthProperty().addListener(this);

        setCellFactory(this);
    }

    @Override
    public void changed(ObservableValue<? extends Number> observable, Number oldValue, Number newValue) {
        double width = newValue.doubleValue();
        width -= 60;
        final int newNumOfColumns = Math.max(1, (int)(width/(ITEM_WIDTH + ITEM_GAP)));
        if(numberOfColumns != newNumOfColumns) {
            numberOfColumns = newNumOfColumns;
            rebuild();
        }
    }

    private void rebuild() {
        List<HomePageRow> newItems = new ArrayList<>();
        newItems.add(HIGHTLIGHTS_ROW);

        addSampleRows(newItems, Samples.ROOT.samples);
        for(SampleCategory sampleCategory : Samples.ROOT.subCategories) {
            newItems.add(new HomePageRow(RowType.Title, sampleCategory.name, null));
            addSampleRows(newItems, sampleCategory.samplesAll);
        }
        getItems().setAll(newItems);
    }

    private void addSampleRows(List<HomePageRow> newItems, SampleInfo[] samples) {
        if(samples == null){
            return;
        }
        for(int row = 0; row < Math.ceil((double) samples.length / numberOfColumns); row++) {
            int sampleIndex = row * numberOfColumns;
            SampleInfo[] sampleInfos = Arrays.copyOfRange(samples, sampleIndex, Math.min(sampleIndex + numberOfColumns, samples.length));
            newItems.add(new HomePageRow(RowType.Samples, null, sampleInfos));
        }
    }

    @Override
    public ListCell<HomePageRow> call(ListView<HomePageRow> param) {
        return new HomeListCell();
    }

    @Override
    public String getTitle() {
        return titleProperty.get();
    }

    @Override
    public String getUrl() {
        return PageBrowser.HOME_URL;
    }

    @Override
    public ReadOnlyStringProperty titleProperty() {
        return titleProperty;
    }

    @Override
    public Node getNode() {
        return this;
    }

    private Map<String,SectionRibbon> ribbonsCache = new WeakHashMap<>();
    private Map<SampleInfo, Button> buttonCache = new WeakHashMap<>();

    private static int cellCount = 0;
    private static final PseudoClass TITLE_PSEUDO_CLASS = PseudoClass.getPseudoClass(RowType.Title.toString());

    private class HomeListCell extends ListCell<HomePageRow> implements Callback<Integer, Node>, Skin<HomeListCell> {
        private static final double HIGHLIGHTS_HEIGHT = 430;
        private static final double RIBBON_HEIGHT = 60;
        private static final double DEFAULT_HEIGHT = 230;
        private static final double DEFAULT_WIDTH = 100;
        private double height = DEFAULT_HEIGHT;
        int cellIndex;
        private RowType oldRowType = null;
        private HBox box = new HBox(ITEM_GAP);
        private HomeListCell() {
            super();
            getStyleClass().clear();
            cellIndex = cellCount++;
            box.getStyleClass().add("home-page-cell");
            setSkin(this);
        }

        @Override protected double computeMaxHeight(double d) {
            return height;
        }

        @Override protected double computePrefHeight(double d) {
            return height;
        }

        @Override protected double computeMinHeight(double d) {
            return height;
        }

        @Override protected double computeMaxWidth(double height) {
            return Double.MAX_VALUE;
        }

        @Override protected double computePrefWidth(double height) {
            return DEFAULT_WIDTH;
        }

        @Override protected double computeMinWidth(double height) {
            return DEFAULT_WIDTH;
        }

        @Override
        protected void updateItem(HomePageRow item, boolean empty) {
            super.updateItem(item, empty);
            box.pseudoClassStateChanged(TITLE_PSEUDO_CLASS, item != null && item.rowType == RowType.Title);
            if(item == null) {
                oldRowType = null;
                box.getChildren().clear();
                height = DEFAULT_HEIGHT;
            }else {
                switch (item.rowType) {
                    case HightLights:
                        if(oldRowType != RowType.HightLights){
                            height = HIGHLIGHTS_HEIGHT;
                        }
                        break;
                    case Title:
                        height = RIBBON_HEIGHT;
                        SectionRibbon sectionRibbon = ribbonsCache.get(item.title);
                        if(sectionRibbon == null) {
                            sectionRibbon = new SectionRibbon(item.title.toUpperCase());
                            ribbonsCache.put(item.title, sectionRibbon);
                        }
                        box.getChildren().setAll(sectionRibbon);
                        box.setAlignment(Pos.CENTER);
                        break;
                    case Samples:
                        height = DEFAULT_HEIGHT;
                        box.setAlignment(Pos.CENTER);
                        box.getChildren().clear();
                        for(int i = 0; i < item.samples.length; i++) {
                            final SampleInfo sampleInfo = item.samples[i];
                            Button sampleButton = buttonCache.get(sampleInfo);
                        }
                        break;
                }
                oldRowType = item.rowType;
            }
        }

        @Override
        public HomeListCell getSkinnable() {
            return this;
        }

        @Override
        public Node getNode() {
            return box;
        }

        @Override
        public void dispose() {

        }

        @Override
        public Node call(Integer highlightIndex) {
            Button sampleButton = new Button();
            sampleButton.getStyleClass().setAll("sample-button");
//            sampleButton.setGraphic(Samples.HIGHLIGHTS[highlightIndex].getLargePreview());
            sampleButton.setContentDisplay(ContentDisplay.GRAPHIC_ONLY);
            sampleButton.setOnAction((ActionEvent actionEvent) -> {
//                System.out.println("Clicked " + Samples.HIGHLIGHTS[highlightIndex].name);
//                pageBrowser.goToSample(Samples.HIGHLIGHTS[highlightIndex]);
            });
            return sampleButton;
        }
    }

    public static class HomePageRow {
        public final RowType rowType;
        public final String title;
        public final SampleInfo[] samples;

        private HomePageRow(RowType rowType, String title, SampleInfo[] samples) {
            this.rowType = rowType;
            this.title = title;
            this.samples = samples;
        }

        public String toString() {
            return "HomePageRow{" + "rowType=" + rowType + ", title=" + title + ", samples=" + samples + "}";
        }
    }

    private static class SectionRibbon extends Text {
        private SectionRibbon(String text) {
            super(text);
            getStyleClass().add("section-ribbon-text");
        }
    }
}
