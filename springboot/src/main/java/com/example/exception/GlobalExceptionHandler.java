package com.example.exception;

import cn.hutool.log.Log;
import cn.hutool.log.LogFactory;
import com.example.common.Result;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;

@ControllerAdvice(basePackages="com.example.controller")
public class GlobalExceptionHandler {

    private static final Log log = LogFactory.get();

    //统一异常处理@ExceptionHandler,主要用于Exception
    @ExceptionHandler(Exception.class)
    @ResponseBody//返回json串
    public Result error(HttpServletRequest request, Exception e){
        log.error("请求地址: " + request.getRequestURL());
        log.error("请求方法: " + request.getMethod());
        log.error("异常类型: " + e.getClass().getName());
        log.error("异常信息: " + e.getMessage());
        log.error("异常堆栈: ", e);
        return Result.error();
    }

    @ExceptionHandler(CustomException.class)
    @ResponseBody//返回json串
    public Result customError(HttpServletRequest request, CustomException e){
        log.error("请求地址: " + request.getRequestURL());
        log.error("请求方法: " + request.getMethod());
        log.error("自定义异常: " + e.getMsg());
        return Result.error(e.getCode(), e.getMsg());
    }
}
