package ensemble.samplepage;

import javafx.geometry.Insets;
import javafx.scene.control.Label;
import javafx.scene.layout.VBox;
import javafx.scene.text.Text;

import static ensemble.samplepage.SamplePageContent.title;

public class Description extends VBox {
    private Label description;
    private SamplePage samplePage;

    public Description (final SamplePage samplePage) {
        this.samplePage = samplePage;
        getStyleClass().add("sample-page-box");

        Text descriptionTitle = title("DESCRIPTION");
        description = new Label();
        description.setWrapText(true);
        description.setMinHeight(Label.USE_PREF_SIZE);
        description.setPadding(new Insets(8, 0, 8, 0));
        getChildren().addAll(descriptionTitle, description);
    }


}
