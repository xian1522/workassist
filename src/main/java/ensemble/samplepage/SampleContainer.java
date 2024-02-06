package ensemble.samplepage;

import ensemble.SampleInfo;
import javafx.scene.Parent;
import javafx.scene.layout.Region;

public class SampleContainer extends Region {
    private final boolean resizable;
    private final Parent sampleNode;

    public SampleContainer(Parent sampleNode) {
        this.sampleNode = sampleNode;
        resizable = sampleNode.isResizable()
                && (sampleNode.maxWidth(-1) == 0 || sampleNode.maxWidth(-1) >= sampleNode.minWidth(-1))
                && (sampleNode.maxHeight(-1) == 0 || sampleNode.maxHeight(-1) >= sampleNode.minHeight(-1));
        getChildren().add(sampleNode);
        getStyleClass().add("sample-container");
    }

    @Override
    protected void layoutChildren() {

    }

}
