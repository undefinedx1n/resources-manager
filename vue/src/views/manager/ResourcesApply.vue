<template>
  <div>
    <!-- 主管权限提示 -->
    <div v-if="isHeader" class="header-tips">
      <el-alert
        title="部门主管审批权限"
        type="warning"
        description="作为部门主管，您负责审批本部门员工的资产申请。审批通过后将转交给管理员进行最终审批。您的审批对部门资源分配非常重要。"
        show-icon
        :closable="false">
      </el-alert>

      <!-- 审批流程可视化 -->
      <div class="approval-flow">
        <el-steps :active="2" finish-status="success" simple>
          <el-step title="员工提交申请"></el-step>
          <el-step title="部门主管审批"></el-step>
          <el-step title="管理员最终审批"></el-step>
          <el-step title="审批完成"></el-step>
        </el-steps>
      </div>
    </div>

    <!-- 管理员权限提示 -->
    <div v-else-if="user.role === 'ADMIN'" class="header-tips">
      <el-alert
        title="管理员审批权限"
        type="warning"
        description="作为系统管理员，您负责最终审批已经通过部门主管审核的资产申请。您的决定将直接影响部门资源分配。"
        show-icon
        :closable="false">
      </el-alert>

      <!-- 审批流程可视化 -->
      <div class="approval-flow">
        <el-steps :active="3" finish-status="success" simple>
          <el-step title="员工提交申请"></el-step>
          <el-step title="部门主管审批"></el-step>
          <el-step title="管理员最终审批"></el-step>
          <el-step title="审批完成"></el-step>
        </el-steps>
      </div>
    </div>

    <div class="search">
      <el-input placeholder="请输入资产名称" style="width: 200px" v-model="name"></el-input>
      <el-button type="info" plain style="margin-left: 10px" @click="load(1)">查询</el-button>
      <el-button type="warning" plain style="margin-left: 10px" @click="reset">重置</el-button>
    </div>

    <div class="table">
      <el-table :data="tableData" stripe  @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center"></el-table-column>
        <el-table-column prop="id" label="序号" width="80" align="center" sortable></el-table-column>
        <el-table-column prop="employeeName" label="员工姓名" show-overflow-tooltip></el-table-column>
        <el-table-column prop="departmentName" label="所属部门" show-overflow-tooltip></el-table-column>
        <el-table-column prop="resourceName" label="资产名称"></el-table-column>
        <el-table-column prop="num" label="申请数量"></el-table-column>
        <el-table-column prop="time" label="申请时间"></el-table-column>
        <el-table-column prop="process" label="当前进度"></el-table-column>
        <el-table-column prop="status" label="审批状态"></el-table-column>
        <el-table-column prop="note" label="审批说明"></el-table-column>
        <el-table-column v-if="user.role === 'ADMIN' || user.level === '主管'" label="操作">
          <template v-slot="scope">
            <el-button type="primary" plain @click="handleEdit(scope.row)">审批</el-button>
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


    <el-dialog title="信息" :visible.sync="fromVisible" width="40%" :close-on-click-modal="false" destroy-on-close>
      <el-form label-width="100px" style="padding-right: 50px" :model="form" :rules="rules" ref="formRef">
        <el-form-item prop="name" label="请审批">
          <el-select v-model="status" placeholder="请选择状态" style="width: 100%">
            <el-option label="审批通过" value="审批通过"></el-option>
            <el-option label="审批不通过" value="审批不通过"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item prop="note" label="审批说明">
          <el-input v-model="form.note" autocomplete="off" placeholder="请输入审批说明"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="fromVisible = false">取 消</el-button>
        <el-button type="primary" @click="save">确 定</el-button>
      </div>
    </el-dialog>


  </div>
</template>

<script>
export default {
  name: "Department",
  data() {
    return {
      tableData: [],  // 所有的数据
      pageNum: 1,   // 当前的页码
      pageSize: 10,  // 每页显示的个数
      total: 0,
      name: null,
      fromVisible: false,
      form: {},
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
      ids: [],
      status: null,
      rules: {
        name: [
          {required: true, message: '请选择审批状态', trigger: 'blur'},
        ],
        note: [
          {required: true, message: '请输入审批说明', trigger: 'blur'},
        ]
      }
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
    this.load(1)
  },
  methods: {
    handleAdd() {   // 新增数据
      this.form = {}  // 新增数据的时候清空数据
      this.fromVisible = true   // 打开弹窗
    },
    handleEdit(row) {   // 编辑数据
      this.form = JSON.parse(JSON.stringify(row))  // 给form对象赋值  注意要深拷贝数据
      this.fromVisible = true   // 打开弹窗
    },
    save() {
      this.form.status = this.status
      this.$request.put('/resourceapply/update', this.form).then(res => {
        if (res.code === '200') {
          this.$message.success('操作成功')
          this.load(1)
          this.fromVisible = false
          this.status = null
        } else {
          this.$message.error(res.msg)
        }
      })
    },
    del(id) {   // 单个删除
      this.$confirm('您确定删除吗？', '确认删除', {type: "warning"}).then(response => {
        this.$request.delete('/resourceapply/delete/' + id).then(res => {
          if (res.code === '200') {   // 表示操作成功
            this.$message.success('操作成功')
            this.load(1)
          } else {
            this.$message.error(res.msg)  // 弹出错误的信息
          }
        })
      }).catch(() => {
      })
    },
    handleSelectionChange(rows) {   // 当前选中的所有的行数据
      this.ids = rows.map(v => v.id)   //  [1,2]
    },
    delBatch() {   // 批量删除
      if (!this.ids.length) {
        this.$message.warning('请选择数据')
        return
      }
      this.$confirm('您确定批量删除这些数据吗？', '确认删除', {type: "warning"}).then(response => {
        this.$request.delete('/resourceapply/delete/batch', {data: this.ids}).then(res => {
          if (res.code === '200') {   // 表示操作成功
            this.$message.success('操作成功')
            this.load(1)
          } else {
            this.$message.error(res.msg)  // 弹出错误的信息
          }
        })
      }).catch(() => {
      })
    },
    load(pageNum) {  // 分页查询
      if (pageNum) {
        this.pageNum = pageNum
      }
      
      // Prepare query parameters
      const params = {
        pageNum: this.pageNum,
        pageSize: this.pageSize,
        name: this.name || null,  // Ensure null if empty
        departmentId: this.isHeader && this.user.role !== 'ADMIN' ? this.user.departmentId : null
      }

      // Clear table data before loading
      this.tableData = []
      
      this.$request.get('/resourceapply/selectPage', {
        params: params
      }).then(res => {
        if (res.code === '200') {
          if (res.data && Array.isArray(res.data.list)) {
            this.tableData = res.data.list
            this.total = res.data.total || 0
          } else {
            this.$message.warning('未找到匹配的数据')
            this.total = 0
          }
        } else {
          this.$message.error(res.msg || '查询失败')
          this.total = 0
        }
      }).catch(error => {
        console.error('Query failed:', error)
        this.$message.error('查询失败，请稍后重试')
        this.total = 0
      })
    },
    reset() {
      this.name = null
      this.tableData = []
      this.total = 0
      this.load(1)
    },
    handleCurrentChange(pageNum) {
      this.load(pageNum)
    },
  }
}
</script>

<style scoped>
.header-tips {
  margin-bottom: 20px;
}
.approval-flow {
  margin-top: 20px;
  background-color: #f5f7fa;
  padding: 20px;
  border-radius: 4px;
}


/* Responsive adjustments for smaller screens */
@media (max-width: 768px) {
  .search {
    display: flex;
    flex-direction: column;
  }
  .search .el-input {
    width: 100% !important;
    margin-bottom: 10px;
  }
  .search .el-button {
    width: 100%;
    margin-left: 0 !important;
    margin-bottom: 10px;
  }
  .search .el-button:last-child {
    margin-bottom: 0;
  }

  .table {
    overflow-x: auto; /* Allow table to scroll horizontally */
  }

  .el-dialog {
    width: 90% !important; /* Adjust dialog width for small screens */
  }

  .el-form-item__label {
    text-align: left; /* Align form labels to the left on small screens */
  }

  .el-form-item__content {
    margin-left: 0 !important; /* Remove left margin for form content */
  }

  .header-tips .el-alert {
    padding: 8px 16px;
  }

  .header-tips .el-alert__title {
    font-size: 14px;
  }

  .header-tips .el-alert__description {
    font-size: 12px;
  }

  .approval-flow .el-step__title {
    font-size: 12px; /* Adjust step title font size */
    line-height: 1.2;
  }

  .el-table th,
  .el-table td {
    padding: 8px 0; /* Reduce padding in table cells */
  }
}
</style>
