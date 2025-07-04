<template>
  <div>
    <div class="search">
      <el-input placeholder="请输入员工姓名查询" style="width: 200px" v-model="employeeName"></el-input>
      <el-button type="info" plain style="margin-left: 10px" @click="load(1)">查询</el-button>
      <el-button type="warning" plain style="margin-left: 10px" @click="reset">重置</el-button>
    </div>

    <div class="operation">
      <el-button type="primary" plain @click="handleAdd">新增</el-button>
      <el-button type="danger" plain @click="delBatch">批量删除</el-button>
    </div>

    <div class="table">
      <el-table :data="tableData" :key="tableKey" stripe  @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center"></el-table-column>
        <el-table-column prop="id" label="序号" width="80" align="center" sortable></el-table-column>
        <el-table-column prop="employeeName" label="员工姓名" show-overflow-tooltip></el-table-column>
        <el-table-column prop="departmentName" label="所属部门" show-overflow-tooltip></el-table-column>
        <el-table-column prop="year" label="年月"></el-table-column>
        <el-table-column prop="time" label="发放时间"></el-table-column>
        <el-table-column prop="price" label="发放薪资"></el-table-column>
        <el-table-column prop="note" label="备注说明"></el-table-column>

        <el-table-column label="操作" width="180" align="center">
          <template v-slot="scope">
            <el-button plain type="primary" @click="handleEdit(scope.row)" size="mini">编辑</el-button>
            <el-button plain type="danger" size="mini" @click=del(scope.row.id)>删除</el-button>
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
        <el-form-item prop="employeeId" label="选择员工">
          <el-select v-model="form.employeeId" placeholder="请选择员工" style="width: 100%">
            <el-option v-for="item in employeeData" :key="item.id" :label="item.name" :value="item.id"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item prop="year" label="发放年月">
          <el-date-picker style="width: 100%"
              v-model="form.year"
              type="month"
              value-format="yyyy-MM"
              placeholder="选择月">
          </el-date-picker>
        </el-form-item>
        <el-form-item prop="time" label="发放时间">
          <el-date-picker style="width: 100%"
              v-model="form.time"
              type="datetime"
              value-format="yyyy-MM-dd HH:mm:ss"
              placeholder="选择日期时间">
          </el-date-picker>
        </el-form-item>
        <el-form-item prop="price" label="发放薪资">
          <el-input v-model="form.price" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item prop="note" label="备注说明">
          <el-input v-model="form.note" autocomplete="off"></el-input>
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
      employeeName: null, // 新增员工姓名查询参数
      tableKey: 0, // Add key for forcing table re-render
      fromVisible: false,
      form: {},
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
      rules: {
        employeeId: [
          {required: true, message: '请选择员工', trigger: 'blur'},
        ],
        year: [
          {required: true, message: '请选择发放年月', trigger: 'blur'},
        ],
        price: [
          {required: true, message: '请输入发放薪资', trigger: 'blur'},
        ]
      },
      ids: [],
      employeeData: [],
    }
  },
  created() {
    this.load(1)
    this.loadEmployee()
  },
  methods: {
    loadEmployee() {
      if (this.user.role === 'ADMIN') {
        this.$request.get('/employee/selectAll').then(res => {
          if (res.code === '200') {
            this.employeeData = res.data
          } else {
            this.$message.error(res.msg)
          }
        })
      } else if (this.isHeader) {
        this.$request.get('/employee/selectByDepartment', {
          params: { departmentId: this.user.departmentId }
        }).then(res => {
          if (res.code === '200') {
            this.employeeData = res.data
          } else {
            this.$message.error(res.msg)
          }
        })
      } else {
        this.employeeData = [{
          id: this.user.id,
          name: this.user.name
        }]
      }
    },
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
            url: this.form.id ? '/salary/update' : '/salary/add',
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
        this.$request.delete('/salary/delete/' + id).then(res => {
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
        this.$request.delete('/salary/delete/batch', {data: this.ids}).then(res => {
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
      if (pageNum) this.pageNum = pageNum;
      
      let params = {
        pageNum: this.pageNum,
        pageSize: this.pageSize,
        employeeName: this.employeeName
      };
      
      this.$request.get('/salary/selectPage', {
        params: params
      }).then(res => {
        if (res.code === '200') {
          this.tableData = res.data?.list || [];
          this.total = res.data?.total || 0;
          this.tableKey++;
        } else {
          this.$message.error(res.msg || '查询失败');
          this.tableData = [];
          this.total = 0;
        }
      }).catch(error => {
        console.error('加载薪资数据失败:', error);
        this.$message.error('加载薪资数据失败');
        this.tableData = [];
        this.total = 0;
      });
    },
    reset() {
      this.employeeName = null;
      this.load(1);
    },
    handleCurrentChange(pageNum) {
      this.load(pageNum)
    },
  },
  computed: {
    isHeader() {
      return this.user.level === 'HEADER' || 
             (this.user.level && this.user.level.includes('主管'));
    }
  }
}
</script>

<style scoped>
/* Specific styles for Salary.vue if needed */

@media screen and (max-width: 768px) {
  /* 
  大部分通用元素的移动端适配（如 .search, .operation, .table, el-dialog,等）
  预计由 manager.css 或其他全局/组件级样式 (如 Admin.vue 中定义的)覆盖。
  */

  /* 如果 el-date-picker 在弹窗中显示不佳，可以取消以下注释并调整 */
  /*
  .el-dialog .el-date-editor.el-input,
  .el-dialog .el-date-editor.el-input__inner {
    width: 100% !important; 
  }
  */
}
</style>
