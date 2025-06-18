/*
 Navicat Premium Data Transfer

 Source Server         : mysql
 Source Server Type    : MySQL
 Source Server Version : 50726
 Source Host           : localhost:3306
 Source Schema         : xm_resources_manager

 Target Server Type    : MySQL
 Target Server Version : 50726
 File Encoding         : 65001

 Date: 20/04/2025 23:48:58
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin`  (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '密码',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '姓名',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像',
  `role` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '角色标识',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '电话',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '管理员' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES (1, 'admin', 'admin', '系统管理员', 'http://localhost:9090/files/admin-avatar.png', 'ADMIN', '13800138000', 'admin@xm.com');

-- ----------------------------
-- Table structure for askapply
-- ----------------------------
DROP TABLE IF EXISTS `askapply`;
CREATE TABLE `askapply`  (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '审批说明',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '请假事由',
  `employee_id` int(10) NULL DEFAULT NULL COMMENT '员工ID',
  `department_id` int(10) NULL DEFAULT NULL COMMENT '部门ID',
  `start` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '开始日期',
  `end` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '结束日期',
  `process` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '当前进度',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审批状态',
  `note` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审批说明',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '请假信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of askapply
-- ----------------------------
INSERT INTO `askapply` VALUES (1, '春节休假', 1, 1, '2024-02-10', '2024-02-17', '审批结束', '审批通过', '已安排工作交接');
INSERT INTO `askapply` VALUES (2, '培训学习', 2, 1, '2024-03-15', '2024-03-20', '审批结束', '审批通过', '参加技术培训');
INSERT INTO `askapply` VALUES (3, '个人事务', 3, 2, '2024-04-05', '2024-04-07', '审批结束', '审批不通过', '当前工作任务紧急');
INSERT INTO `askapply` VALUES (4, '年假休假', 4, 1, '2024-07-01', '2024-07-05', '审批结束', '审批通过', NULL);
INSERT INTO `askapply` VALUES (5, '病假', 5, 2, '2024-09-10', '2024-09-15', '审批结束', '审批通过', '已提供医院证明');
INSERT INTO `askapply` VALUES (6, '婚假', 6, 3, '2025-01-15', '2025-01-22', '审批结束', '审批通过', '祝贺');
INSERT INTO `askapply` VALUES (7, '调休', 7, 4, '2025-03-20', '2025-03-22', '审批中', '主管审批中', NULL);
INSERT INTO `askapply` VALUES (8, '事假', 8, 5, '2025-05-05', '2025-05-07', '审批中', '主管审批中', NULL);
INSERT INTO `askapply` VALUES (9, 'test', 10, 3, '2025-04-21', '2025-04-23', '主管审批中', '待主管审批', NULL);
INSERT INTO `askapply` VALUES (10, 'test', 1, 1, '2025-04-20', '2025-04-22', '主管审批中', '待主管审批', NULL);

-- ----------------------------
-- Table structure for department
-- ----------------------------
DROP TABLE IF EXISTS `department`;
CREATE TABLE `department`  (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '部门名称',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '部门描述',
  `employee_id` int(10) NULL DEFAULT NULL COMMENT '主管ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '部门信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of department
-- ----------------------------
INSERT INTO `department` VALUES (1, '技术研发部', '负责公司产品研发和技术创新', 4);
INSERT INTO `department` VALUES (2, '市场营销部', '负责市场推广和销售', 5);
INSERT INTO `department` VALUES (3, '人力资源部', '负责人才招聘和培训', 6);
INSERT INTO `department` VALUES (4, '财务部', '负责公司财务管理', 7);
INSERT INTO `department` VALUES (5, '运营部', '负责日常运营管理', 8);

-- ----------------------------
-- Table structure for employee
-- ----------------------------
DROP TABLE IF EXISTS `employee`;
CREATE TABLE `employee`  (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '密码',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '姓名',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像',
  `role` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '角色',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '电话',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `level` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '身份',
  `department_id` int(10) NULL DEFAULT NULL COMMENT '部门ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '员工信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of employee
-- ----------------------------
INSERT INTO `employee` VALUES (1, 'zhangsan', '123456', '张三', 'http://localhost:9090/files/avatar1.png', 'USER', '13811111111', 'zhangsan@xm.com', '员工', 1);
INSERT INTO `employee` VALUES (2, 'lisi', '123456', '李四', 'http://localhost:9090/files/avatar2.png', 'USER', '13822222222', 'lisi@xm.com', '员工', 1);
INSERT INTO `employee` VALUES (3, 'wangwu', '123456', '王五', 'http://localhost:9090/files/avatar3.png', 'USER', '13833333333', 'wangwu@xm.com', '员工', 2);
INSERT INTO `employee` VALUES (4, 'liubotao', '123456', '刘波涛', 'http://localhost:9090/files/avatar4.png', 'USER', '13844444444', 'liubotao@xm.com', '主管', 1);
INSERT INTO `employee` VALUES (5, 'zhangjing', '123456', '张静', 'http://localhost:9090/files/avatar5.png', 'USER', '13855555555', 'zhangjing@xm.com', '主管', 2);
INSERT INTO `employee` VALUES (6, 'wangfei', '123456', '王飞', 'http://localhost:9090/files/avatar6.png', 'USER', '13866666666', 'wangfei@xm.com', '主管', 3);
INSERT INTO `employee` VALUES (7, 'liuying', '123456', '刘颖', 'http://localhost:9090/files/avatar7.png', 'USER', '13877777777', 'liuying@xm.com', '主管', 4);
INSERT INTO `employee` VALUES (8, 'chenwei', '123456', '陈伟', 'http://localhost:9090/files/avatar8.png', 'USER', '13888888888', 'chenwei@xm.com', '主管', 5);
INSERT INTO `employee` VALUES (9, 'zhaolei', '123456', '赵雷', 'http://localhost:9090/files/avatar9.png', 'USER', '13899999999', 'zhaolei@xm.com', '员工', 2);
INSERT INTO `employee` VALUES (10, 'sunying', '123456', '孙莹', 'http://localhost:9090/files/avatar10.png', 'USER', '13800000000', 'sunying@xm.com', '员工', 3);
INSERT INTO `employee` VALUES (11, 'zhaoliu', '123', '赵六', NULL, 'USER', '13080511181', 'undefinedx1n@outlook.com', '员工', 4);
INSERT INTO `employee` VALUES (12, 'yangyang', '123', '洋洋', NULL, 'USER', '13080511181', '1@qq.com', '员工', 5);

-- ----------------------------
-- Table structure for financial
-- ----------------------------
DROP TABLE IF EXISTS `financial`;
CREATE TABLE `financial`  (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支出说明',
  `price` double(10, 2) NULL DEFAULT NULL COMMENT '支出金额',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支出时间',
  `department_id` int(10) NULL DEFAULT NULL COMMENT '支出部门',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '财务支出表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of financial
-- ----------------------------
INSERT INTO `financial` VALUES (1, '技术部设备更新', 150000.00, '2024-01-20 00:00:00', 1);
INSERT INTO `financial` VALUES (2, '市场部推广费用', 80000.00, '2024-02-15 00:00:00', 2);
INSERT INTO `financial` VALUES (3, '人力部招聘费用', 50000.00, '2024-03-10 00:00:00', 3);
INSERT INTO `financial` VALUES (4, '财务部软件采购', 30000.00, '2024-04-05 00:00:00', 4);
INSERT INTO `financial` VALUES (5, '运营部办公设备', 60000.00, '2024-06-20 00:00:00', 5);
INSERT INTO `financial` VALUES (6, '技术部培训费用', 100000.00, '2025-01-15 00:00:00', 1);
INSERT INTO `financial` VALUES (7, '市场部展会费用', 120000.00, '2025-03-20 00:00:00', 2);
INSERT INTO `financial` VALUES (8, '人力部团建费用', 40000.00, '2025-05-10 00:00:00', 3);
INSERT INTO `financial` VALUES (9, '技术部服务器采购', 250000.00, '2024-08-15 00:00:00', 1);
INSERT INTO `financial` VALUES (10, '市场部广告投放', 180000.00, '2024-09-20 00:00:00', 2);
INSERT INTO `financial` VALUES (11, '财务部税务软件', 45000.00, '2024-10-05 00:00:00', 4);
INSERT INTO `financial` VALUES (12, '运营部车辆维护', 32000.00, '2024-11-15 00:00:00', 5);
INSERT INTO `financial` VALUES (13, '技术部年终奖金', 300000.00, '2024-12-20 00:00:00', 1);
INSERT INTO `financial` VALUES (14, '市场部季度奖金', 150000.00, '2025-03-25 00:00:00', 2);
INSERT INTO `financial` VALUES (15, '人力部招聘平台', 60000.00, '2025-06-10 00:00:00', 3);

-- ----------------------------
-- Table structure for notice
-- ----------------------------
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '标题',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '内容',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '创建时间',
  `user` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '公告信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of notice
-- ----------------------------
INSERT INTO `notice` VALUES (1, '2024年春节放假安排', '春节放假时间为2024年2月10日至17日，共8天', '2024-01-15', 'admin');
INSERT INTO `notice` VALUES (2, '2024年度技术创新大会', '将于2024年3月15日在公司大会议室举行技术创新大会', '2024-02-28', 'admin');
INSERT INTO `notice` VALUES (3, '五一劳动节放假通知', '2024年五一劳动节放假时间为5月1日至5日，共5天', '2024-04-15', 'admin');
INSERT INTO `notice` VALUES (4, '公司年中总结大会', '2024年年中总结大会将于7月1日举行', '2024-06-20', 'admin');
INSERT INTO `notice` VALUES (5, '2025年公司年会通知', '2025年公司年会将于1月20日举行，地点待定', '2024-12-25', 'admin');
INSERT INTO `notice` VALUES (6, '办公系统升级通知', '系统将于2025年3月1日进行升级维护', '2025-02-15', 'admin');
INSERT INTO `notice` VALUES (7, '2025年度培训计划', '年度培训计划已制定完成，请各部门负责人查看', '2025-04-01', 'admin');

-- ----------------------------
-- Table structure for resourceapply
-- ----------------------------
DROP TABLE IF EXISTS `resourceapply`;
CREATE TABLE `resourceapply`  (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `employee_id` int(10) NULL DEFAULT NULL COMMENT '员工ID',
  `department_id` int(10) NULL DEFAULT NULL COMMENT '部门ID',
  `resources_id` int(10) NULL DEFAULT NULL COMMENT '资产ID',
  `num` int(10) NULL DEFAULT NULL COMMENT '申请数量',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '申请时间',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审批状态',
  `process` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审批进度',
  `note` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审批说明',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '资产申请审批表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of resourceapply
-- ----------------------------
INSERT INTO `resourceapply` VALUES (1, 1, 1, 1, 1, '2024-01-15 10:00:00', '审批通过', '审批结束', '新员工配备');
INSERT INTO `resourceapply` VALUES (2, 2, 1, 3, 2, '2024-02-20 14:30:00', '审批通过', '审批结束', '双屏办公需求');
INSERT INTO `resourceapply` VALUES (3, 3, 2, 5, 1, '2024-03-10 09:15:00', '审批不通过', '审批结束', '当前库存不足');
INSERT INTO `resourceapply` VALUES (4, 4, 1, 2, 1, '2024-06-01 11:00:00', '审批通过', '审批结束', '开发需求');
INSERT INTO `resourceapply` VALUES (5, 5, 2, 4, 1, '2024-08-15 16:45:00', '审批中', '主管审批中', NULL);
INSERT INTO `resourceapply` VALUES (6, 6, 3, 1, 1, '2025-01-10 10:30:00', '审批通过', '审批结束', NULL);
INSERT INTO `resourceapply` VALUES (7, 7, 4, 3, 2, '2025-03-01 14:20:00', '审批中', '主管审批中', NULL);
INSERT INTO `resourceapply` VALUES (8, 8, 5, 5, 3, '2025-04-15 11:30:00', '审批通过', '审批结束', '部门扩编需求');

-- ----------------------------
-- Table structure for resources
-- ----------------------------
DROP TABLE IF EXISTS `resources`;
CREATE TABLE `resources`  (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '资产名称',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '资产图片',
  `price` double(10, 2) NULL DEFAULT NULL COMMENT '资产价格',
  `num` int(10) NULL DEFAULT 0 COMMENT '剩余数量',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '资产信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of resources
-- ----------------------------
INSERT INTO `resources` VALUES (1, 'ThinkPad X1 Carbon', 'http://localhost:9090/files/thinkpad.jpg', 12999.00, 20);
INSERT INTO `resources` VALUES (2, 'MacBook Pro M2', 'http://localhost:9090/files/macbook.jpg', 15999.00, 15);
INSERT INTO `resources` VALUES (3, 'Dell显示器U2720Q', 'http://localhost:9090/files/dell-monitor.jpg', 3999.00, 30);
INSERT INTO `resources` VALUES (4, '华为会议平板', 'http://localhost:9090/files/huawei-board.jpg', 29999.00, 5);
INSERT INTO `resources` VALUES (5, '办公座椅人体工学椅', 'http://localhost:9090/files/chair.jpg', 1999.00, 50);

-- ----------------------------
-- Table structure for salary
-- ----------------------------
DROP TABLE IF EXISTS `salary`;
CREATE TABLE `salary`  (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `employee_id` int(10) NULL DEFAULT NULL COMMENT '员工ID',
  `department_id` int(10) NULL DEFAULT NULL COMMENT '部门ID',
  `year` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '年月',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '发放时间',
  `price` double(10, 2) NULL DEFAULT NULL COMMENT '发放薪资',
  `note` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注说明',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '薪资信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of salary
-- ----------------------------
INSERT INTO `salary` VALUES (1, 1, 1, '2024-01', '2024-01-15 00:00:00', 12000.00, '基本工资');
INSERT INTO `salary` VALUES (2, 1, 1, '2024-02', '2024-02-15 00:00:00', 12500.00, '加绩效奖金');
INSERT INTO `salary` VALUES (3, 2, 1, '2024-01', '2024-01-15 00:00:00', 11000.00, '基本工资');
INSERT INTO `salary` VALUES (4, 2, 1, '2024-02', '2024-02-15 00:00:00', 11800.00, '项目奖金');
INSERT INTO `salary` VALUES (5, 4, 1, '2024-01', '2024-01-15 00:00:00', 25000.00, '主管工资');
INSERT INTO `salary` VALUES (6, 4, 1, '2024-02', '2024-02-15 00:00:00', 26000.00, '主管工资+绩效');
INSERT INTO `salary` VALUES (7, 5, 2, '2024-01', '2024-01-15 00:00:00', 23000.00, '主管工资');
INSERT INTO `salary` VALUES (8, 5, 2, '2024-02', '2024-02-15 00:00:00', 24000.00, '主管工资+绩效');
INSERT INTO `salary` VALUES (9, 1, 1, '2025-01', '2025-01-15 00:00:00', 13000.00, '基本工资+年度调薪');
INSERT INTO `salary` VALUES (10, 2, 1, '2025-01', '2025-01-15 00:00:00', 12000.00, '基本工资+年度调薪');
INSERT INTO `salary` VALUES (11, 4, 1, '2025-01', '2025-01-15 00:00:00', 27000.00, '主管工资+年度调薪');
INSERT INTO `salary` VALUES (12, 5, 2, '2025-01', '2025-01-15 00:00:00', 25000.00, '主管工资+年度调薪');
INSERT INTO `salary` VALUES (13, 3, 2, '2024-01', '2024-01-15 00:00:00', 9500.00, '基本工资');
INSERT INTO `salary` VALUES (14, 3, 2, '2024-02', '2024-02-15 00:00:00', 10500.00, '基本工资+项目奖金');
INSERT INTO `salary` VALUES (15, 6, 3, '2024-01', '2024-01-15 00:00:00', 22000.00, '主管工资');
INSERT INTO `salary` VALUES (16, 6, 3, '2024-02', '2024-02-15 00:00:00', 23500.00, '主管工资+绩效');
INSERT INTO `salary` VALUES (17, 7, 4, '2024-01', '2024-01-15 00:00:00', 21000.00, '主管工资');
INSERT INTO `salary` VALUES (18, 7, 4, '2024-02', '2024-02-15 00:00:00', 22500.00, '主管工资+绩效');
INSERT INTO `salary` VALUES (19, 8, 5, '2024-01', '2024-01-15 00:00:00', 20000.00, '主管工资');
INSERT INTO `salary` VALUES (20, 8, 5, '2024-02', '2024-02-15 00:00:00', 21500.00, '主管工资+绩效');
INSERT INTO `salary` VALUES (21, 9, 2, '2024-01', '2024-01-15 00:00:00', 8500.00, '基本工资');
INSERT INTO `salary` VALUES (22, 9, 2, '2024-02', '2024-02-15 00:00:00', 9200.00, '基本工资+项目奖金');
INSERT INTO `salary` VALUES (23, 10, 3, '2024-01', '2024-01-15 00:00:00', 8000.00, '基本工资');
INSERT INTO `salary` VALUES (24, 10, 3, '2024-02', '2024-02-15 00:00:00', 8800.00, '基本工资+绩效');
INSERT INTO `salary` VALUES (25, 1, 1, '2024-03', '2024-03-15 00:00:00', 12800.00, '基本工资+季度奖金');
INSERT INTO `salary` VALUES (26, 2, 1, '2024-03', '2024-03-15 00:00:00', 12200.00, '基本工资+季度奖金');
INSERT INTO `salary` VALUES (27, 4, 1, '2024-03', '2024-03-15 00:00:00', 26500.00, '主管工资+季度奖金');
INSERT INTO `salary` VALUES (28, 5, 2, '2024-03', '2024-03-15 00:00:00', 24500.00, '主管工资+季度奖金');
INSERT INTO `salary` VALUES (29, 1, 1, '2024-07', '2024-07-15 00:00:00', 12800.00, '基本工资');
INSERT INTO `salary` VALUES (30, 1, 1, '2024-08', '2024-08-15 00:00:00', 13500.00, '基本工资+绩效奖金');
INSERT INTO `salary` VALUES (31, 1, 1, '2024-09', '2024-09-15 00:00:00', 14000.00, '基本工资+季度奖金');
INSERT INTO `salary` VALUES (32, 1, 1, '2024-10', '2024-10-15 00:00:00', 14500.00, '基本工资+项目奖金');
INSERT INTO `salary` VALUES (33, 2, 1, '2024-07', '2024-07-15 00:00:00', 11800.00, '基本工资');
INSERT INTO `salary` VALUES (34, 2, 1, '2024-08', '2024-08-15 00:00:00', 12500.00, '基本工资+绩效奖金');
INSERT INTO `salary` VALUES (35, 2, 1, '2024-09', '2024-09-15 00:00:00', 13000.00, '基本工资+季度奖金');
INSERT INTO `salary` VALUES (36, 2, 1, '2024-10', '2024-10-15 00:00:00', 13500.00, '基本工资+项目奖金');
INSERT INTO `salary` VALUES (37, 3, 2, '2024-07', '2024-07-15 00:00:00', 9500.00, '基本工资');
INSERT INTO `salary` VALUES (38, 3, 2, '2024-08', '2024-08-15 00:00:00', 10200.00, '基本工资+绩效奖金');
INSERT INTO `salary` VALUES (39, 3, 2, '2024-09', '2024-09-15 00:00:00', 10700.00, '基本工资+季度奖金');
INSERT INTO `salary` VALUES (40, 3, 2, '2024-10', '2024-10-15 00:00:00', 11200.00, '基本工资+项目奖金');
INSERT INTO `salary` VALUES (41, 4, 1, '2024-07', '2024-07-15 00:00:00', 26500.00, '主管工资');
INSERT INTO `salary` VALUES (42, 4, 1, '2024-08', '2024-08-15 00:00:00', 27000.00, '主管工资+绩效奖金');
INSERT INTO `salary` VALUES (43, 4, 1, '2024-09', '2024-09-15 00:00:00', 27500.00, '主管工资+季度奖金');
INSERT INTO `salary` VALUES (44, 4, 1, '2024-10', '2024-10-15 00:00:00', 28000.00, '主管工资+项目奖金');
INSERT INTO `salary` VALUES (45, 5, 2, '2024-07', '2024-07-15 00:00:00', 24500.00, '主管工资');
INSERT INTO `salary` VALUES (46, 5, 2, '2024-08', '2024-08-15 00:00:00', 25000.00, '主管工资+绩效奖金');
INSERT INTO `salary` VALUES (47, 5, 2, '2024-09', '2024-09-15 00:00:00', 25500.00, '主管工资+季度奖金');
INSERT INTO `salary` VALUES (48, 5, 2, '2024-10', '2024-10-15 00:00:00', 26000.00, '主管工资+项目奖金');
INSERT INTO `salary` VALUES (49, 6, 3, '2024-07', '2024-07-15 00:00:00', 22000.00, '主管工资');
INSERT INTO `salary` VALUES (50, 6, 3, '2024-08', '2024-08-15 00:00:00', 22500.00, '主管工资+绩效奖金');
INSERT INTO `salary` VALUES (51, 6, 3, '2024-09', '2024-09-15 00:00:00', 23000.00, '主管工资+季度奖金');
INSERT INTO `salary` VALUES (52, 6, 3, '2024-10', '2024-10-15 00:00:00', 23500.00, '主管工资+项目奖金');
INSERT INTO `salary` VALUES (53, 7, 4, '2024-07', '2024-07-15 00:00:00', 21000.00, '主管工资');
INSERT INTO `salary` VALUES (54, 7, 4, '2024-08', '2024-08-15 00:00:00', 21500.00, '主管工资+绩效奖金');
INSERT INTO `salary` VALUES (55, 7, 4, '2024-09', '2024-09-15 00:00:00', 22000.00, '主管工资+季度奖金');
INSERT INTO `salary` VALUES (56, 7, 4, '2024-10', '2024-10-15 00:00:00', 22500.00, '主管工资+项目奖金');
INSERT INTO `salary` VALUES (57, 8, 5, '2024-07', '2024-07-15 00:00:00', 20000.00, '主管工资');
INSERT INTO `salary` VALUES (58, 8, 5, '2024-08', '2024-08-15 00:00:00', 20500.00, '主管工资+绩效奖金');
INSERT INTO `salary` VALUES (59, 8, 5, '2024-09', '2024-09-15 00:00:00', 21000.00, '主管工资+季度奖金');
INSERT INTO `salary` VALUES (60, 8, 5, '2024-10', '2024-10-15 00:00:00', 21500.00, '主管工资+项目奖金');
INSERT INTO `salary` VALUES (61, 9, 2, '2024-07', '2024-07-15 00:00:00', 8500.00, '基本工资');
INSERT INTO `salary` VALUES (62, 9, 2, '2024-08', '2024-08-15 00:00:00', 9000.00, '基本工资+绩效奖金');
INSERT INTO `salary` VALUES (63, 9, 2, '2024-09', '2024-09-15 00:00:00', 9500.00, '基本工资+季度奖金');
INSERT INTO `salary` VALUES (64, 9, 2, '2024-10', '2024-10-15 00:00:00', 10000.00, '基本工资+项目奖金');
INSERT INTO `salary` VALUES (65, 10, 3, '2024-07', '2024-07-15 00:00:00', 8000.00, '基本工资');
INSERT INTO `salary` VALUES (66, 10, 3, '2024-08', '2024-08-15 00:00:00', 8500.00, '基本工资+绩效奖金');
INSERT INTO `salary` VALUES (67, 10, 3, '2024-09', '2024-09-15 00:00:00', 9000.00, '基本工资+季度奖金');
INSERT INTO `salary` VALUES (68, 10, 3, '2024-10', '2024-10-15 00:00:00', 9500.00, '基本工资+项目奖金');

SET FOREIGN_KEY_CHECKS = 1;
