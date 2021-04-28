<template>
  <div id="app">
    <headerTitle :title="title"></headerTitle>
    <router-view></router-view>
    <footerNav @getTitle="getTitle"></footerNav>
  </div>
</template>

<script>
import footerNav from './components/footerNav.vue'
import headerTitle from './components/headerTitle.vue'
export default {
  data() {
    return {
      drawer: false,
      direction: 'ltr',
      title: '首页',
    }
  },
  methods: {
    handleClose(done) {
      done()
    },
    getTitle: function (data) {
      this.title = data
    },
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
