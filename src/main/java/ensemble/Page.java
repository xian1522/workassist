package ensemble;

import javafx.beans.property.ReadOnlyProperty;
import javafx.beans.property.ReadOnlyStringProperty;
import javafx.scene.Node;

public interface Page {

    public String getTitle();

    public String getUrl();

    public ReadOnlyStringProperty titleProperty();

    public Node getNode();
}
