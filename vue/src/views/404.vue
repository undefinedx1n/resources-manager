<template>
  <div>
    <div class="error-page-container" style="height: 100vh; overflow: hidden; display: flex; align-items: center; justify-content: center">
      <div class="error-page-message" style="font-size: 40px">404 找不到页面 <router-link to="/">返回首页</router-link></div>
    </div>

  </div>
</template>

<script>
export default {
  name: "404",
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
  .error-page-container {
    padding: 20px; /* Add some padding */
    box-sizing: border-box;
  }
  .error-page-message {
    font-size: 24px !important; /* Reduce font size */
    text-align: center; /* Center text */
  }
  .error-page-message a {
    display: block; /* Make link a block element */
    margin-top: 15px; /* Add space above link */
    font-size: 18px; /* Adjust link font size */
  }
}
</style>