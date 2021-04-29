<template>
  <van-list v-model="loading" :finished="finished" :finished-text="tip" @load="onLoad">
    <van-cell-group class="av" center v-for="item in list" :key="item.objectId" :id="item.path">
      <a :href="item.path" target="_blank">
        <van-cell :icon="item.image" :title="item.title" />
      </a>
    </van-cell-group>
  </van-list>
</template> 

<script>
export default {
  data() {
    return {
      list: [],
      loading: false,
      finished: false,
      tip: '没有更多了',
    }
  },
  methods: {
    onLoad() {
      const query = Bmob.Query('NewsBean')
      query.equalTo('user', '==', sessionStorage.getItem('objectId'))
      query.find().then((res) => {
        this.list = res
        this.loading = false
        this.finished = true
      })
      setTimeout(() => {
        this.loading = false
        this.finished = true
      }, 1000)
    },
  },
}
</script>