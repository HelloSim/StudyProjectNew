<template>
  <div id="app">
    <van-sticky>
      <headerTitle></headerTitle>
    </van-sticky>
    <router-view></router-view>
    <footerNav></footerNav>
  </div>
</template>

<script>
import FooterNav from './components/footerNav.vue'
import HeaderTitle from './components/headerTitle.vue'
//设置根元素字体大小
document.documentElement.style.fontSize =
  document.documentElement.clientWidth / 10 + 'px'
//监听屏幕尺寸的变化
console.log(document.documentElement.style.fontSize)

window.addEventListener('resize', () => {
  document.documentElement.style.fontSize =
    document.documentElement.clientWidth / 10 + 'px'
  console.log(document.documentElement.clientWidth / 10 + 'px')
})

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
@media only screen and (min-width: 1024px) {
  app {
    display: none;
  }
}
</style>