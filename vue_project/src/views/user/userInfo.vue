<template>
  <div>
    <van-form>
      <div class="margin">name:{{userName}}</div>
      <van-divider />
      <div class="margin">mobilePhoneNumber:{{mobilePhoneNumber}}</div>
      <van-divider />
      <van-button round block type="info" @click="showDialog">退出登录</van-button>
    </van-form>
  </div>
</template>

<script>
export default {
  data() {
    return {
      objectId: sessionStorage.getItem('objectId'),
      userName: sessionStorage.getItem('userName'),
      mobilePhoneNumber: sessionStorage.getItem('mobilePhoneNumber'),
    }
  },
  methods: {
    showDialog() {
      this.$dialog
        .confirm({
          message: '确认退出？',
        })
        .then(() => {
          Bmob.User.logout()
          sessionStorage.removeItem('objectId')
          sessionStorage.removeItem('sessionToken')
          sessionStorage.removeItem('userName')
          sessionStorage.removeItem('mobilePhoneNumber')
          this.$router.back(-1)
        })
        .catch(() => {})
    },
  },
}
</script>

<style>
.margin {
  margin: 10px;
}
</style>