package ensemble.control;

import javafx.animation.Animation;
import javafx.event.Event;
import javafx.event.EventHandler;
import javafx.geometry.Point2D;
import javafx.scene.Node;
import javafx.scene.control.Button;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.Pane;
import javafx.scene.layout.Region;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Text;

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


    public Popover() {
        popoverHideHandler = (MouseEvent t) -> {
            Point2D mouseInFileterPane = sceneToLocal(t.getX(), t.getY());
            if(mouseInFileterPane.getX() < 0 || mouseInFileterPane.getX() > getWidth() ||
                mouseInFileterPane.getY() < 0 || mouseInFileterPane.getY() > getHeight() ) {
                hide();
                t.consume();
            }
        };
    }

    private Animation fadeAnimation = null;

    public void show(Runnable onHideCallback) {

    }
    public void hide() {

    }


    @Override
    public void handle(Event event) {

    }


    private static interface Page {
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
