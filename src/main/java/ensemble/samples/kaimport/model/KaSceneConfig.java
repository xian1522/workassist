package ensemble.samples.kaimport.model;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

public class KaSceneConfig {

    private String seqid;
    private String pseqid;

    private String affectelement;
    private String itemname;
    private String itemvalue;
    private String ifkeep;
    private String keepno;
    private String ifreverse;
    private String remark;
    private String effectflag;

    public String getAffectelement() {
        return affectelement;
    }

    public void setAffectelement(String affectelement) {
        this.affectelement = affectelement;
    }

    public String getItemname() {
        return itemname;
    }

    public void setItemname(String itemname) {
        this.itemname = itemname;
    }

    public String getItemvalue() {
        return itemvalue;
    }

    public void setItemvalue(String itemvalue) {
        this.itemvalue = itemvalue;
    }

    public String getIfkeep() {
        return ifkeep;
    }

    public void setIfkeep(String ifkeep) {
        this.ifkeep = ifkeep;
    }

    public String getKeepno() {
        return keepno;
    }

    public void setKeepno(String keepno) {
        this.keepno = keepno;
    }

    public String getIfreverse() {
        return ifreverse;
    }

    public void setIfreverse(String ifreverse) {
        this.ifreverse = ifreverse;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getEffectflag() {
        return effectflag;
    }

    public void setEffectflag(String effectflag) {
        this.effectflag = effectflag;
    }

    public String getPseqid() {
        return pseqid;
    }

    public void setPseqid(String pseqid) {
        this.pseqid = pseqid;
    }

    public String getSeqid() {
        return seqid;
    }

    public void setSeqid(String seqid) {
        this.seqid = seqid;
    }


    public String toString() {
        return ToStringBuilder.reflectionToString(this,
                ToStringStyle.SHORT_PREFIX_STYLE);
    }
}
