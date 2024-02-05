package ensemble;

import ensemble.control.Popover;
import ensemble.control.PopoverTreeList;
import javafx.event.EventHandler;
import javafx.geometry.Bounds;
import javafx.scene.Node;
import javafx.scene.control.ListCell;
import javafx.scene.control.ListView;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.Region;

import java.util.Comparator;

public class SamplePopoverTreeList extends PopoverTreeList implements Popover.Page {

    private Popover popover;
    private SampleCategory category;
    private PageBrowser pageBrowser;

    public SamplePopoverTreeList(SampleCategory category, PageBrowser pageBrowser) {
        this.category = category;
        this.pageBrowser = pageBrowser;
        if(category.subCategories != null) getItems().addAll(category.subCategories);
        if(category.samples != null) getItems().addAll(category.samples);
        getItems().sorted(new Comparator() {
            private String getName(Object o) {
                if(o instanceof SampleCategory) {
                    return ((SampleCategory) o).name;
                }else if(o instanceof SampleInfo) {
                    return ((SampleInfo) o).name;
                }else {
                    return "";
                }
            }
            @Override
            public int compare(Object o1, Object o2) {
                return getName(o1).compareTo(getName(o2));
            }
        });
    }

    @Override
    public ListCell call(ListView listView) {
        return new SampleItemListCell();
    }

    @Override
    public void setPopover(Popover popover) {
        this.popover = popover;
    }

    @Override
    public Popover getPopover() {
        return null;
    }

    @Override
    public Node getPageNode() {
        return this;
    }

    @Override
    public String getPageTitle() {
        return "Samples";
    }

    @Override
    public String leftButtonText() {
        return "< Back";
    }

    @Override
    public void hanldeLeftButton() {

    }

    @Override
    public String rightButtonText() {
        return "Done";
    }

    @Override
    public void handleRightButton() {

    }

    @Override
    public void handleShown() {

    }

    @Override
    public void handleHidden() {

    }

    @Override
    protected void itemClicked(Object item) {
        if(item instanceof SampleCategory) {
            popover.pushPage(new SamplePopoverTreeList((SampleCategory)item, pageBrowser));
        }else {
            popover.hide();
        }
    }


    private class SampleItemListCell extends ListCell implements EventHandler<MouseEvent> {
        private ImageView arrow = new ImageView(RIGHT_ARROW);
        private Region icon = new Region();

        public SampleItemListCell() {
            super();
            getStyleClass().setAll("sample-tree-list-cell");
            setOnMouseClicked(this);
            setGraphic(icon);
        }
        @Override
        public void layoutChildren() {
            if(arrow.getParent() != this) getChildren().add(arrow);
            super.layoutChildren();
            int width = (int)getWidth();
            int height = (int)getHeight();
            Bounds arrowBounds = arrow.getLayoutBounds();
            arrow.setLayoutX(width - arrowBounds.getWidth() -12);
            arrow.setLayoutY((int)(height - arrowBounds.getHeight()) / 2d);
        }
        @Override
        protected double computePrefWidth(double Height) {
            return 100;
        }
        @Override
        protected double computePrefHeight(double Width) {
            return 44;
        }
        @Override
        protected void updateItem(Object item, boolean empty) {
            super.updateItem(item, empty);
            if(item == null) {
                setText(null);
                arrow.setVisible(false);
                icon.getStyleClass().clear();
            }else {
                setText(item.toString());
                arrow.setVisible(true);
                if(item instanceof SampleCategory) {
                    icon.getStyleClass().setAll("folder-icon");
                }else if(item instanceof SampleInfo) {
                    icon.getStyleClass().setAll("samples-icon");
                }
            }
        }

        @Override
        public void handle(MouseEvent event) {
            itemClicked(getItem());
        }
    }
}
