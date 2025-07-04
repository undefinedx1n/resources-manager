package com.example.mapper;

import com.example.entity.Salary;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 操作salary相关数据接口
*/
public interface SalaryMapper {

    /**
      * 新增
    */
    int insert(Salary salary);

    /**
      * 删除
    */
    int deleteById(Integer id);

    /**
      * 修改
    */
    int updateById(Salary salary);

    /**
      * 根据ID查询
    */
    Salary selectById(Integer id);

    /**
      * 查询所有
    */
    List<Salary> selectAll(Salary salary);

    @Select("select min(id) as id, year, min(time) as time, min(employee_id) as employee_id, min(department_id) as department_id, min(note) as note from salary group by year order by year desc")
    List<Salary> getMonth();
}