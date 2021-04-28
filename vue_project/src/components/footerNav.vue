<template>
  <van-tabbar v-model="active">
    <van-tabbar-item icon="wap-home-o" to="/home">{{title[0]}}</van-tabbar-item>
    <van-tabbar-item icon="logistics" to="/bus">{{title[1]}}</van-tabbar-item>
    <van-tabbar-item icon="certificate" to="/record">{{title[2]}}</van-tabbar-item>
  </van-tabbar>
</template>
<script>
export default {
  data() {
    return {
      active: 0,
      title: ['首页', '出行', '打卡'],
    }
  },
  computed: {},
  watch: {
    active(val, oldVal) {
      this.$emit('getTitle', this.title[val])
    },
  },
}
</script>