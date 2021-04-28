<template>
  <van-tabbar v-show="show" v-model="active">
    <van-tabbar-item icon="wap-home-o" to="/home">{{title[0]}}</van-tabbar-item>
    <van-tabbar-item icon="logistics" to="/bus">{{title[1]}}</van-tabbar-item>
    <van-tabbar-item icon="certificate" to="/record">{{title[2]}}</van-tabbar-item>
    <van-tabbar-item icon="user-o" to="/user">{{title[3]}}</van-tabbar-item>
  </van-tabbar>
</template>
<script>
export default {
  data() {
    return {
      show: true,
      active: 0,
      title: ['首页', '出行', '打卡', '用户'],
    }
  },
  watch: {
    $route(to, from) {
      if (
        to.name == 'home' ||
        to.name == 'bus' ||
        to.name == 'record' ||
        to.name == 'user'
      ) {
        this.show = true
      } else {
        this.show = false
      }
    },
  },
}
</script>