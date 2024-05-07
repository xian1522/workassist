package ensemble.samples.codegen;


public enum OracleColumnType {

    BIGINT(-5, "Long"),
    DECIMAL(2, "BigDecimal");

    private int jdbcType;
    private String javaType;

    private OracleColumnType(int jdbcType, String javaType){
        this.jdbcType = jdbcType;
        this.javaType = javaType;
    }

    public int getJdbcType() {
        return jdbcType;
    }

    public void setJdbcType(int jdbcType) {
        this.jdbcType = jdbcType;
    }

    public String getJavaType() {
        return javaType;
    }

    public void setJavaType(String javaType) {
        this.javaType = javaType;
    }
}
