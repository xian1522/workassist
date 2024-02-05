package ensemble;

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
}
