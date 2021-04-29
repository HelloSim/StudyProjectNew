<template>
  <div id="app">
    <headerTitle></headerTitle>
    <router-view></router-view>
    <footerNav></footerNav>
  </div>
</template>

<script>
import FooterNav from './components/footerNav.vue'
import HeaderTitle from './components/headerTitle.vue'
export default {
  data() {
    return {}
  },
  components: {
    FooterNav,
    HeaderTitle,
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
