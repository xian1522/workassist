package ensemble;

import com.sun.org.apache.xpath.internal.operations.Bool;
import ensemble.samplepage.SamplePage;
import generated.Samples;
import javafx.beans.property.BooleanProperty;
import javafx.beans.property.SimpleBooleanProperty;
import javafx.geometry.Insets;
import javafx.scene.Node;
import javafx.scene.control.Label;
import javafx.scene.layout.Region;

import java.util.LinkedList;

public class PageBrowser extends Region {
    public static final String HOME_URL = "home";
    private Page currentPage;
    private SamplePage samplePage;

    private LinkedList<String> pastHistory = new LinkedList<>();
    private LinkedList<String> futureHistory = new LinkedList<>();

    private BooleanProperty forwardPossible = new SimpleBooleanProperty(false);
    private BooleanProperty backPossible = new SimpleBooleanProperty(false);
    private BooleanProperty atHome = new SimpleBooleanProperty(false);

    private String currentPageUrl;

    @Override
    protected void layoutChildren() {
        if(currentPage != null) {
            currentPage.getNode().resize(getWidth(), getHeight());
        }
    }

    public void goHome() {
        goToPage(HOME_URL, null, true);
    }

    public void forward() {
        String newUrl = futureHistory.pop();
        if(newUrl != null) {
            pastHistory.push(newUrl);
            goToPage(newUrl, null, false);
        }
    }

    public void backward() {
        String newUrl = pastHistory.pop();
        if(newUrl != null) {
            futureHistory.push(newUrl);
            goToPage(newUrl, null, false);
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
            if (updateHistory) {
                if (currentPageUrl != null) {
                    pastHistory.push(getCurrentPageUrl());
                }
                futureHistory.clear();
            }
            currentPageUrl = url;

            if(currentPage != null) {
                getChildren().remove((Node)currentPage);
            }
            currentPage = nextPage;
            getChildren().add(nextPage.getNode());

            atHome.set(url.equals(HOME_URL));
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


    public boolean isForwardPossible() {
        return forwardPossible.get();
    }

    public BooleanProperty forwardPossibleProperty() {
        return forwardPossible;
    }

    public void setForwardPossible(boolean forwardPossible) {
        this.forwardPossible.set(forwardPossible);
    }

    public boolean isBackPossible() {
        return backPossible.get();
    }

    public BooleanProperty backPossibleProperty() {
        return backPossible;
    }

    public void setBackPossible(boolean backPossible) {
        this.backPossible.set(backPossible);
    }

    public boolean isAtHome() {
        return atHome.get();
    }

    public BooleanProperty atHomeProperty() {
        return atHome;
    }

    public void setAtHome(boolean atHome) {
        this.atHome.set(atHome);
    }

    public String getCurrentPageUrl() {
        return currentPageUrl;
    }
}
