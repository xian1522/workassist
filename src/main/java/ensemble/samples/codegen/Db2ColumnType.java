package ensemble.samples.codegen;


public enum Db2ColumnType {

    VARCHAR(12, "String"),
    CHAR(1, "String"),
    TIMESTAPME(93, "Timestamp"),
    DATE(91, "Date"),
    INTEGER(4, "Integer"),
    DECIMAL(3, "BigDecimal");

    private int jdbcType;
    private String javaType;

    private Db2ColumnType(int jdbcType, String javaType){
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
