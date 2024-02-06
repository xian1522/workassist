package ensemble.samplepage;

import ensemble.Page;
import ensemble.PageBrowser;
import ensemble.SampleInfo;
import javafx.beans.binding.StringBinding;
import javafx.beans.property.*;
import javafx.beans.value.ObservableValue;
import javafx.collections.ObservableList;
import javafx.scene.Node;
import javafx.scene.control.Label;
import javafx.scene.layout.StackPane;
import javafx.util.Callback;

public class SamplePage extends StackPane implements Page {
    static final double INDENT = 8;

    final ObjectProperty<SampleInfo> sampleInfoProperty = new SimpleObjectProperty<>();
    final StringProperty titleProperty = new SimpleStringProperty();
    PageBrowser pageBrowser;

    public SamplePage(SampleInfo sampleInfo, String url, final PageBrowser pageBrowser) {
        sampleInfoProperty.set(sampleInfo);
        this.pageBrowser = pageBrowser;
        getStyleClass().add("sample-page");

        titleProperty.bind(new StringBinding() {
            {
                bind(sampleInfoProperty);
            }
            @Override
            protected String computeValue() {
                SampleInfo sampleInfo = SamplePage.this.sampleInfoProperty.get();
                if(sampleInfo != null) {
                    return sampleInfo.name;
                }else {
                    return "";
                }
            }
        });

        SamplePageContent frontPage = new SamplePageContent(this);
        getChildren().setAll(frontPage);
    }

    public void update(SampleInfo sampleInfo, String url) {
        this.sampleInfoProperty.set(sampleInfo);
    }

    @Override
    public String getTitle() {
        return titleProperty.get();
    }

    @Override
    public String getUrl() {
        return "sample://" + sampleInfoProperty.get().ensamplePath;
    }

    @Override
    public ReadOnlyStringProperty titleProperty() {
        return titleProperty;
    }

    @Override
    public Node getNode() {
        return this;
    }

    void registerSampleInfoUpdater(Callback<SampleInfo, Void> updater) {
        sampleInfoProperty.addListener((ObservableValue<? extends SampleInfo> ov,SampleInfo t, SampleInfo sampleInfo) -> {
            updater.call(sampleInfo);
        });

        updater.call(sampleInfoProperty.get());
    }
}
