package com.example.controller;

import com.example.common.Result;
import com.example.entity.Employee;
import com.example.service.EmployeeService;
import com.github.pagehelper.PageInfo;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * 员工前端操作接口
 **/
@RestController
@RequestMapping("/employee")
public class EmployeeController {

    @Resource
    private EmployeeService employeeService;

    /**
     * 新增
     */
    @PostMapping("/add")
    public Result add(@RequestBody Employee employee) {
        employeeService.add(employee);
        return Result.success();
    }

    /**
     * 删除
     */
    @DeleteMapping("/delete/{id}")
    public Result deleteById(@PathVariable Integer id) {
        employeeService.deleteById(id);
        return Result.success();
    }

    /**
     * 批量删除
     */
    @DeleteMapping("/delete/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {
        employeeService.deleteBatch(ids);
        return Result.success();
    }

    /**
     * 修改
     */
    @PutMapping("/update")
    public Result updateById(@RequestBody Employee employee) {
        employeeService.updateById(employee);
        return Result.success();
    }

    /**
     * 根据ID查询
     */
    @GetMapping("/selectById/{id}")
    public Result selectById(@PathVariable Integer id) {
        Employee employee = employeeService.selectById(id);
        return Result.success(employee);
    }

    /**
     * 查询所有
     */
    @GetMapping("/selectAll")
    public Result selectAll(Employee employee ) {
        List<Employee> list = employeeService.selectAll(employee);
        return Result.success(list);
    }

    @GetMapping("/selectHeaders")
    public Result selectHeaders() {
        List<Employee> list = employeeService.selectHeaders();
        return Result.success(list);
    }

    /**
     * 分页查询
     */
    @GetMapping("/selectPage")
    public Result selectPage(Employee employee,
                             @RequestParam(defaultValue = "1") Integer pageNum,
                             @RequestParam(defaultValue = "10") Integer pageSize) {
        PageInfo<Employee> page = employeeService.selectPage(employee, pageNum, pageSize);
        return Result.success(page);
    }

    /**
     * 根据部门ID查询员工列表
     */
    @GetMapping("/selectByDepartment")
    public Result selectByDepartment(@RequestParam Integer departmentId) {
        List<Employee> list = employeeService.selectByDepartment(departmentId);
        return Result.success(list);
    }
    
    /**
     * 获取员工个人申请统计数据
     */
    @GetMapping("/applicationStats")
    public Result applicationStats(@RequestParam Integer employeeId) {
        Map<String, Object> stats = employeeService.getApplicationStatsByEmployeeId(employeeId);
        return Result.success(stats);
    }
    
    /**
     * 获取部门员工数量
     */
    @GetMapping("/count")
    public Result count(@RequestParam Integer departmentId) {
        int count = employeeService.countByDepartment(departmentId);
        return Result.success(count);
    }
}