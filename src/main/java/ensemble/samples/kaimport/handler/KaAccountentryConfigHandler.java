package ensemble.samples.kaimport.handler;

import cn.hutool.db.Db;
import cn.hutool.db.Entity;
import com.alibaba.excel.EasyExcel;
import com.alibaba.excel.read.listener.PageReadListener;
import ensemble.samples.kaimport.DataModelHandler;
import ensemble.samples.kaimport.model.KaAccountEntryConfig;
import ensemble.samples.kaimport.model.KaSceneConfig;

import java.lang.reflect.Field;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class KaAccountentryConfigHandler implements DataModelHandler {

    @Override
    public void processExcelData(String fileName) {

        EasyExcel.read(fileName, KaAccountEntryConfig.class, new PageReadListener<KaAccountEntryConfig>(dataList -> {
            List<Entity> entityList = new ArrayList<>();
            for(KaAccountEntryConfig kaAccountEntryConfig : dataList) {
                if("分录编号".equals(kaAccountEntryConfig.getKeepno()) || "KEEPNO".equals(kaAccountEntryConfig.getKeepno())
                        || "varchar".equals(kaAccountEntryConfig.getKeepno())){
                    continue;
                }
                Entity entity = Entity.create("KA_ACCOUNTENTRY_CONFIG");
                try {
                    Field[] declaredFields = KaAccountEntryConfig.class.getDeclaredFields();
                    for(Field field : declaredFields) {
                        field.setAccessible(true);
                        entity.set(field.getName(), field.get(kaAccountEntryConfig));
                    }
                    entityList.add(entity);
                } catch (IllegalAccessException e) {
                    e.printStackTrace();
                }
            }
            try {
                Db.use().insert(entityList);
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }

        })).sheet().sheetName("KA_ACCOUNTENTRY_CONFIG").doRead();
    }
}
