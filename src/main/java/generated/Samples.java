package generated;

import ensemble.SampleCategory;
import ensemble.SampleInfo;
import ensemble.playground.PlaygroundProperty;
import javafx.application.ConditionalFeature;

public class Samples {
    private static final SampleInfo SAMPLE_122 = new SampleInfo("Advanced Media","An advanced media player with controls for play/pause, seek, and volume. ","/Media/Advanced Media","/ensemble/samples/media/advancedmedia","ensemble.samples.media.advancedmedia.AdvancedMediaApp","/ensemble/samples/media/advancedmedia/preview.png",new String[]{"/ensemble/samples/media/advancedmedia/AdvancedMediaApp.java","/ensemble/samples/shared-resources/playbutton.png","/ensemble/samples/shared-resources/pausebutton.png","/ensemble/samples/media/advancedmedia/MediaControl.java",});
    private static final SampleInfo CREATING_FORM = new SampleInfo("Create Form","Create Form","/Create Form", "/ensemble/samples/createform","ensemble.samples.createform.CreatingForm",null, new String[]{"/ensemble/samples/createform/CreatingForm.java"});
    private static final SampleInfo CODE_GEN = new SampleInfo("Code generation","Code generation",null, null,"ensemble.samples.codegen.CodegenApp",null, new String[]{"/ensemble/samples/codegen/CodegenApp.java"});
    public static final SampleCategory ROOT = new SampleCategory("ROOT",null,null,
            new SampleCategory[]{new SampleCategory("Media", new SampleInfo[]{SAMPLE_122,CREATING_FORM,CODE_GEN}, new SampleInfo[]{SAMPLE_122,CREATING_FORM,CODE_GEN},null)}
    );
}
