<template>
  <div class="bg">
    <van-icon v-if="showBack" name="arrow-left" v-on:click="back"></van-icon>
    <p>{{ title }}</p>
  </div>
</template>

<script>
export default {
  data() {
    return {
      title: 'home',
      showBack: false,
    }
  },
  methods: {
    back: function (event) {
      this.$router.go(-1)
    },
  },
  watch: {
    $route(to, from) {
      this.title = to.name
      if (
        to.name == 'home' ||
        to.name == 'bus' ||
        to.name == 'record' ||
        to.name == 'user'
      ) {
        this.showBack = false
      } else {
        this.showBack = true
      }
    },
  },
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
</style>