<template>
  <div class="welcome-container">
    <div class="welcome-header">
      <h1>欢迎使用企业微人事管理系统</h1>
      <p class="welcome-time">{{ currentTime }}</p>
    </div>
    
    <!-- 主管欢迎信息 -->
    <div v-if="isHeader" class="role-welcome">
      <el-card shadow="hover" class="role-card">
        <div slot="header" class="role-header">
          <i class="el-icon-s-custom"></i> 部门主管工作台
        </div>
        <div class="role-content">
          <p>尊敬的 <b>{{ user.name }}</b> 主管，您好！</p>
          <p>您现在管理的是 <b>{{ displayDepartmentName }}</b> 部门，共有员工 {{ employeeCount }} 人。</p>
          <p>您的主要职责：</p>
          <ul>
            <li>审批本部门员工的请假申请</li>
            <li>审批本部门员工的资产申请</li>
            <li>管理和监督本部门的员工</li>
          </ul>
          <div class="role-actions">
            <el-button type="primary" @click="goToPage('/askApply')">部门请假审批</el-button>
            <el-button type="success" @click="goToPage('/resourcesApply')">部门资产审批</el-button>
            <el-button type="info" @click="goToPage('/user')">员工管理</el-button>
          </div>
        </div>
      </el-card>
    </div>
    
    <!-- 普通员工欢迎信息 -->
    <div v-else-if="user.role === 'USER'" class="role-welcome">
      <el-card shadow="hover" class="role-card">
        <div slot="header" class="role-header">
          <i class="el-icon-user"></i> 员工工作台
        </div>
        <div class="role-content">
          <p>尊敬的 <b>{{ user.name }}</b>，您好！</p>
          <p>您属于 <b>{{ displayDepartmentName }}</b> 部门，您的部门主管是 <b>{{ displayDepartmentHeader }}</b>。</p>
          <p>您可以进行的主要操作：</p>
          <ul>
            <li>查看个人薪资和考勤信息</li>
            <li>提交请假申请</li>
            <li>申请使用公司资产</li>
          </ul>
          <div class="role-actions">
            <el-button type="primary" @click="goToPage('/askRecord')">请假申请</el-button>
            <el-button type="success" @click="goToPage('/resources')">资产申请</el-button>
            <el-button type="info" @click="goToPage('/salary')">薪资信息</el-button>
          </div>
        </div>
      </el-card>
    </div>
    
    <!-- 管理员欢迎信息 -->
    <div v-else-if="user.role === 'ADMIN'" class="role-welcome">
      <el-card shadow="hover" class="role-card">
        <div slot="header" class="role-header">
          <i class="el-icon-s-tools"></i> 系统管理员工作台
        </div>
        <div class="role-content">
          <p>尊敬的 <b>{{ user.name }}</b> 管理员，您好！</p>
          <p>您拥有系统的全部管理权限。</p>
          <p>您的主要职责：</p>
          <ul>
            <li>管理公司部门和员工信息</li>
            <li>最终审批员工的请假和资产申请</li>
            <li>管理系统资源和权限</li>
          </ul>
          <div class="role-actions">
            <el-button type="primary" @click="goToPage('/department')">部门管理</el-button>
            <el-button type="success" @click="goToPage('/user')">员工管理</el-button>
            <el-button type="warning" @click="goToPage('/askApply')">请假审批</el-button>
            <el-button type="info" @click="goToPage('/resourcesApply')">资产审批</el-button>
          </div>
        </div>
      </el-card>
    </div>
  </div>
</template>

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
  data() {
    return {
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
      currentTime: new Date().toLocaleString(),
      employeeCount: 0,
      departmentInfo: {
        name: this.departmentName || '',
        headerName: this.departmentHeader || '未指定'
      }
    }
  },
  computed: {
    isHeader() {
      return this.user.level === 'HEADER' || 
             this.user.role === 'HEADER' || 
             (this.user.level && this.user.level.includes('主管'));
    },
    displayDepartmentName() {
      return this.departmentInfo.name || this.departmentName || this.user.departmentName || '未分配部门';
    },
    displayDepartmentHeader() {
      return this.departmentInfo.headerName || this.departmentHeader || '未指定';
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
    },
    departmentHeader: {
      handler(newVal) {
        if (newVal) {
          this.departmentInfo.headerName = newVal;
        }
      },
      immediate: true
    }
  },
  created() {
    this.updateTime();
    setInterval(this.updateTime, 1000);
    if (!this.departmentName || !this.departmentHeader) {
      this.loadDepartmentInfo();
    }
  },
  methods: {
    updateTime() {
      this.currentTime = new Date().toLocaleString();
    },
    goToPage(path) {
      this.$router.push(path);
    },
    loadDepartmentInfo() {
      if (this.user.departmentId) {
        this.$request.get('/department/findById/' + this.user.departmentId).then(res => {
          if (res.code === '200' && res.data) {
            // 更新部门名称
            this.departmentInfo.name = res.data.name;
            
            // 获取部门主管信息
            if (res.data.employeeId) {
              this.$request.get('/employee/selectById/' + res.data.employeeId).then(empRes => {
                if (empRes.code === '200' && empRes.data) {
                  this.departmentInfo.headerName = empRes.data.name;
                }
              }).catch(() => {
                this.findDepartmentManager();
              });
            } else {
              this.findDepartmentManager();
            }

            // 如果是主管，获取部门员工数量
            if (this.isHeader) {
              this.loadEmployeeCount();
            }
          }
        }).catch(error => {
          console.error("获取部门信息失败:", error);
          // 如果获取部门信息失败，尝试从员工中查找主管
          this.findDepartmentManager();
        });
      }
    },
    findDepartmentManager() {
      if (this.user.departmentId) {
        this.$request.get('/employee/selectByDepartment', {
          params: { departmentId: this.user.departmentId }
        }).then(res => {
          if (res.code === '200' && res.data && res.data.length > 0) {
            const manager = res.data.find(emp => 
              emp.level === '主管' || emp.level === 'HEADER' || 
              (emp.level && emp.level.includes('主管'))
            );
            if (manager) {
              this.departmentInfo.headerName = manager.name;
            }
          }
        }).catch(error => {
          console.error("查找部门主管失败:", error);
        });
      }
    },
    loadEmployeeCount() {
      this.$request.get('/employee/count', {
        params: { departmentId: this.user.departmentId }
      }).then(res => {
        if (res.code === '200') {
          this.employeeCount = res.data || 0;
        }
      }).catch(error => {
        console.error("获取员工数量失败:", error);
      });
    }
  }
}
</script>

<style scoped>
.welcome-container {
  padding: 20px;
}
.welcome-header {
  text-align: center;
  margin-bottom: 30px;
}
.welcome-time {
  color: #666;
  font-size: 16px;
}
.role-welcome {
  max-width: 800px;
  margin: 0 auto;
}
.role-card {
  border-radius: 6px;
}
.role-header {
  font-weight: bold;
  font-size: 18px;
}
.role-content {
  padding: 10px 0;
}
.role-content ul {
  margin: 15px 0;
  padding-left: 20px;
}
.role-content li {
  line-height: 24px;
  margin-bottom: 8px;
}
.role-actions {
  margin-top: 20px;
  display: flex;
  justify-content: center;
  flex-wrap: wrap;
}
.role-actions .el-button {
  margin: 5px 10px;
}

@media screen and (max-width: 768px) {
  .welcome-container {
    padding: 10px;
  }
  .welcome-header h1 {
    font-size: 22px;
    margin-bottom: 8px;
  }
  .welcome-header .welcome-time {
    font-size: 14px;
  }
  .welcome-header {
    margin-bottom: 20px;
  }

  .role-welcome {
    max-width: 100%;
  }

  .role-header {
    font-size: 16px;
  }
  :deep(.role-card .el-card__header) {
    padding: 10px 15px;
  }

  .role-content p,
  .role-content li {
    font-size: 14px;
    line-height: 1.6;
  }
  .role-content ul {
    padding-left: 15px;
    margin: 10px 0;
  }
  .role-content li {
    margin-bottom: 6px;
  }

  .role-actions {
    margin-top: 15px;
  }
  .role-actions .el-button {
    width: calc(100% - 10px);
    margin: 8px 5px !important;
    box-sizing: border-box;
  }
}
</style> 