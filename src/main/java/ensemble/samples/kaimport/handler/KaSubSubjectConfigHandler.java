package ensemble.samples.kaimport.handler;

import cn.hutool.db.Db;
import cn.hutool.db.Entity;
import com.alibaba.excel.EasyExcel;
import com.alibaba.excel.read.listener.PageReadListener;
import ensemble.samples.kaimport.DataModelHandler;
import ensemble.samples.kaimport.model.KaAccountEntryConfig;
import ensemble.samples.kaimport.model.KaSubSubjectConfig;
import org.apache.commons.lang3.StringUtils;

import java.lang.reflect.Field;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class KaSubSubjectConfigHandler implements DataModelHandler {

    @Override
    public void processExcelData(String fileName) {

        EasyExcel.read(fileName, KaSubSubjectConfig.class, new PageReadListener<KaSubSubjectConfig>(dataList -> {
            List<Entity> entityList = new ArrayList<>();
            for(KaSubSubjectConfig kaSubSubjectConfig : dataList) {
                if(StringUtils.isEmpty(kaSubSubjectConfig.getUpsubject()) || "UPSUBJECT".equals(kaSubSubjectConfig.getUpsubject())
                        || "varchar".equals(kaSubSubjectConfig.getUpsubject())){
                    continue;
                }
                Entity entity = Entity.create("KA_SUBSUBJECT_CONFIG");
                try {
                    Field[] declaredFields = KaSubSubjectConfig.class.getDeclaredFields();
                    for(Field field : declaredFields) {
                        field.setAccessible(true);
                        entity.set(field.getName(), field.get(kaSubSubjectConfig));
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

        })).sheet().sheetName("KA_SUBSUBJECT_CONFIG").doRead();
    }
}
