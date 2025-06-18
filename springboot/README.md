# 企业微人事管理系统 (resources-manager)

## 1. 项目概述

本系统是一个基于 Vue.js 和 Spring Boot 技术栈实现的企业内部人事与资源综合管理平台。旨在通过信息化手段，简化和规范企业日常的人事管理、资产申请、请假审批、财务记录、薪资发放等流程，提高管理效率和信息透明度。系统支持多角色访问，包括普通员工、部门主管和系统管理员，并根据角色提供不同的操作权限和视图。

## 2. 技术选型

本项目采用业界主流的前后端分离架构，具体技术选型如下：

**后端 (Spring Boot):**

*   **核心框架:** Spring Boot 2.x - 快速构建、简化配置的 Java 开发框架。
*   **持久层框架:** MyBatis - 灵活的 SQL 映射框架，便于 SQL 优化和复杂查询。
*   **数据库:** MySQL 5.7+ - 成熟稳定、广泛使用的关系型数据库。
*   **分页插件:** PageHelper - MyBatis 的物理分页插件，简化分页查询实现。
*   **工具库:** Hutool - Java 工具类库，简化常用操作。
*   **认证与授权:** 基于 JWT (JSON Web Token) 实现无状态认证，结合 Spring Security (或自定义拦截器) 进行权限控制。
*   **构建工具:** Maven / Gradle - 依赖管理和项目构建。
*   **开发语言:** Java 8+

**前端 (Vue.js):**

*   **核心框架:** Vue.js 2.x - 轻量、易用的渐进式 JavaScript 框架。
*   **UI 组件库:** Element UI - 提供丰富、高质量的 Vue 组件，加速前端开发。
*   **HTTP 客户端:** Axios (封装在 `$request`) - 用于与后端 API 进行交互。
*   **路由管理:** Vue Router - 管理前端页面路由。
*   **状态管理:** (可能使用 Vuex，根据项目复杂性决定，当前代码片段未明确显示)
*   **数据可视化:** ECharts - 用于在管理员仪表盘展示各类统计图表。
*   **构建工具:** Webpack / Vue CLI - 前端项目构建和打包。
*   **开发语言:** JavaScript (ES6+)

## 3. 主要功能模块

系统根据用户角色划分功能权限，主要模块包括：

*   **登录/注册模块:**
    *   用户登录 (区分管理员和普通用户)
    *   (可能包含)用户注册功能
    *   应急登录机制 (本地模拟，用于开发或演示)
*   **系统首页/仪表盘 (`Home.vue`):**
    *   **管理员视图:** 系统公告、财务收支图表 (饼图、折线图、柱状图)、部门薪资统计图表。
    *   **部门主管视图:** 欢迎信息、部门概览 (名称、员工数)、待办事项 (请假/资产审批数量)、部门员工列表、最新公告。
    *   **普通员工视图:** 欢迎信息、个人申请统计、最新公告。
*   **信息管理 (管理员):**
    *   公告管理 (`Notice.vue`): 发布、修改、删除系统公告。
    *   部门管理 (`Department.vue`): 添加、修改、删除部门信息，指定部门主管。
*   **人事管理:**
    *   **薪资管理 (`Salary.vue`):** 录入、查询员工薪资信息 (管理员或财务权限)。
    *   **财务支出 (`Financial.vue`, 管理员):** 记录、查询各部门财务支出。
    *   **请假申请/记录 (`AskRecord.vue`, 员工):** 员工提交请假申请、查看个人请假记录。
    *   **请假审批 (`AskApply.vue`, 主管/管理员):** 部门主管审批本部门员工请假，管理员进行最终审批。
    *   **资产信息 (`Resources.vue`):** 管理固定资产信息（名称、图片、价格、数量）。
    *   **资产申请/记录 (`ResourcesMy.vue`, 员工):** 员工申请资产、查看个人资产申请记录。
    *   **资产审批 (`ResourcesApply.vue`, 主管/管理员):** 部门主管审批本部门员工资产申请，管理员进行最终审批。
*   **用户管理 (管理员/主管):**
    *   管理员信息 (`Admin.vue`, 管理员): 管理系统管理员账号。
    *   员工信息 (`Employee.vue`): 管理员工信息 (管理员管理所有，主管管理本部门)。
*   **个人中心:**
    *   个人信息查看/修改 (`goToPerson` 跳转)
    *   修改密码 (`Password.vue`)
    *   退出登录

## 4. 架构设计

*   **前后端分离架构:** 前端 Vue.js 负责视图展示和用户交互，后端 Spring Boot 负责业务逻辑处理和数据持久化。两者通过 RESTful API 进行通信。
*   **RESTful API:** 后端遵循 RESTful 风格设计 API 接口，使用 HTTP 方法 (GET, POST, PUT, DELETE) 对应资源的操作。
*   **MVC (后端):** Spring Boot 遵循 MVC 设计模式，Controller 处理请求，Service 处理业务逻辑，Mapper/DAO (MyBatis) 与数据库交互。
*   **RBAC (Role-Based Access Control):** 系统设计了三种主要角色：管理员 (ADMIN)、部门主管 (HEADER/主管)、普通员工 (USER/员工)。通过用户登录时返回的角色和级别信息，在前端控制菜单和按钮的显示/隐藏，在后端通过拦截器或逻辑判断控制 API 的访问权限。
*   **审批流程:** 请假和资产申请采用二级审批流程：员工提交 -> 部门主管审批 -> (若主管通过) 管理员审批 -> 结束。

### 前端架构 (MVVM模式)

#### 1. 视图层 (View)
- 基于 Vue.js 2.x 构建的响应式界面
- 使用 Element UI 组件库实现统一的界面设计
- 支持组件复用和动态渲染

#### 2. 视图模型层 (ViewModel)
- 采用 Vue 组件化开发，实现数据与视图的双向绑定
- 通过 computed 属性实现数据的派生和缓存
- 使用 watch 监听器处理复杂的数据变化
- 组件生命周期钩子管理数据加载和清理

#### 3. 状态管理 (Vuex)
- 全局状态管理，处理跨组件数据共享
- 模块化的状态管理，包括：
  - 用户状态 (user)
  - 部门状态 (department)
  - 审批状态 (approval)
- 异步操作处理：
  - Action 处理异步请求
  - Mutation 同步更新状态
  - Getter 计算派生状态

#### 4. 数据流转机制
- 单向数据流
  - 状态变更统一通过 Mutation 提交
  - 组件通过 Action 触发异步操作
  - 通过 Getter 获取处理后的状态
- 双向数据绑定
  - v-model 实现表单数据的双向绑定
  - .sync 修饰符处理父子组件的双向数据同步

## 5. 数据库设计

数据库设计遵循关系型数据库范式，主要数据表包括：

*   `admin`: 管理员信息表。
*   `employee`: 员工信息表 (包含角色、级别、所属部门等)。
*   `department`: 部门信息表 (包含主管ID)。
*   `notice`: 公告信息表。
*   `resources`: 资产信息表。
*   `resourceapply`: 资产申请审批表 (记录申请详情、进度、状态)。
*   `askapply`: 请假申请审批表 (记录申请详情、进度、状态)。
*   `salary`: 薪资信息表。
*   `financial`: 财务支出表。

详细表结构及初始数据请参见项目根目录下的 `resources_manager.sql` 文件。

## 6. 环境部署与运行

**环境准备:**

*   Java Development Kit (JDK) 8 或更高版本
*   Maven 3.x / Gradle 6.x 或更高版本
*   MySQL 5.7 或更高版本
*   Node.js 14.x 或更高版本 (包含 npm)
*   (可选) Git

## 核心功能实现

### 1. MVVM 架构实现示例 (公告管理模块)

#### 1.1 视图层 (View)
```vue
视图层 (View)
<!-- Notice.vue -->
<template>
  <div>
    <div class="search">
      <el-input placeholder="请输入标题查询" style="width: 200px" v-model="title"></el-input>
      <el-button type="info" plain style="margin-left: 10px" @click="load(1)">查询</el-button>
      <el-button type="warning" plain style="margin-left: 10px" @click="reset">重置</el-button>
    </div>

    <div class="operation">
      <el-button type="primary" plain @click="handleAdd">新增</el-button>
      <el-button type="danger" plain @click="delBatch">批量删除</el-button>
    </div>

    <div class="table">
      <el-table :data="tableData" stripe @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center"></el-table-column>
        <el-table-column prop="id" label="序号" width="80" align="center" sortable></el-table-column>
        <el-table-column prop="title" label="标题" show-overflow-tooltip></el-table-column>
        <el-table-column prop="content" label="内容" show-overflow-tooltip></el-table-column>
        <el-table-column prop="time" label="创建时间"></el-table-column>
        <el-table-column prop="user" label="创建人"></el-table-column>
      </el-table>
    </div>
  </div>
</template>

<script>
export default {
  name: "Notice",
  data() {
    return {
      tableData: [],
      title: null,
      form: {},
      rules: {
        title: [
          {required: true, message: '请输入标题', trigger: 'blur'},
        ],
        content: [
          {required: true, message: '请输入内容', trigger: 'blur'},
        ]
      }
    }
  },
  methods: {
    load(pageNum) {
      this.$request.get('/notice/selectPage', {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize,
          title: this.title,
        }
      }).then(res => {
        this.tableData = res.data?.list
        this.total = res.data?.total
      })
    }
  }
}
</script>
```

#### 1.2 控制器层 (Controller)
```java
控制器层 (Controller)
@RestController
@RequestMapping("/notice")
public class NoticeController {
    @Resource
    private NoticeService noticeService;

    @GetMapping("/selectAll")
    public Result selectAll(Notice notice) {
        List<Notice> list = noticeService.selectAll(notice);
        return Result.success(list);
    }

    @GetMapping("/public")
    public Result getPublicNotices(@RequestParam(defaultValue = "5") Integer limit) {
        List<Notice> latestNotices = noticeService.getLatestNotices(limit);
        return Result.success(latestNotices);
    }

    @PostMapping("/add")
    public Result add(@RequestBody Notice notice) {
        noticeService.add(notice);
        return Result.success();
    }
}
```

#### 1.3 服务层 (Service)
```java
服务层 (Service)
@Service
public class NoticeService {
    @Resource
    private NoticeMapper noticeMapper;

    public void add(Notice notice) {
        notice.setTime(DateUtil.today());
        Account currentUser = TokenUtils.getCurrentUser();
        notice.setUser(currentUser.getUsername());
        noticeMapper.insert(notice);
    }

    public List<Notice> selectAll(Notice notice) {
        return noticeMapper.selectAll(notice);
    }

    public List<Notice> getLatestNotices(Integer limit) {
        PageHelper.startPage(1, limit);
        List<Notice> list = noticeMapper.selectAll(null);
        return list;
    }
}
```

#### 1.4 数据访问层 (Mapper)
```xml
数据访问层 (Mapper)
<!-- NoticeMapper.xml -->
<mapper namespace="com.example.mapper.NoticeMapper">
    <select id="selectAll" resultType="com.example.entity.Notice">
        select id, title, content, time, user
        from notice
        <where>
            <if test="title != null"> and title like concat('%', #{title}, '%')</if>
            <if test="content != null"> and content= #{content}</if>
            <if test="time != null"> and time= #{time}</if>
            <if test="user != null"> and user= #{user}</if>
        </where>
        order by id desc
    </select>
</mapper>
```

### 2. 请求拦截器实现
```javascript
请求拦截器实现
// request.js
import axios from 'axios'
import router from "@/router"

const request = axios.create({
    baseURL: process.env.VUE_APP_BASEURL,
    timeout: 30000
})

request.interceptors.request.use(config => {
    config.headers['Content-Type'] = 'application/json;charset=utf-8';
    let user = JSON.parse(localStorage.getItem("xm-user") || '{}')
    if (user.token) {
        config.headers['token'] = user.token
    }
    return config
})

request.interceptors.response.use(
    response => {
        let res = response.data;
        if (typeof res === 'string') {
            res = res ? JSON.parse(res) : res
        }
        if (res.code === '401') {
            router.push('/login')
        }
        return res;
    }
)

export default request
```

### 3. 组件间通信示例
```vue
组件间通信示例
<!-- Welcome.vue -->
<script>
export default {
  name: "Welcome",
  props: {
    departmentName: {
      type: String,
      default: ''
    },
    departmentHeader: {
      type: String,
      default: ''
    }
  },
  computed: {
    displayDepartmentName() {
      return this.departmentInfo.name || this.departmentName || this.user.departmentName || '未分配部门';
    }
  },
  watch: {
    departmentName: {
      handler(newVal) {
        if (newVal) {
          this.departmentInfo.name = newVal;
        }
      },
      immediate: true
    }
  }
}
</script>
```
