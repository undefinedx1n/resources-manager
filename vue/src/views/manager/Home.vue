<template>
  <div>
    <!-- 主管仪表盘 -->
    <div v-if="isHeader" class="dashboard-header">
      <el-card style="margin-bottom: 20px">
        <welcome-component :department-name="departmentInfo.name" :department-header="departmentInfo.headerName"></welcome-component>
      </el-card>
      
      <el-row :gutter="20">
        <el-col :span="8">
          <el-card shadow="hover">
            <div slot="header">
              <span><i class="el-icon-s-custom"></i> 部门管理</span>
            </div>
            <div class="dashboard-item">
              <div class="dashboard-num">{{ departmentInfo.name || '暂无数据' }}</div>
              <div class="dashboard-title">当前管理部门</div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="8">
          <el-card shadow="hover">
            <div slot="header">
              <span><i class="el-icon-user"></i> 员工管理</span>
            </div>
            <div class="dashboard-item">
              <div class="dashboard-num">{{ departmentInfo.employeeCount || 0 }}</div>
              <div class="dashboard-title">部门员工数</div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="8">
          <el-card shadow="hover">
            <div slot="header">
              <span><i class="el-icon-s-claim"></i> 待办事项</span>
            </div>
            <div class="dashboard-item">
              <div class="dashboard-num">{{ pendingTasks.askCount + pendingTasks.resourceCount }}</div>
              <div class="dashboard-title">待审批事项</div>
              <div class="dashboard-detail">
                <el-tag size="small" type="warning">请假审批: {{ pendingTasks.askCount }}</el-tag>
                <el-tag size="small" type="warning" style="margin-left: 10px">资产审批: {{ pendingTasks.resourceCount }}</el-tag>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>

      <div style="margin-top: 20px">
        <el-card shadow="hover">
          <div slot="header">
            <span><i class="el-icon-s-grid"></i> 部门员工</span>
            <el-button style="float: right; padding: 3px 0" type="text" @click="goToEmployeeList">查看全部</el-button>
          </div>
          <el-table :data="departmentEmployees" stripe style="width: 100%">
            <el-table-column prop="name" label="姓名"></el-table-column>
            <el-table-column prop="phone" label="联系电话"></el-table-column>
            <el-table-column prop="email" label="邮箱"></el-table-column>
            <el-table-column prop="level" label="级别">
              <template slot-scope="scope">
                <el-tag size="mini" v-if="scope.row.level === 'HEADER'" type="success">部门主管</el-tag>
                <el-tag size="mini" v-else-if="scope.row.level === 'EMPLOYEE'" type="info">普通员工</el-tag>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </div>

      <!-- 公告列表 for Header -->
      <div style="margin-top: 20px">
        <el-card shadow="hover">
          <div slot="header">
            <span><i class="el-icon-bell"></i> 最新公告</span>
          </div>
          <el-timeline reverse>
            <el-timeline-item v-for="item in notices" :key="item.id" :timestamp="item.time">
              <el-popover
                  placement="right"
                  width="200"
                  trigger="hover"
                  :content="item.content">
                <span slot="reference">{{ item.title }}</span>
              </el-popover>
            </el-timeline-item>
          </el-timeline>
        </el-card>
      </div>
    </div>

    <!-- 员工仪表盘 -->
    <div v-else-if="user.role === 'USER'" class="dashboard-employee">
      <el-card style="margin-bottom: 20px">
        <welcome-component></welcome-component>
      </el-card>

      <!-- 公告列表 for User -->
      <div style="margin-top: 20px">
        <el-card shadow="hover">
          <div slot="header">
            <span><i class="el-icon-bell"></i> 最新公告</span>
          </div>
          <el-timeline reverse>
            <el-timeline-item v-for="item in notices" :key="item.id" :timestamp="item.time">
              <el-popover
                  placement="right"
                  width="200"
                  trigger="hover"
                  :content="item.content">
                <span slot="reference">{{ item.title }}</span>
              </el-popover>
            </el-timeline-item>
          </el-timeline>
        </el-card>
      </div>
    </div>

    <!-- 管理员仪表盘 -->
    <div v-else>
      <div class="card" style="padding: 15px">
        您好，{{ user?.name }}！欢迎使用本系统
      </div>

      <div style="display: flex; margin: 10px 0">
        <div style="width: 100%;" class="card">
          <div style="margin-bottom: 30px; font-size: 20px; font-weight: bold">公告列表</div>
          <div>
            <el-timeline  reverse>
              <el-timeline-item v-for="item in notices" :key="item.id" :timestamp="item.time">
                <el-popover
                    placement="right"
                    width="200"
                    trigger="hover"
                    :content="item.content">
                  <span slot="reference">{{ item.title }}</span>
                </el-popover>
              </el-timeline-item>
            </el-timeline>
          </div>
        </div>
      </div>
      <div style="display: flex" v-if="user.role === 'ADMIN'">
        <div id="pie" style="height: 450px; flex: 1" class="card"></div>
        <div style="height: 450px; flex: 1;" class="card">
          <el-select v-model="month" style="width: 50%" @change="getSalaryMonth(month)">
            <el-option v-for="item in monthData" :key="item.year" :label="item.year" :value="item.year"></el-option>
          </el-select>
          <div id="salaryBar" style="height: 400px; padding-top: 15px"></div>
        </div>
      </div>
      <div style="margin-top: 10px; display: flex" v-if="user.role === 'ADMIN'">
        <div id="line" style="height: 400px; flex: 1" class="card"></div>
        <div id="bar" style="height: 400px; flex: 1" class="card"></div>
      </div>
    </div>
  </div>
</template>

<script>
import * as echarts from "echarts";
import WelcomeComponent from "@/components/Welcome.vue";

let pieOptions = {
  title: {
    text: '', // 主标题
    subtext: '', // 副标题
    left: 'center',
    textStyle: {
      color: '#303133'
    }
  },
  tooltip: {
    trigger: 'item',
    formatter: '{a} <br/>{b} : {c} ({d}%)'
  },
  legend: {
    orient: 'vertical',
    left: 'left',
    textStyle: {
      color: '#606266'
    }
  },
  color: ['#5CB8E6', '#82C97B', '#F2C379', '#F56C6C', '#A0D9EF', '#91cc75', '#fac858', '#ee6666', '#73c0de'], // 清新蓝主题色系
  series: [
    {
      name: '', // 鼠标移上去显示内容
      type: 'pie',
      radius: '50%',
      center: ['50%', '60%'],
      data: [], // Initialize with empty data
      emphasis: {
        itemStyle: {
          shadowBlur: 10,
          shadowOffsetX: 0,
          shadowColor: 'rgba(0, 0, 0, 0.5)'
        }
      }
    }
  ]
}
let lineOptions = {
  title: {
    text: '', // 主标题
    subtext: '', // 副标题
    left: 'center',
    textStyle: {
      color: '#303133'
    }
  },
  xAxis: {
    type: 'category',
    data: [], // Initialize with empty data
    axisLine: { lineStyle: { color: '#A8ABB2' } },
    axisLabel: { color: '#606266' }
  },
  yAxis: {
    type: 'value',
    axisLine: { lineStyle: { color: '#A8ABB2' } },
    axisLabel: { color: '#606266' },
    splitLine: { lineStyle: { color: '#EBEEF5' } }
  },
  tooltip: {
    trigger: 'axis' // Use axis trigger for line chart
  },
  grid: {
    left: '3%',
    right: '4%',
    bottom: '3%',
    containLabel: true
  },
  series: [
    {
      data: [], // Initialize with empty data
      type: 'line',
      smooth: true,
      itemStyle: { color: '#5CB8E6' }, // 主色调
      lineStyle: { color: '#5CB8E6' },
      areaStyle: { // Optional: add gradient area style
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            {
              offset: 0,
              color: 'rgba(92, 184, 230, 0.5)' // Lighter blue gradient start
            },
            {
              offset: 1,
              color: 'rgba(92, 184, 230, 0.1)' // Lighter blue gradient end
            }
          ])
        }
    }
  ]
}
let barOptions = {
  title: {
    text: '', // 主标题
    subtext: '', // 副标题
    left: 'center',
    textStyle: {
      color: '#303133'
    }
  },
  xAxis: {
    type: 'category',
    data: [], // Initialize with empty data
    axisLine: { lineStyle: { color: '#A8ABB2' } },
    axisLabel: { color: '#606266' }
  },
  yAxis: {
    type: 'value',
    axisLine: { lineStyle: { color: '#A8ABB2' } },
    axisLabel: { color: '#606266' },
    splitLine: { lineStyle: { color: '#EBEEF5' } }
  },
  tooltip: {
    trigger: 'axis',
    axisPointer: { // Optional: customize tooltip pointer
      type: 'shadow'
    }
  },
  grid: {
    left: '3%',
    right: '4%',
    bottom: '3%',
    containLabel: true
  },
  series: [
    {
      data: [], // Initialize with empty data
      type: 'bar',
      barWidth: '60%', // Adjust bar width
      itemStyle: {
        color: '#5CB8E6', // 主色调
        borderRadius: [4, 4, 0, 0] // Optional: add border radius to top
      },
      emphasis: {
        itemStyle: {
          color: '#4AA8D8' // 悬停时稍深
        }
      }
    }
  ]
}
let barSalaryOptions = {
  title: {
    text: '', // 主标题
    subtext: '', // 副标题
    left: 'center',
    textStyle: {
      color: '#303133'
    }
  },
  xAxis: {
    type: 'category',
    data: [], // Initialize with empty data
    axisLine: { lineStyle: { color: '#A8ABB2' } },
    axisLabel: { color: '#606266' }
  },
  yAxis: {
    type: 'value',
    axisLine: { lineStyle: { color: '#A8ABB2' } },
    axisLabel: { color: '#606266' },
    splitLine: { lineStyle: { color: '#EBEEF5' } }
  },
  tooltip: {
    trigger: 'axis',
    axisPointer: { type: 'shadow' }
  },
  grid: {
    left: '3%',
    right: '4%',
    bottom: '3%',
    containLabel: true
  },
  series: [
    {
      name: '部门薪资',
      data: [], // Initialize with empty data
      type: 'bar',
      barWidth: '40%',
      itemStyle: {
        color: '#82C97B' // 辅助色-绿色
      },
      emphasis: {
        itemStyle: {
          color: '#67c23a'
        }
      }
    }
  ]
}

export default {
  name: 'Home',
  components: {
    WelcomeComponent
  },
  data() {
    return {
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
      notices: [],
      month: null,
      monthData: [],
      departmentInfo: {
        name: '',
        employeeCount: 0,
        headerName: ''
      },
      pendingTasks: {
        askCount: 0,
        resourceCount: 0
      },
      personalTasks: {
        total: 0,
        approved: 0,
        pending: 0,
        rejected: 0
      },
      departmentEmployees: [],
      // ECharts instances
      pieChart: null,
      salaryBarChart: null,
      lineChart: null,
      barChart: null
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
    this.loadNotices();
    
    if (this.user.role === 'ADMIN') {
      this.getMonthData()
      this.getFinancialPie()
      this.getFinancialLine()
      this.getFinancialBar()
    } else if (this.isHeader) {
      this.loadDepartmentInfo();
      this.loadPendingTasks();
      this.loadDepartmentEmployees();
    } else if (this.user.role === 'USER') {
      this.loadDepartmentInfo();
      this.loadPersonalTasks();
    }
  },
  methods: {
    loadNotices() {
      // 根据用户登录状态选择合适的接口
      const endpoint = this.user?.id ? '/notice/selectAll' : '/notice/public';
      this.$request.get(endpoint).then(res => {
        if (res.code === '200') {
          this.notices = res.data || [];
        } else {
          this.$message.error('获取公告列表失败: ' + res.msg);
          this.notices = [];
        }
      }).catch(error => {
        console.error('获取公告列表失败:', error);
        this.$message.error('获取公告列表时发生网络错误');
        this.notices = [];
      });
    },
    getMonthData() {
      this.$request.get('/salary/getMonth').then(res => {
        if (res.code === '200') {
          this.monthData = res.data
          this.month = this.monthData[0].year
          this.getSalaryMonth(this.month)
        } else {
          this.$message.error(res.msg)
        }
      })
    },
    getSalaryMonth(month) {
      this.$request.get('/salary/getSalary/' + month).then(res => {
        if (res.code === '200') {
          let chartDom = document.getElementById('salaryBar');
          if (this.salaryBarChart) {
            this.salaryBarChart.dispose(); // Dispose old instance if any
          }
          this.salaryBarChart = echarts.init(chartDom);
          barSalaryOptions.title.text = res.data.text
          barSalaryOptions.title.subtext = res.data.subtext
          barSalaryOptions.xAxis.data = res.data.xAxis
          barSalaryOptions.series[0].data = res.data.yAxis
          this.salaryBarChart.setOption(barSalaryOptions)
        } else {
          this.$message.error(res.msg)
        }
      })
    },
    getFinancialPie() {
      this.$request.get('/financial/getPie').then(res => {
        if (res.code === '200') {
          let chartDom = document.getElementById('pie');
          if (this.pieChart) {
            this.pieChart.dispose();
          }
          this.pieChart = echarts.init(chartDom);
          pieOptions.title.text = res.data.text
          pieOptions.title.subtext = res.data.subtext
          pieOptions.series[0].name = res.data.name
          pieOptions.series[0].data = res.data.data
          this.pieChart.setOption(pieOptions);
        } else {
          this.$message.error(res.msg)
        }
      })
    },
    getFinancialLine() {
      this.$request.get('/financial/getLine').then(res => {
        if (res.code === '200') {
          let chartDom = document.getElementById('line');
          if (this.lineChart) {
            this.lineChart.dispose();
          }
          this.lineChart = echarts.init(chartDom);
          lineOptions.title.text = res.data.text
          lineOptions.title.subtext = res.data.subtext
          lineOptions.xAxis.data = res.data.xAxis
          lineOptions.series[0].data = res.data.yAxis
          this.lineChart.setOption(lineOptions)
        } else {
          this.$message.error(res.msg)
        }
      })
    },
    getFinancialBar() {
      this.$request.get('/financial/getBar').then(res => {
        if (res.code === '200') {
          let chartDom = document.getElementById('bar');
          if (this.barChart) {
            this.barChart.dispose();
          }
          this.barChart = echarts.init(chartDom);
          barOptions.title.text = res.data.text
          barOptions.title.subtext = res.data.subtext
          barOptions.xAxis.data = res.data.xAxis
          barOptions.series[0].data = res.data.yAxis
          this.barChart.setOption(barOptions)
        }
      })
    },
    loadDepartmentInfo() {
      if (this.user.departmentId) {
        this.$request.get('/department/findById/' + this.user.departmentId).then(res => {
          if (res.code === '200') {
            this.departmentInfo.name = res.data.name;
            this.departmentInfo.headerName = res.data.headerName || '未指定';
            
            if (this.isHeader) {
              this.loadEmployeeCount();
            }
          }
        }).catch(error => {
          console.error("获取部门信息失败:", error);
          this.$message.error("获取部门信息失败，请检查网络连接");
        });
      }
    },
    loadEmployeeCount() {
      this.$request.get('/employee/count', {
        params: { departmentId: this.user.departmentId }
      }).then(res => {
        if (res.code === '200') {
          this.departmentInfo.employeeCount = res.data || 0;
        }
      }).catch(error => {
        console.error("获取员工数量失败:", error);
        this.$message.error("获取员工数量失败，请检查网络连接");
      });
    },
    loadPendingTasks() {
      this.loadPendingAskTasks();
      this.loadPendingResourceTasks();
    },
    loadPendingAskTasks() {
      this.$request.get('/askapply/countPending', {
        params: { departmentId: this.user.departmentId }
      }).then(res => {
        if (res.code === '200') {
          this.pendingTasks.askCount = res.data || 0;
        }
      }).catch(error => {
        console.error("获取待审批请假数据失败:", error);
        this.$message.error("获取待审批请假数据失败，请检查网络连接");
      });
    },
    loadPendingResourceTasks() {
      this.$request.get('/resourceapply/countPending', {
        params: { departmentId: this.user.departmentId }
      }).then(res => {
        if (res.code === '200') {
          this.pendingTasks.resourceCount = res.data || 0;
        }
      }).catch(error => {
        console.error("获取待审批资产数据失败:", error);
        this.$message.error("获取待审批资产数据失败，请检查网络连接");
      });
    },
    loadDepartmentEmployees() {
      this.$request.get('/employee/selectByDepartment', {
        params: { departmentId: this.user.departmentId }
      }).then(res => {
        if (res.code === '200') {
          this.departmentEmployees = res.data || [];
        }
      }).catch(error => {
        console.error("获取部门员工列表失败:", error);
        this.$message.error("获取部门员工列表失败，请检查网络连接");
      });
    },
    loadPersonalTasks() {
      this.$request.get('/employee/applicationStats', {
        params: { employeeId: this.user.id }
      }).then(res => {
        if (res.code === '200') {
          this.personalTasks = res.data || {
            total: 0,
            approved: 0,
            pending: 0,
            rejected: 0
          };
        }
      }).catch(error => {
        console.error("获取个人申请统计数据失败:", error);
        this.$message.error("获取个人申请统计数据失败，请检查网络连接");
      });
    },
    goToEmployeeList() {
      this.$router.push('/user');
    }
  },
  mounted() {
    // Add resize listener only if charts are expected to be initialized (ADMIN role)
    if (this.user.role === 'ADMIN') {
      window.addEventListener('resize', this.handleChartResize);
    }
  },
  beforeDestroy() {
    // Remove resize listener
    if (this.user.role === 'ADMIN') {
      window.removeEventListener('resize', this.handleChartResize);
    }
    // Dispose ECharts instances
    this.pieChart && this.pieChart.dispose();
    this.salaryBarChart && this.salaryBarChart.dispose();
    this.lineChart && this.lineChart.dispose();
    this.barChart && this.barChart.dispose();
  },
  // Add the handleChartResize method
  handleChartResize() {
    this.pieChart && this.pieChart.resize();
    this.salaryBarChart && this.salaryBarChart.resize();
    this.lineChart && this.lineChart.resize();
    this.barChart && this.barChart.resize();
  }
}
</script>

<style scoped>
.dashboard-header .el-col,
.dashboard-employee .el-col,
.card + div .el-col {
  margin-bottom: 20px;
}

.dashboard-item {
  text-align: center;
}

.dashboard-num {
  font-size: 24px;
  font-weight: bold;
  color: #303133;
}

.dashboard-title {
  font-size: 14px;
  color: #606266;
  margin-top: 5px;
}

.dashboard-detail {
  margin-top: 10px;
}

/* Responsive adjustments for smaller screens */
@media (max-width: 768px) {
  .el-row {
    margin-left: -10px !important;
    margin-right: -10px !important;
  }
  .el-col,
  .el-col-8 {
    width: 100% !important; /* Make columns full width */
    padding-left: 10px !important;
    padding-right: 10px !important;
    margin-bottom: 15px;
  }

  .dashboard-header .el-card,
  .dashboard-employee .el-card,
  .card,
  div[style*="display: flex"] > .card {
    margin-bottom: 15px !important;
  }

  div[style*="display: flex"] {
    flex-direction: column;
  }

  div[id^="pie"],
  div[id^="salaryBar"],
  div[id^="line"],
  div[id^="bar"] {
    height: 300px !important; /* Adjust chart height */
    flex: none !important;
    width: 100% !important;
  }

  .el-select {
    width: 100% !important;
  }

  .el-table {
    font-size: 12px; /* Reduce table font size */
  }

  .el-table th,
  .el-table td {
    padding: 6px 0; /* Reduce padding in table cells */
  }

  .el-timeline-item__timestamp {
    font-size: 12px;
  }

  .el-popover span[slot="reference"] {
    font-size: 13px;
  }

  .welcome-card .user-info h2 {
    font-size: 1.2em;
  }
  .welcome-card .user-info p {
    font-size: 0.9em;
  }
}

/* Styles from the second scoped style block, now merged */
.card {
  background-color: white;
  border-radius: 5px;
  padding: 15px;
  margin: 5px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}
/* .dashboard-item, .dashboard-num, .dashboard-title, .dashboard-detail */
/* were already defined above or are similar to existing, review if specific merge needed */
/* Re-defining .dashboard-item and its children as per the second block for clarity and potential override */
.dashboard-item {
  text-align: center;
  padding: 10px 0; /* This was missing in the first block's .dashboard-item */
}
.dashboard-num {
  font-size: 28px; /* Overrides 24px from first block if this takes precedence */
  font-weight: bold;
  color: #409EFF; /* Changed from #303133 */
  margin-bottom: 10px; /* Added */
}
.dashboard-title {
  font-size: 14px;
  color: #606266;
  margin-bottom: 10px; /* Added, was margin-top: 5px in first block */
}
.dashboard-detail {
  margin-top: 10px;
}
</style>
