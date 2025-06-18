package com.example.mapper;

import com.example.entity.Resourceapply;

import java.util.List;

/**
 * 操作resourceapply相关数据接口
*/
public interface ResourceapplyMapper {

    /**
      * 新增
    */
    int insert(Resourceapply resourceapply);

    /**
      * 删除
    */
    int deleteById(Integer id);

    /**
      * 修改
    */
    int updateById(Resourceapply resourceapply);

    /**
      * 根据ID查询
    */
    Resourceapply selectById(Integer id);

    /**
      * 查询所有
    */
    List<Resourceapply> selectAll(Resourceapply resourceapply);
    
    /**
     * 统计员工的资产申请数量
     */
    int countByEmployeeId(Integer employeeId);

}