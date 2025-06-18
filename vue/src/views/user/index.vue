<template>
  <div>
    <!-- 主管视图：显示部门提示和员工列表 -->
    <div v-if="isHeader" class="header-view">
      <el-alert
        :title="'您正在管理部门：' + user.departmentName"
        type="success"
        :closable="false">
        <template slot="title">
          <div style="display: flex; align-items: center;">
            <i class="el-icon-s-custom" style="margin-right: 5px;"></i>
            <span>您正在管理部门：<b>{{ user.departmentName }}</b></span>
          </div>
        </template>
        <div>作为部门主管，您可以查看和管理本部门的所有员工信息。</div>
      </el-alert>
    </div>

    <div class="search" style="margin-top: 15px;">
      <el-input placeholder="请输入姓名查询" style="width: 200px" v-model="name"></el-input>
      <el-select v-model="departmentId" placeholder="请选择部门" style="width: 200px; margin-left: 10px" v-if="user.role === 'ADMIN'">
        <el-option v-for="item in departmentList" :key="item.id" :label="item.name" :value="item.id"></el-option>
      </el-select>
      <el-button type="info" plain style="margin-left: 10px" @click="load(1)">查询</el-button>
      <el-button type="warning" plain style="margin-left: 10px" @click="reset">重置</el-button>
      <div style="float: right">
        <el-button type="primary" @click="handleAdd">新增</el-button>
        <el-button type="danger" @click="delBatch">批量删除</el-button>
      </div>
    </div>

    <div class="table">
      <el-table :data="tableData" stripe border @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center"></el-table-column>
        <el-table-column prop="id" label="ID" width="80" align="center" sortable></el-table-column>
        <el-table-column prop="name" label="姓名" width="120"></el-table-column>
        <el-table-column prop="level" label="职位" width="120">
          <template slot-scope="scope">
            <el-tag size="mini" type="success" v-if="scope.row.level === 'HEADER'">部门主管</el-tag>
            <el-tag size="mini" type="info" v-else>普通员工</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="departmentName" label="所属部门" width="150"></el-table-column>
        <el-table-column prop="phone" label="联系电话"></el-table-column>
        <el-table-column prop="email" label="邮箱地址"></el-table-column>
        <el-table-column label="操作" width="250" align="center">
          <template slot-scope="scope">
            <!-- 如果是主管，只能编辑自己部门的员工 -->
            <el-button v-if="canEdit(scope.row)" type="primary" plain @click="handleEdit(scope.row)">编辑</el-button>
            <el-button v-if="canDelete(scope.row)" type="danger" plain @click="del(scope.row.id)">删除</el-button>
            <el-button v-if="user.role === 'ADMIN' && scope.row.level !== 'HEADER'" type="success" plain @click="setAsHeader(scope.row)">设为主管</el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination">
        <el-pagination
            background
            @current-change="handleCurrentChange"
            :current-page="pageNum"
            :page-sizes="[5, 10, 20]"
            :page-size="pageSize"
            layout="total, prev, pager, next"
            :total="total">
        </el-pagination>
      </div>
    </div>

    <!-- 表单弹窗 -->
    <!-- 保留原有表单弹窗代码 -->
  </div>
</template>

<script>
export default {
  name: "User",
  data() {
    return {
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
      tableData: [],
      pageNum: 1,
      pageSize: 10,
      total: 0,
      name: null,
      departmentId: null,
      departmentList: [],
      // 保留原有其他数据
    }
  },
  computed: {
    isHeader() {
      return this.user.level === 'HEADER' || 
             this.user.role === 'HEADER' || 
             (this.user.level && this.user.level.includes('主管'));
    }
  },
  created() {
    this.load(1);
    if (this.user.role === 'ADMIN') {
      this.loadDepartmentList();
    }
  },
  methods: {
    load(pageNum) {
      if (pageNum) this.pageNum = pageNum;
      
      let params = {
        pageNum: this.pageNum,
        pageSize: this.pageSize,
        name: this.name,
        departmentId: this.departmentId
      };
      
      // 如果是主管，只查询自己部门的员工
      if (this.isHeader && this.user.role !== 'ADMIN') {
        params.departmentId = this.user.departmentId;
      }
      
      this.$request.get('/employee/selectPage', { params }).then(res => {
        this.tableData = res.data?.list || [];
        this.total = res.data?.total || 0;
      });
    },
    loadDepartmentList() {
      this.$request.get('/department/selectAll').then(res => {
        if (res.code === '200') {
          this.departmentList = res.data || [];
        }
      });
    },
    canEdit(row) {
      // 管理员可以编辑所有人，主管只能编辑自己部门的普通员工或自己
      return this.user.role === 'ADMIN' || 
             (this.isHeader && (row.departmentId === this.user.departmentId) && 
              (row.level !== 'HEADER' || row.id === this.user.id));
    },
    canDelete(row) {
      // 管理员可以删除所有人，主管只能删除自己部门的普通员工
      return this.user.role === 'ADMIN' || 
             (this.isHeader && row.departmentId === this.user.departmentId && 
              row.level !== 'HEADER' && row.id !== this.user.id);
    },
    setAsHeader(row) {
      this.$confirm('确定将 ' + row.name + ' 设置为 ' + row.departmentName + ' 的部门主管吗？', '设置主管', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$request.put('/employee/setAsHeader/' + row.id).then(res => {
          if (res.code === '200') {
            this.$message.success('设置成功');
            this.load(this.pageNum);
          } else {
            this.$message.error(res.msg);
          }
        });
      }).catch(() => {});
    },
    // 保留原有其他方法
  }
}
</script>

<style scoped>
.header-view {
  margin-bottom: 15px;
}

@media screen and (max-width: 768px) {
  /* 主管提示信息 */
  .header-view :deep(.el-alert__title) {
    font-size: 14px; /* 调整标题文字大小 */
  }
  .header-view :deep(.el-alert__description) {
    font-size: 12px; /* 调整描述文字大小 */
  }
  .header-view :deep(.el-alert .el-icon-s-custom) {
    font-size: 16px; /* 调整图标大小 */
    margin-right: 3px;
  }

  /* 搜索区域的右浮动按钮 */
  /* manager.css 中 .search .el-button 和 .search div[style*="float: right"] 已处理按钮堆叠 */
  /* 此处无需额外处理，除非有特殊需求 */

  /* 表格内操作按钮 */
  /* 同样，Admin.vue 和 manager.css 中的样式应能覆盖 */
  /* 例如： .el-table .el-button {
    display: block;
    width: calc(100% - 10px);
    margin: 5px auto !important;
  }
  .el-table .el-button + .el-button {
    margin-left: auto !important; 
  } */

  /* 其他通用元素 .search, .table, .pagination 等 */
  /* 预计由 manager.css 或 Admin.vue 中的全局样式覆盖 */
}
</style> 