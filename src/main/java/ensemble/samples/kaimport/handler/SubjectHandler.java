package ensemble.samples.kaimport.handler;

import cn.hutool.db.Db;
import cn.hutool.db.Entity;
import com.alibaba.excel.EasyExcel;
import com.alibaba.excel.read.listener.PageReadListener;
import ensemble.samples.kaimport.DataModelHandler;
import ensemble.samples.kaimport.model.Subject;
import ensemble.samples.kaimport.model.SysInnerSubAccount;

import java.lang.reflect.Field;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SubjectHandler implements DataModelHandler {

    @Override
    public void processExcelData(String fileName) {

        EasyExcel.read(fileName, Subject.class, new PageReadListener<Subject>(dataList -> {
            List<Entity> entityList = new ArrayList<>();
            for(Subject subject : dataList) {
                if("科目ID".equals(subject.getSubjectid()) || "SUBJECTID".equals(subject.getSubjectid())
                        || "varchar".equals(subject.getSubjectid())){
                    continue;
                }
                Entity entity = Entity.create("SYS_SUBJECT");
                try {
                    Field[] declaredFields = Subject.class.getDeclaredFields();
                    for(Field field : declaredFields) {
                        field.setAccessible(true);
                        entity.set(field.getName(), field.get(subject));
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

        })).sheet().sheetName("SYS_SUBJECT").doRead();
    }
}
