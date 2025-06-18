<el-dropdown>
  <span class="el-dropdown-link">
    {{ user.name }}
    <el-tag size="mini" v-if="user.level === 'HEADER'" type="success" style="margin-left: 5px">部门主管</el-tag>
    <el-tag size="mini" v-else-if="user.level === 'EMPLOYEE'" type="info" style="margin-left: 5px">普通员工</el-tag>
    <i class="el-icon-arrow-down el-icon--right"></i>
  </span>
</el-dropdown> 