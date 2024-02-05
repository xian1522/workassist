package ensemble;

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
}
