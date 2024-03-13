package ensemble.samples.kaimport.model;

import java.sql.Timestamp;


public class KaSubSubjectConfig{

    private String upsubject;
    private String subjecttype;
    private String subject;
    private String subjectname;
    private String effectflag;

    public String getUpsubject() {
        return upsubject;
    }

    public void setUpsubject(String upsubject) {
        this.upsubject = upsubject;
    }

    public String getSubjecttype() {
        return subjecttype;
    }

    public void setSubjecttype(String subjecttype) {
        this.subjecttype = subjecttype;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getSubjectname() {
        return subjectname;
    }

    public void setSubjectname(String subjectname) {
        this.subjectname = subjectname;
    }

    public String getEffectflag() {
        return effectflag;
    }

    public void setEffectflag(String effectflag) {
        this.effectflag = effectflag;
    }
}