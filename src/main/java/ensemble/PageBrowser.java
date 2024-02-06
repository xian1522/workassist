package ensemble;

import ensemble.samplepage.SamplePage;
import generated.Samples;
import javafx.geometry.Insets;
import javafx.scene.Node;
import javafx.scene.control.Label;
import javafx.scene.layout.Region;

public class PageBrowser extends Region {
    public static final String HOME_URL = "home";
    private Page currentPage;
    private SamplePage samplePage;


    @Override
    protected void layoutChildren() {
        if(currentPage != null) {
            currentPage.getNode().resize(getWidth(), getHeight());
        }
    }

    public void goToSample(SampleInfo sampleInfo) {
        goToPage("sample://" + sampleInfo.ensamplePath, sampleInfo, true);
    }

    public void goToPage(String url) {
        goToPage(url, null, true);
    }

    public void goToPage(String url, SampleInfo sampleInfo, boolean updateHistory) {
        Page nextPage = null;
        if(url.equals(HOME_URL)) {
        }else if(sampleInfo != null) {
            nextPage = updateSamplePage(sampleInfo, url);
        }else if(url.startsWith("sample://")) {
            String samplePath = url.substring("sample://".length());
            if(samplePath.contains("?")) {
                samplePath = samplePath.substring(0, samplePath.indexOf("?") - 1);
            }
            sampleInfo = Samples.ROOT.sampleForPath(samplePath);
            if(sampleInfo != null) {
                nextPage = updateSamplePage(sampleInfo, samplePath);
            }else {
                throw new UnsupportedOperationException("Unkown sample url [" + url + "]");
            }
        }

        if(nextPage != null) {
            if(currentPage != null) {
                getChildren().remove((Node)currentPage);
            }
            currentPage = nextPage;
            getChildren().add(nextPage.getNode());
        }
    }

    private SamplePage updateSamplePage(SampleInfo sampleInfo, String url) {
        if(samplePage == null) {
            samplePage = new SamplePage(sampleInfo, url, this);
        }else {
            samplePage.update(sampleInfo, url);
        }
        return samplePage;
    }
}
