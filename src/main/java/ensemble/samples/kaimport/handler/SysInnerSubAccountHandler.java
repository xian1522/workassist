package ensemble.samples.kaimport.handler;

import cn.hutool.db.Db;
import cn.hutool.db.Entity;
import com.alibaba.excel.EasyExcel;
import com.alibaba.excel.read.listener.PageReadListener;
import ensemble.samples.kaimport.DataModelHandler;
import ensemble.samples.kaimport.model.KaSubSubjectConfig;
import ensemble.samples.kaimport.model.SysInnerSubAccount;
import org.apache.commons.lang3.StringUtils;

import java.lang.reflect.Field;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SysInnerSubAccountHandler implements DataModelHandler {

    @Override
    public void processExcelData(String fileName) {

        EasyExcel.read(fileName, SysInnerSubAccount.class, new PageReadListener<SysInnerSubAccount>(dataList -> {
            List<Entity> entityList = new ArrayList<>();
            for(SysInnerSubAccount sysInnerSubAccount : dataList) {
                if("业务类型".equals(sysInnerSubAccount.getTradetype()) || "tradetype".equals(sysInnerSubAccount.getTradetype())
                        || "varchar".equals(sysInnerSubAccount.getTradetype())){
                    continue;
                }
                Entity entity = Entity.create("SYS_INNER_SUBACCOUNT");
                try {
                    Field[] declaredFields = SysInnerSubAccount.class.getDeclaredFields();
                    for(Field field : declaredFields) {
                        field.setAccessible(true);
                        entity.set(field.getName(), field.get(sysInnerSubAccount));
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

        })).sheet().sheetName("SYS_INNER_SUBACCOUNT").doRead();
    }
}
