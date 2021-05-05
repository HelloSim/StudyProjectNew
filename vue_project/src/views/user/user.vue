<template>
  <div>
    <van-cell-group title="用户">
      <van-cell v-if="!isLogin" center icon="user-o" title="未登录" @click="showPopup" />
      <van-cell v-else center icon="user-o" :title="userName" to="/user/userInfo" />
      <van-cell v-if="isLogin" center icon="label-o" title="收藏" to="/user/userCollected" />
    </van-cell-group>
    <van-cell-group title="设置">
      <van-cell center icon="setting-o" title="设置" />
    </van-cell-group>
    <van-popup v-model="showLogin" :round="true">
      <van-form @submit="onSubmit">
        <van-field v-model="userName" name="userName" label="用户名" placeholder="用户名"
          :rules="[{ required: true, message: '请填写用户名' }]" />
        <van-field v-model="password" type="password" name="password" label="密码" placeholder="密码"
          :rules="[{ required: true, message: '请填写密码' }]" />
        <div style="margin: 16px">
          <van-button round block type="info" native-type="submit">登录</van-button>
        </div>
      </van-form>
    </van-popup>
  </div>
</template>

<script>
export default {
  data() {
    return {
      isLogin: Bmob.User.current() == null ? false : true,
      showLogin: false,
      userName: Bmob.User.current() == null ? '' : Bmob.User.current().username,
      password: '',
    }
  },
  methods: {
    showPopup() {
      this.showLogin = true
    },
    onSubmit(values) {
      this.showLogin = false
      Bmob.User.login(values.userName, values.password)
        .then((res) => {
          this.isLogin = true
          this.userName = Bmob.User.current().username
        })
        .catch((err) => {
          this.$toast({
            message: err.error,
          })
        })
    },
  },
}
</script>

<style>
.van-cell {
  width: 100%;
  height: 60px;
  margin-left: 20px;
}
.van-popup {
  width: 100%;
  height: 200px;
  align-items: center;
}
</style>