package ensemble;

import generated.Samples;

public class SampleCategory {
    public final String name;
    public final SampleInfo[] samples;
    public final SampleInfo[] samplesAll;
    public final SampleCategory[] subCategories;

    public SampleCategory(String name, SampleInfo[] samples, SampleInfo[] samplesAll, SampleCategory[] subCategories) {
        this.name = name;
        this.samples = samples;
        this.samplesAll = samplesAll;
        this.subCategories = subCategories;
    }


    @Override
    public String toString() {
        return name;
    }

    public SampleInfo sampleForPath(String path) {
        if(path.charAt(0) == '/'){
            return Samples.ROOT.sampleForPath(path.split("/"), 1);
        }else{
            return sampleForPath(path.split("/"), 0);
        }
    }

    public SampleInfo sampleForPath(String[] pathParts, int index) {
        String part = pathParts[index];
        if(samples != null) {
            for (SampleInfo sampleInfo : samples) {
                if (part.equals(sampleInfo.name)) {
                    return sampleInfo;
                }
            }
        }
        if(subCategories != null) {
            for (SampleCategory category : subCategories) {
                if(part.equals(category.name)) {
                    return category.sampleForPath(pathParts, index + 1);
                }
            }
        }
        return null;
    }
}
