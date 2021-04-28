<template>
  <div id="app">
    <headerTitle></headerTitle>
    <router-view></router-view>
    <footerNav></footerNav>
  </div>
</template>

<script>
import footerNav from './components/footerNav.vue'
import headerTitle from './components/headerTitle.vue'
export default {
  data() {
    return {}
  },
  components: {
    footerNav,
    headerTitle,
  },
}
</script>

<style>
body {
  margin: 0;
  padding: 0;
}
.container {
  display: inline;
}
</style>
