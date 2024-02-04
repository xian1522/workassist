package ensemble.control;

import javafx.animation.*;
import javafx.beans.property.DoubleProperty;
import javafx.beans.property.SimpleDoubleProperty;
import javafx.event.ActionEvent;
import javafx.event.Event;
import javafx.event.EventHandler;
import javafx.geometry.Insets;
import javafx.geometry.Point2D;
import javafx.geometry.VPos;
import javafx.scene.Node;
import javafx.scene.control.Button;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.Pane;
import javafx.scene.layout.Region;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Text;
import javafx.util.Duration;

import java.util.LinkedList;

public class Popover extends Region implements EventHandler<Event> {

    private static final int PAGE_GAP = 15;
    private final Region frameBorder = new Region();
    private final Button leftButton = new Button("Left");
    private final Button rightButton = new Button("Right");
    private final LinkedList<Page> pages = new LinkedList<Page>();
    private final Pane pagesPane = new Pane();
    private final Rectangle pagesClipRect = new Rectangle();
    private final Pane titlesPane = new Pane();
    private Text title;
    private final Rectangle titlesClipRect = new Rectangle();
    private final EventHandler<MouseEvent> popoverHideHandler;
    private Runnable onHideCallback = null;
    private double maxPopupHeight = -1;

    private DoubleProperty popoverHeight = new SimpleDoubleProperty(40) {
        @Override
        protected void invalidated() {
            requestLayout();
        }
    };


    public Popover() {
        getStyleClass().setAll("popover");
        frameBorder.getStyleClass().setAll("popover-frame");
        frameBorder.setMouseTransparent(true);
        leftButton.setOnMouseClicked(this);
        leftButton.getStyleClass().add("popover-left-button");
        leftButton.setMinWidth(USE_PREF_SIZE);
        rightButton.setOnMouseClicked(this);
        rightButton.getStyleClass().add("popover-right-button");
        rightButton.setMinWidth(USE_PREF_SIZE);
        pagesClipRect.setSmooth(false);
        pagesPane.setClip(pagesClipRect);
        titlesClipRect.setSmooth(false);
        titlesPane.setClip(titlesClipRect);
        getChildren().addAll(pagesPane, frameBorder, titlesPane, leftButton, rightButton);
        setVisible(false);
        setOpacity(0);
        setScaleX(.8);
        setScaleY(.8);

        popoverHideHandler = (MouseEvent t) -> {
            Point2D mouseInFileterPane = sceneToLocal(t.getX(), t.getY());
            if(mouseInFileterPane.getX() < 0 || mouseInFileterPane.getX() > getWidth() ||
                mouseInFileterPane.getY() < 0 || mouseInFileterPane.getY() > getHeight() ) {
                hide();
                t.consume();
            }
        };
    }

    @Override
    protected void layoutChildren() {
        if(maxPopupHeight == -1) {
            maxPopupHeight = getScene().getWidth() - 100;
        }
        Insets insets = getInsets();
        final double width = getWidth();
        final double height = getHeight();
        final double top = insets.getTop();
        final double bottom = insets.getBottom();
        final double left = insets.getLeft();
        final double right = insets.getRight();

        double pageWidth = width - left - right;
        double pageHeight = height - top - bottom;

        frameBorder.resize(width, height);

        pagesPane.resizeRelocate(left, top, pageWidth, pageHeight);
        pagesClipRect.setWidth(pageWidth);
        pagesClipRect.setHeight(pageHeight);

        double pageX = 0;
        for (Node page : pagesPane.getChildren()) {
            page.resizeRelocate(pageX, 0, pageWidth, pageHeight);
            pageX += pageWidth + PAGE_GAP;
        }

        double buttonHeight = leftButton.prefHeight(-1);
        if(buttonHeight < 30) buttonHeight = 30;
        final double buttonTop = (top - buttonHeight) / 2.0;
        final double leftButtonWidth = snapSize(leftButton.prefWidth(-1));
        leftButton.resizeRelocate(left, buttonTop, leftButtonWidth, buttonHeight);
        final double rightButtonWidth = snapSize(rightButton.prefWidth(-1));
        rightButton.resizeRelocate(width - right - rightButtonWidth, buttonTop, rightButtonWidth, buttonHeight);

        final double leftButtonRight = leftButton.isVisible() ? left + leftButtonWidth : left;
        final double rightButtonLeft = rightButton.isVisible() ? right + rightButtonWidth : right;
        titlesClipRect.setX(leftButtonRight);
        titlesClipRect.setWidth(width - leftButtonRight - rightButtonLeft);
        titlesClipRect.setHeight(top);

        if(title != null) {
            title.setTranslateY((int) (top / 2d));
        }
    }

    public final void clearPages() {
        while (!pages.isEmpty()) {
            pages.pop().handleHidden();
        }
        pagesPane.getChildren().clear();
        titlesPane.getChildren().clear();
        pagesClipRect.setX(0);
        pagesClipRect.setWidth(400);
        pagesClipRect.setHeight(400);
        popoverHeight.set(400);
        pagesPane.setTranslateX(0);
        titlesPane.setTranslateX(0);
        titlesClipRect.setTranslateX(0);
    }

    private Animation fadeAnimation = null;

    public void show() {
        show(null);
    }

    public void show(Runnable onHideCallback) {
        if(!isVisible() || fadeAnimation != null) {
            this.onHideCallback = onHideCallback;
            getScene().addEventFilter(MouseEvent.MOUSE_CLICKED, popoverHideHandler);
            if(fadeAnimation != null) {
                fadeAnimation.stop();
                setVisible(true);
            }else {
                popoverHeight.setValue(-1);
                setVisible(true);
            }
            FadeTransition fade = new FadeTransition(Duration.seconds(.1), this);
            fade.setToValue(1.0);
            fade.setOnFinished((ActionEvent event) -> {
                fadeAnimation = null;
            });

            ScaleTransition scale = new ScaleTransition(Duration.seconds(.1), this);
            scale.setToX(1);
            scale.setToY(1);

            ParallelTransition tx = new ParallelTransition(fade, scale);
            fadeAnimation = tx;
            tx.play();
        }
    }
    public void hide() {
        if(isVisible() || fadeAnimation != null) {
            getScene().removeEventFilter(MouseEvent.MOUSE_CLICKED, popoverHideHandler);
            if(fadeAnimation != null) {
                fadeAnimation.stop();
            }
            FadeTransition fadeTransition = new FadeTransition(Duration.seconds(.1), this);
            fadeTransition.setToValue(0);
            fadeTransition.setOnFinished((ActionEvent event) -> {
                fadeAnimation = null;
                setVisible(false);
                //TODO
//                clearPages();
                if(onHideCallback != null) onHideCallback.run();
            });
            ScaleTransition scale = new ScaleTransition(Duration.seconds(.1), this);
            scale.setToX(.8);
            scale.setToY(.8);

            ParallelTransition parallel = new ParallelTransition(fadeTransition, scale);
            fadeAnimation = parallel;
            fadeAnimation.play();
        }
    }

    @Override
    protected double computeMinHeight(double width) {
        Insets insets = getInsets();
        return insets.getLeft() + 100 + insets.getRight();
    }

    @Override
    protected double computePrefHeight(double width) {
        double minHeight = minHeight(-1);
        double maxHeight = maxHeight(-1);
        double prefHeight = popoverHeight.get();
        if(prefHeight == -1) {
            Page page = pages.getFirst();
            if(page != null) {
                Insets insets = getInsets();
                if(width == -1) {
                    width = prefWidth(-1);
                }
                double contentWidth = width - insets.getRight() - insets.getLeft();
                double contentHeight = page.getPageNode().prefHeight(contentWidth);
                prefHeight =  insets.getTop() + contentHeight + insets.getBottom();
                popoverHeight.set(prefHeight);
            }else {
                prefHeight = minHeight;
            }
        }
        return boundedSize(minHeight, prefHeight, maxHeight);
    }

    static double boundedSize(double min, double pref, double max) {
        double a = pref >= min ? pref : min;
        double b = min >= max ? min : max;
        return a <= b ? a : b;
    }

    @Override
    public void handle(Event event) {

    }

    public final void pushPage(final Page page) {
        final Node pageNode = page.getPageNode();
        pageNode.setManaged(false);
        pagesPane.getChildren().add(pageNode);
        Insets insets = getInsets();
        int pageWidth = (int)(prefWidth(-1) - insets.getLeft() - insets.getRight());
        int newPageX = (pageWidth + PAGE_GAP) * pages.size();
        leftButton.setVisible(page.leftButtonText() != null);
        leftButton.setText(page.leftButtonText());
        rightButton.setVisible(page.rightButtonText() != null);
        rightButton.setText(page.rightButtonText());

        title = new Text(page.getPageTitle());
        title.getStyleClass().add("popover-title");
        title.setTextOrigin(VPos.CENTER);
        title.setTranslateX(newPageX + (int)((pageWidth + title.getLayoutBounds().getWidth()) / 2D));
        titlesPane.getChildren().add(title);

        if(!pages.isEmpty() && isVisible()) {
            final Timeline timeline = new Timeline(
                    new KeyFrame(Duration.millis(350), (ActionEvent t) -> {
                        pagesPane.setCache(false);
                        resizePopoverToNewPage(pageNode);
                    },
                            new KeyValue(pagesPane.translateXProperty(), -newPageX, Interpolator.EASE_BOTH),
                            new KeyValue(titlesPane.translateXProperty(), -newPageX, Interpolator.EASE_BOTH),
                            new KeyValue(pagesClipRect.xProperty(), newPageX, Interpolator.EASE_BOTH),
                            new KeyValue(titlesClipRect.translateXProperty(), newPageX, Interpolator.EASE_BOTH)
                    )
            );
            timeline.play();
        }
        page.setPopover(this);
        page.handleShown();
        pages.add(page);
    }

    private void resizePopoverToNewPage(final Node newPageNode) {
        Insets insets = getInsets();
        final double width = prefWidth(-1);
        final double contentWidth = width - insets.getLeft() - insets.getRight();
        double h = newPageNode.prefWidth(contentWidth);
        h += insets.getTop() + insets.getBottom();
        new Timeline(new KeyFrame(Duration.millis(200), new KeyValue(popoverHeight, h, Interpolator.EASE_BOTH))).play();
    }


    public static interface Page {
        public void setPopover(Popover popover);
        public Popover getPopover();

        public Node getPageNode();

        public String getPageTitle();

        public String leftButtonText();

        public void hanldeLeftButton();

        public String rightButtonText();

        public void handleRightButton();

        public void handleShown();
        public void handleHidden();

    }
}
