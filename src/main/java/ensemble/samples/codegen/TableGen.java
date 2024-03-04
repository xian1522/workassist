package ensemble.samples.codegen;

import cn.hutool.db.meta.Table;

import java.util.HashSet;

public class TableGen{

    private HashSet<String> importList;

    private Table table;


    public Table getTable() {
        return table;
    }

    public void setTable(Table table) {
        this.table = table;
    }

    public HashSet<String> getImportList() {
        return importList;
    }

    public void setImportList(HashSet<String> importList) {
        this.importList = importList;
    }
}
