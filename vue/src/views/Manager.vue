<template>
  <div class="manager-container">
    <!--  头部  -->
    <div class="manager-header">
      <div class="manager-header-left">
        <div class="hamburger-menu" @click="toggleSideMenu">
          <i class="el-icon-menu"></i>
        </div>
        <img src="@/assets/imgs/logo.png" />
        <div class="title">企业微人事管理系统</div>
      </div>

      <div class="manager-header-center">
        <el-breadcrumb separator-class="el-icon-arrow-right">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item :to="{ path: $route.path }">{{ $route.meta.name }}</el-breadcrumb-item>
        </el-breadcrumb>
      </div>

      <div class="manager-header-right">
        <el-dropdown placement="bottom">
          <div class="avatar">
            <img :src="user.avatar || 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'" />
            <div>
              {{ user.name || '' }}
              <el-tag size="mini" v-if="isHeader" type="success">主管</el-tag>
              <el-tag size="mini" v-else-if="user.role === 'USER'" type="info">员工</el-tag>
              <el-tag size="mini" v-else-if="user.role === 'ADMIN'" type="danger">管理员</el-tag>
            </div>
          </div>
          <el-dropdown-menu slot="dropdown">
            <el-dropdown-item @click.native="goToPerson">个人信息</el-dropdown-item>
            <el-dropdown-item @click.native="$router.push('/password')">修改密码</el-dropdown-item>
            <el-dropdown-item @click.native="logout">退出登录</el-dropdown-item>
          </el-dropdown-menu>
        </el-dropdown>
      </div>
    </div>

    <!--  主体  -->
    <div class="manager-main">
      <!--  侧边栏  -->
      <div class="manager-main-left" :class="{ 'mobile-menu-active': isSideMenuVisible }">
        <el-menu :default-openeds="['info', 'matters', 'user']" router style="border: none" :default-active="$route.path" @select="handleMenuSelect">
          <el-menu-item index="/home">
            <i class="el-icon-s-home"></i>
            <span slot="title">系统首页</span>
          </el-menu-item>
          <el-submenu index="info" v-if="user.role === 'ADMIN'">
            <template slot="title">
              <i class="el-icon-menu"></i><span>信息管理</span>
            </template>
            <el-menu-item index="/notice">公告信息</el-menu-item>
            <el-menu-item index="/department">部门信息</el-menu-item>
          </el-submenu>
          <el-submenu index="matters">
            <template slot="title">
              <i class="el-icon-menu"></i><span>人事管理</span>
            </template>
            <el-menu-item index="/salary">薪资信息</el-menu-item>
            <el-menu-item index="/financial" v-if="user.role === 'ADMIN'">财务支出</el-menu-item>
            <el-menu-item v-if="user.role === 'USER'" index="/askRecord">请假记录</el-menu-item>
            <el-menu-item v-if="user.role === 'ADMIN' || isHeader" index="/askApply">
              部门请假审批
              <el-tag size="mini" type="warning" v-if="isHeader">主管权限</el-tag>
            </el-menu-item>
            <el-menu-item index="/resources">资产信息</el-menu-item>
            <el-menu-item v-if="user.role === 'ADMIN' || isHeader" index="/resourcesApply">
              部门资产审批
              <el-tag size="mini" type="warning" v-if="isHeader">主管权限</el-tag>
            </el-menu-item>
            <el-menu-item v-if="user.role === 'USER'" index="/resourcesMy">员工资产</el-menu-item>
          </el-submenu>
          <el-submenu index="user" v-if="user.role === 'ADMIN' || isHeader">
            <template slot="title">
              <i class="el-icon-menu"></i><span>用户管理</span>
            </template>
            <el-menu-item index="/admin" v-if="user.role === 'ADMIN'">管理员信息</el-menu-item>
            <el-menu-item index="/user">
              员工信息
              <el-tag size="mini" type="warning" v-if="isHeader">主管权限</el-tag>
            </el-menu-item>
            
          </el-submenu>
        </el-menu>
        
      </div>

      <!--  遮罩层  -->
      <div class="page-overlay" v-if="isSideMenuVisible" @click="closeSideMenu"></div>

      <!--  数据表格  -->
      <div class="manager-main-right">
        <router-view @update:user="updateUser" />
      </div>
    </div>

  </div>
</template>

<script>
export default {
  name: "Manager",
  data() {
    return {
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
      isSideMenuVisible: false, // 控制移动端侧边栏的显示状态
    }
  },
  computed: {
    isHeader() {
      return this.user.level === 'HEADER' || 
             (this.user.level && this.user.level.includes('主管'));
    }
  },
  created() {
    if (!this.user.id) {
      this.$router.push('/login')
    }
    console.log('当前用户信息:', this.user)
  },
  methods: {
    toggleSideMenu() {
      this.isSideMenuVisible = !this.isSideMenuVisible;
    },
    closeSideMenu() { // Method to explicitly close the side menu
      this.isSideMenuVisible = false;
    },
    handleMenuSelect() {
      if (window.innerWidth <= 768) {
        this.closeSideMenu(); // Reuse closeSideMenu
      }
    },
    updateUser() {
      this.user = JSON.parse(localStorage.getItem('xm-user') || '{}')   // 重新获取下用户的最新信息
    },
    goToPerson() {
      if (this.user.role === 'ADMIN') {
        this.$router.push('/adminPerson')
      }
      if (this.user.role === 'USER') {
        this.$router.push('/employeePerson')
      }
    },
    logout() {
      localStorage.removeItem('xm-user')
      this.$router.push('/login')
    }
  }
}
</script>

<style scoped>
@import "@/assets/css/manager.css";

/* 仅针对此组件的汉堡按钮等移动端微调样式，主要样式在 manager.css 中定义 */
.hamburger-menu {
  display: none; /* 默认隐藏，通过 manager.css 中的媒体查询显示 */
  font-size: 24px;
  padding: 0 15px;
  cursor: pointer;
}

/* Scoped styles for overlay can be minimal if global styles in manager.css handle it */
/* .page-overlay {}
*/
</style>