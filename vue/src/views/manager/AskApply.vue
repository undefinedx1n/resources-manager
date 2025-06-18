<template>
  <div>
    <!-- 主管权限提示 -->
    <div v-if="isHeader" class="header-tips">
      <el-alert
        title="部门主管审批权限"
        type="warning"
        description="作为部门主管，您负责审批本部门员工的请假申请。审批通过后将转交给管理员进行最终审批。您的审批对员工非常重要。"
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
        description="作为系统管理员，您负责最终审批已经通过部门主管审核的请假申请。您的决定将直接影响员工请假审批结果。"
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
      <el-input placeholder="请输入请假事由" style="width: 200px" v-model="name"></el-input>
      <el-button type="info" plain style="margin-left: 10px" @click="load(1)">查询</el-button>
      <el-button type="warning" plain style="margin-left: 10px" @click="reset">重置</el-button>
    </div>

    <div class="table">
      <el-table :data="tableData" stripe  @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center"></el-table-column>
        <el-table-column prop="id" label="序号" width="80" align="center" sortable></el-table-column>
        <el-table-column prop="employeeName" label="员工姓名" show-overflow-tooltip></el-table-column>
        <el-table-column prop="departmentName" label="所属部门" show-overflow-tooltip></el-table-column>
        <el-table-column prop="name" label="请假事由"></el-table-column>
        <el-table-column prop="start" label="开始日期"></el-table-column>
        <el-table-column prop="end" label="结束日期"></el-table-column>
        <el-table-column prop="process" label="当前进度"></el-table-column>
        <el-table-column prop="status" label="审批状态"></el-table-column>
        <el-table-column prop="note" label="审批说明"></el-table-column>
        <el-table-column label="操作">
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
      this.$request.put('/askapply/update', this.form).then(res => {
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
        this.$request.delete('/askapply/delete/' + id).then(res => {
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
        this.$request.delete('/askapply/delete/batch', {data: this.ids}).then(res => {
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
      if (pageNum) this.pageNum = pageNum
      const params = {
        pageNum: this.pageNum,
        pageSize: this.pageSize
      }
      if (this.name) params.name = this.name
      
      // 清空表格数据，准备接收新数据
      this.tableData = []
      
      this.$request.get('/askapply/selectPage2', { params })
        .then(res => {
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
        })
        .catch(error => {
          console.error('查询失败:', error)
          this.$message.error('查询失败，请稍后重试')
          this.total = 0
        })
    },
    reset() {
      this.name = null
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

@media screen and (max-width: 768px) {
  /* 权限提示区域 */
  .header-tips .el-alert__description {
    font-size: 13px; /* 调整提示描述文字大小 */
    line-height: 1.4;
  }

  .approval-flow .el-step__title {
    font-size: 12px; /* 调整步骤条文字大小 */
  }

  /* 表格内操作按钮 */
  .el-table .el-button {
    /* 如果需要，可以使按钮占据整行或调整间距 */
    /* 例如：
    display: block;
    width: 100%;
    margin: 5px 0;
    */
    /* 当前Admin.vue中的样式可能已覆盖此部分，先观察效果 */
  }

  /* 搜索区域的 el-input 和 el-button 已由 manager.css 全局处理 */
  /* 表格容器 .table 的 overflow-x: auto 已由 manager.css 全局处理 */
  /* 分页 .pagination 已由 manager.css 全局处理 */
  /* 弹窗 el-dialog, el-form-item, .dialog-footer 已由 Admin.vue 中的样式或 manager.css 全局处理 */

  /* 如果弹窗宽度仍有问题，可以针对性调整 */
  /* .el-dialog {
    width: 90% !important; 
  }*/

  /* 如果步骤条在极小屏幕上依然拥挤，可以进一步调整 */
  .approval-flow .el-step.is-simple {
    flex-basis: auto !important; /* 允许步骤收缩 */
  }
}
</style>
