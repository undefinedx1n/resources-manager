<template>
  <div>
    <div class="auth-container" style="height: calc(100vh - 80px); overflow: hidden; display: flex; align-items: center; justify-content: center">
      <div class="auth-message" style="font-size: 40px">无权访问 <router-link to="/">返回首页</router-link></div>
    </div>
  </div>
</template>

<script>
export default {
  name: "Auth",
  data() {
    return {}
  },
  created() {

  },
  methods: {}
}
</script>

<style scoped>
@media screen and (max-width: 768px) {
  .auth-container {
    height: calc(100vh - 60px) !important; /* Adjust height if header is 60px on mobile */
    padding: 20px;
    box-sizing: border-box;
  }
  .auth-message {
    font-size: 24px !important; /* Reduce font size */
    text-align: center; /* Center text */
  }
  .auth-message a {
    display: block; /* Make link a block element */
    margin-top: 15px; /* Add space above link */
    font-size: 18px; /* Adjust link font size if needed */
  }
}
</style>