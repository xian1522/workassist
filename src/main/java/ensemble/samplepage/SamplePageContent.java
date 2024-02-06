package ensemble.samplepage;

import ensemble.SampleInfo;
import javafx.scene.layout.Region;
import javafx.scene.text.Text;

import static ensemble.samplepage.SamplePage.INDENT;

public class SamplePageContent extends Region {
    private SamplePage samplePage;
    private Description description;
    private boolean needsPlayground;

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
                System.out.println("isvisible:" + description.isVisible());
            }
        }
    }

    public void update(SampleInfo sampleInfo) {
        getChildren().setAll(description);
    }
}
