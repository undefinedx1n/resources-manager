<template>
  <div>
    <el-card style="width: 50%">
      <el-form :model="user" label-width="100px" style="padding-right: 50px">
        <div style="margin: 15px; text-align: center">
          <el-upload
              class="avatar-uploader"
              :action="$baseUrl + '/files/upload'"
              :show-file-list="false"
              :on-success="handleAvatarSuccess"
          >
            <img v-if="user.avatar" :src="user.avatar" class="avatar" />
            <i v-else class="el-icon-plus avatar-uploader-icon"></i>
          </el-upload>
        </div>
        <el-form-item label="用户名" prop="username">
          <el-input v-model="user.username" placeholder="用户名" disabled></el-input>
        </el-form-item>
        <el-form-item label="姓名" prop="name">
          <el-input v-model="user.name" placeholder="姓名"></el-input>
        </el-form-item>
        <el-form-item label="电话" prop="phone">
          <el-input v-model="user.phone" placeholder="电话"></el-input>
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="user.email" placeholder="邮箱"></el-input>
        </el-form-item>
        <el-form-item label="所属部门" prop="departmentName">
          <el-input v-model="user.departmentName" placeholder="所属部门" disabled></el-input>
        </el-form-item>
        <el-form-item label="部门主管" prop="departmentHeaderName">
          <el-input v-model="user.departmentHeaderName" placeholder="部门主管" disabled></el-input>
        </el-form-item>
        <div style="text-align: center; margin-bottom: 20px">
          <el-button type="primary" @click="update">保 存</el-button>
        </div>
      </el-form>
    </el-card>
  </div>
</template>

<script>
export default {
  name: "EmployeePerson",
  data() {
    return {
      user: JSON.parse(localStorage.getItem('xm-user') || '{}')
    }
  },
  created() {

  },
  methods: {
    update() {
      // 保存当前的用户信息到数据库
      this.$request.put('/employee/update', this.user).then(res => {
        if (res.code === '200') {
          // 成功更新
          this.$message.success('保存成功')

          // 更新浏览器缓存里的用户信息
          localStorage.setItem('xm-user', JSON.stringify(this.user))

          // 触发父级的数据更新
          this.$emit('update:user')
        } else {
          this.$message.error(res.msg)
        }
      })
    },
    handleAvatarSuccess(response, file, fileList) {
      // 把user的头像属性换成上传的图片的链接
      this.$set(this.user, 'avatar', response.data)
    },
  }
}
</script>

<style scoped>
/deep/.el-form-item__label {
  font-weight: bold;
}
/deep/.el-upload {
  border-radius: 50%;
}
/deep/.avatar-uploader .el-upload {
  border: 1px dashed #d9d9d9;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  border-radius: 50%;
}
/deep/.avatar-uploader .el-upload:hover {
  border-color: #409EFF;
}
.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 120px;
  height: 120px;
  line-height: 120px;
  text-align: center;
  border-radius: 50%;
}
.avatar {
  width: 120px;
  height: 120px;
  display: block;
  border-radius: 50%;
}

@media screen and (max-width: 768px) {
  .el-card {
    width: 100% !important; /* 卡片宽度占满 */
    border: none !important; /* 可以考虑移除边框，使其更融入页面 */
    box-shadow: none !important; /* 可以考虑移除阴影 */
  }

  /* 调整el-form的内边距，使其在卡片占满宽度时不会紧贴边缘 */
  .el-form {
    padding-right: 15px !important; 
    padding-left: 15px; /* 如果label-width是100px，左侧可能需要调整或全局form item样式已处理 */
  }

  /* 调整头像上传区域大小 */
  .avatar-uploader-icon {
    width: 100px;
    height: 100px;
    line-height: 100px;
    font-size: 24px;
  }
  .avatar {
    width: 100px;
    height: 100px;
  }

  /* 保存按钮 */
  .el-form > div:last-of-type .el-button {
     /* Assuming the save button is in the last div container inside the form */
    width: 100%;
    margin-top: 10px; /* Add some space above the button */
  }
  
  /* el-form-item 的标签和输入框布局应由 Admin.vue 中的全局样式覆盖 */
  /* 例如：标签置顶，输入框宽度100% */
}
</style>