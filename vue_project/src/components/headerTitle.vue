<template>
  <div class="bg">
    <van-icon v-if="showBack" name="arrow-left"></van-icon>
    <van-icon v-else name="apps-o" @click="drawer = true"></van-icon>
    <p>{{ title }}</p>
    <el-drawer
      class="drawer"
      :visible.sync="drawer"
      :direction="direction"
      :show-close="false"
      :size="200"
    ></el-drawer>
  </div>
</template>

<script>
export default {
  data() {
    return {
      showBack: false,
      drawer: false,
      direction: 'ltr',
    }
  },
  props: ['title'],
}
</script>

<style>
.bg {
  width: 100%;
  height: 50px;
  background: #66b1f4;
  color: #fff;
  font-size: 20px;
  display: flex;
  align-items: center;
  /* justify-content: center; */
  text-indent: 1em;
}
.drawer {
}
</style>