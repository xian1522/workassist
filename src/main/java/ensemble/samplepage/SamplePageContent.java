package ensemble.samplepage;

import ensemble.SampleInfo;
import javafx.scene.layout.Region;
import javafx.scene.text.Text;

import static ensemble.samplepage.SamplePage.INDENT;

public class SamplePageContent extends Region {
    private SamplePage samplePage;
    private Description description;
    private boolean needsPlayground;
    private SampleContainer sampleContainer;

    public SamplePageContent(final SamplePage samplePage) {
        this.samplePage = samplePage;
        this.description = new Description(samplePage);
        samplePage.registerSampleInfoUpdater((SampleInfo sampleInfo) -> {
            update(sampleInfo);
            return null;
        });
    }

    static Text title(String text) {
        Text title = new Text(text);
        title.getStyleClass().add("sample-page-box-title");
        return title;
    }

    @Override
    protected void layoutChildren() {
        super.layoutChildren();
        double maxWidth = getWidth() - 2 * SamplePage.INDENT;
        double maxHeight = getHeight() - 2 * SamplePage.INDENT;
        boolean landscape = getWidth() >= getHeight();
        boolean wide = getWidth() >= getHeight() * 1.5;

        if(wide) {
            double x = Math.round(getWidth() / 2 + INDENT / 2);
            double w = getWidth() - INDENT - x;
            if(needsPlayground) {
                double h = (getHeight() - INDENT * 3) / 2;
                description.resizeRelocate(INDENT, INDENT, w, h);
            }else{
                description.resizeRelocate(INDENT, INDENT, w, maxHeight);
            }
        }else {
            sampleContainer.resizeRelocate(INDENT, INDENT, maxWidth, (getHeight() - 3 * INDENT) / 2);
            double y = Math.round(getHeight() / 2 + INDENT / 2);
            if (landscape) {
                double h = getHeight() - INDENT - y;
                if (needsPlayground) {
                    double w = (getWidth() - INDENT * 3) / 2;
                    description.resizeRelocate(Math.round(INDENT * 2 + w), y, w, h);
                } else {
                    description.resizeRelocate(INDENT, y, maxWidth, h);
                }
            } else {
                double w = getWidth() - INDENT * 2;
                if (needsPlayground) {
                    double h = (getHeight() - INDENT * 2 - y) / 2;
                    description.resizeRelocate(INDENT, Math.round(y + h + INDENT), w, h);
                } else {
                    double h = getHeight() - INDENT - y;
                    description.resizeRelocate(INDENT, y, w, h);
                }
            }
        }
    }

    public void update(SampleInfo sampleInfo) {
        sampleContainer = new SampleContainer(samplePage.sampleRuntimeInfoProperty.get().getSampleNode());
        sampleContainer.getStyleClass().add("sample-page-sample-node");
        getChildren().setAll(sampleContainer,description);
    }
}
