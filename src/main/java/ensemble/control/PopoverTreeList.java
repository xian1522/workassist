package ensemble.control;

import ensemble.EnsembleApp;
import javafx.scene.control.ListCell;
import javafx.scene.control.ListView;
import javafx.scene.image.Image;
import javafx.util.Callback;


public class PopoverTreeList<T> extends ListView<T> implements Callback<ListView<T>, ListCell<T>> {

    protected static final Image RIGHT_ARROW =
            new Image(EnsembleApp.class.getResource("images/popover-arrow.png").toExternalForm());

    public PopoverTreeList() {
        getStyleClass().clear();
        setCellFactory(this);
    }

    @Override
    public ListCell<T> call(ListView<T> param) {
        return null;
    }
}
