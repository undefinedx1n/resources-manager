<template>
  <div>
    <el-card>
      <welcome-component></welcome-component>
    </el-card>
  </div>
</template>

<script>
import WelcomeComponent from "@/components/Welcome.vue";

export default {
  name: "Home",
  components: {
    WelcomeComponent
  }
}
</script>

<style scoped>
@media screen and (max-width: 768px) {
  :deep(.el-card__body) {
    padding: 10px !important; /* 减小卡片内边距 */
  }
  .el-card {
    border: none !important; /* 移除边框 */
    box-shadow: none !important; /* 移除阴影 */
  }
}
</style> 