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
      objectId: Bmob.User.current().objectId,
      userName: Bmob.User.current().username,
      mobilePhoneNumber: Bmob.User.current().mobilePhoneNumber,
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