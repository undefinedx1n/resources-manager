<template>
  <div>
    <!-- 申请流程说明 -->
    <div class="process-guide">
      <el-card shadow="hover" class="guide-card">
        <div slot="header">
          <span><i class="el-icon-s-claim"></i> 请假申请流程</span>
        </div>
        <el-steps :space="200" :active="4" finish-status="success" align-center>
          <el-step title="提交申请" description="填写请假申请表单"></el-step>
          <el-step title="部门主管审批" description="由您的部门主管进行初审"></el-step>
          <el-step title="管理员审批" description="由系统管理员进行最终审批"></el-step>
          <el-step title="审批结果" description="查看申请的最终结果"></el-step>
        </el-steps>
      </el-card>
    </div>

    <div class="search">
      <el-button type="primary" @click="handleAdd" style="margin-right: 10px">提交请假申请</el-button>
      <el-input placeholder="请输入请假事由" style="width: 200px" v-model="name"></el-input>
      <el-button type="info" plain style="margin-left: 10px" @click="load(1)">查询</el-button>
      <el-button type="warning" plain style="margin-left: 10px" @click="reset">重置</el-button>
    </div>

    <div class="operation">
      <el-button type="danger" plain @click="delBatch">撤销申请</el-button>
    </div>

    <div class="table">
      <el-table :data="tableData" stripe border @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center"></el-table-column>
        <el-table-column prop="id" label="序号" width="80" align="center" sortable></el-table-column>
        <el-table-column prop="name" label="请假事由"></el-table-column>
        <el-table-column prop="start" label="开始日期"></el-table-column>
        <el-table-column prop="end" label="结束日期"></el-table-column>
        <el-table-column prop="process" label="当前进度">
          <template slot-scope="scope">
            <el-tag :type="getProcessType(scope.row.process)">{{ scope.row.process }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="审批状态">
          <template slot-scope="scope">
            <el-tag :type="getStatusType(scope.row.status)">{{ scope.row.status }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="note" label="审批说明"></el-table-column>
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
        <el-form-item prop="name" label="请假事由">
          <el-input v-model="form.name" autocomplete="off" placeholder="请输入请假事由"></el-input>
        </el-form-item>
        <el-form-item prop="start" label="开始时间">
          <el-date-picker style="width: 100%"
              v-model="form.start"
              type="date"
              value-format="yyyy-MM-dd"
              placeholder="选择日期">
          </el-date-picker>
        </el-form-item>
        <el-form-item prop="end" label="结束时间">
          <el-date-picker style="width: 100%"
              v-model="form.end"
              type="date"
              value-format="yyyy-MM-dd"
              placeholder="选择日期">
          </el-date-picker>
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
      rules: {
        name: [
          {required: true, message: '请输入请假事由', trigger: 'blur'},
        ],
        start: [
          {required: true, message: '请选择开始日期', trigger: 'blur'},
        ],
        end: [
          {required: true, message: '请选择结束日期', trigger: 'blur'},
        ]
      },
      ids: [],
      employeeData: [],
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
    save() {   // 保存按钮触发的逻辑  它会触发新增或者更新
      this.$refs.formRef.validate((valid) => {
        if (valid) {
          this.$request({
            url: this.form.id ? '/askapply/update' : '/askapply/add',
            method: this.form.id ? 'PUT' : 'POST',
            data: this.form
          }).then(res => {
            if (res.code === '200') {  // 表示成功保存
              this.$message.success('保存成功')
              this.load(1)
              this.fromVisible = false
            } else {
              this.$message.error(res.msg)  // 弹出错误的信息
            }
          })
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
      this.$request.get('/askapply/selectPage', {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize,
          name: this.name,
        }
      }).then(res => {
        this.tableData = res.data?.list
        this.total = res.data?.total
      })
    },
    reset() {
      this.name = null
      this.load(1)
    },
    handleCurrentChange(pageNum) {
      this.load(pageNum)
    },
    getProcessType(process) {
      if (process === '审批结束') return 'success';
      if (process === '主管审批中') return 'warning';
      if (process === '管理员审批中') return 'warning';
      return 'info';
    },
    getStatusType(status) {
      if (status === '审批通过' || status === '主管审批通过') return 'success';
      if (status === '主管审批不通过' || status === '管理员审批不通过') return 'danger';
      return 'warning';
    }
  }
}
</script>

<style scoped>
.process-guide {
  margin-bottom: 20px;
}
.guide-card {
  margin-bottom: 15px;
}

@media screen and (max-width: 768px) {
  .process-guide .el-card__header {
    font-size: 16px; /* 调整卡片标题文字大小 */
    padding: 12px 15px; /* 调整卡片头部内边距 */
  }

  .process-guide .el-steps {
    /* 对于横向步骤条，如果内容过多，Element UI 默认会换行 */
    /* 我们可以尝试缩小字体和调整间距 */
  }

  .process-guide .el-step__title {
    font-size: 13px; /* 减小步骤标题字体 */
    line-height: 1.2;
  }

  .process-guide .el-step__description {
    font-size: 12px; /* 减小步骤描述字体 */
    margin-top: 2px;
  }
  
  .process-guide .el-step__head.is-finish .el-step__icon.is-text,
  .process-guide .el-step__head.is-process .el-step__icon.is-text,
  .process-guide .el-step__head.is-wait .el-step__icon.is-text {
    font-size: 12px; /* 步骤图标内数字大小 */
  }
  
  .process-guide .el-step.is-horizontal .el-step__line {
    top: 12px; /* 根据图标大小调整连接线位置 */
  }
  
  /* 搜索区域的 .el-button 和 .el-input 已由 manager.css 全局处理 */
  /* 操作区域的 .el-button 已由 manager.css 全局处理 */
  /* 表格容器 .table 的 overflow-x: auto 已由 manager.css 全局处理 */
  /* 弹窗 el-dialog, el-form-item, .dialog-footer 已由 Admin.vue 中的样式或 manager.css 全局处理 */
}
</style>
