package ensemble.samples.kaimport.handler;

import cn.hutool.db.Db;
import cn.hutool.db.Entity;
import com.alibaba.excel.EasyExcel;
import com.alibaba.excel.read.listener.PageReadListener;
import ensemble.samples.kaimport.DataModelHandler;
import ensemble.samples.kaimport.model.KaSceneConfig;
import ensemble.samples.kaimport.model.SysInnerSubAccount;

import java.lang.reflect.Field;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class KaSceneConfigHandler implements DataModelHandler {

    @Override
    public void processExcelData(String fileName) {

        EasyExcel.read(fileName, KaSceneConfig.class, new PageReadListener<KaSceneConfig>(dataList -> {
            List<Entity> entityList = new ArrayList<>();
            for(KaSceneConfig sceneConfig : dataList) {
                if("编号".equals(sceneConfig.getSeqid()) || "SEQID".equals(sceneConfig.getSeqid()) || "int".equals(sceneConfig.getSeqid())){
                    continue;
                }
                Entity entity = Entity.create("KA_SCENECONFIG");
                try {
                    Field[] declaredFields = KaSceneConfig.class.getDeclaredFields();
                    for(Field field : declaredFields) {
                        field.setAccessible(true);
                        entity.set(field.getName(), field.get(sceneConfig));
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

        })).sheet().sheetName("KA_SCENECONFIG").doRead();
    }
}
