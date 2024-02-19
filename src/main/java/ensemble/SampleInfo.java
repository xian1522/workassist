package ensemble;

import ensemble.samplepage.SampleContainer;
import ensemble.samplepage.SamplePage;
import javafx.beans.property.ObjectProperty;
import javafx.beans.value.ObservableValue;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.layout.Pane;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.logging.Level;
import java.util.logging.Logger;

public class SampleInfo {
    public final String name;
    public final String description;
    public final String ensamplePath;

    public final String baseUri;
    public final String appClass;
    public final String[] resourceUrls;
    public final String previewUrl;


    public SampleInfo(String name, String description, String ensamplePath, String baseUri, String appClass,
                      String previewUrl, String[] resourceUrls) {
        this.name = name;
        this.description = description;
        this.ensamplePath = ensamplePath;
        this.baseUri = baseUri;
        this.appClass = appClass;
        this.previewUrl = previewUrl;
        this.resourceUrls = resourceUrls;
    }

    public String toString() {
        return name;
    }

    public SampleRuntimeInfo buildSampleNode() {
        try {
            Method play = null;
            Method stop = null;
            Class clz = Class.forName(appClass);
            final Object app = clz.newInstance();
            Parent root = (Parent) clz.getMethod("createContent").invoke(app);
            for(Method m : clz.getMethods()) {
                switch (m.getName()) {
                    case "play":
                        play = m;
                        break;
                    case "stop":
                        stop = m;
                        break;
                }
            }
            final Method fPlay = play;
            final Method fStop = stop;

            root.sceneProperty().addListener((ObservableValue<? extends Scene> ov, Scene oldScene, Scene newScene) -> {
                try{
                    if(oldScene != null && fStop != null) {
                        fStop.invoke(app);
                    }
                    if(newScene != null && fPlay != null) {
                        fPlay.invoke(app);
                    }
                }catch (IllegalAccessException | IllegalArgumentException | InvocationTargetException ex) {
                    Logger.getLogger(SamplePage.class.getName()).log(Level.SEVERE, null, ex);
                }
            });
            return new SampleRuntimeInfo(root, app, clz);
        } catch (ClassNotFoundException | InstantiationException | IllegalAccessException | NoSuchMethodException | InvocationTargetException ex) {
            Logger.getLogger(SamplePage.class.getName()).log(Level.SEVERE, null, ex);
        }
        return new SampleRuntimeInfo(new Pane(), new Object(), Object.class);
    }

    public static class SampleRuntimeInfo {
        private final Parent sampleNode;
        private final Object app;
        private final Class clz;

        public SampleRuntimeInfo(Parent sampleNode, Object app, Class clz) {
            this.sampleNode = sampleNode;
            this.app = app;
            this.clz = clz;
        }

        public Parent getSampleNode() {
            return sampleNode;
        }

        public Object getApp() {
            return app;
        }

        public Class getClz() {
            return clz;
        }
    }
}
