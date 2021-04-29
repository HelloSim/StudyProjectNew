<template>
  <van-pull-refresh v-model="refreshing" @refresh="onRefresh">
    <van-list v-model="loading" :finished="finished" finished-text="没有更多了" @load="onLoad">
      <van-cell-group class="av" center v-for="item in list" :key="item.objectId" :id="item.path">
        <a :href="item.path" target="_blank">
          <van-cell :icon="item.image" :title="item.title" />
        </a>
      </van-cell-group>
    </van-list>
  </van-pull-refresh>
</template>

<script>
export default {
  data() {
    return {
      list: [],
      loading: false,
      finished: false,
      refreshing: false,
      page: 0,
    }
  },
  methods: {
    onLoad() {
      this.page++
      setTimeout(() => {
        if (this.refreshing) {
          this.list = []
          this.refreshing = false
          this.page = 0
        }
        this.axios
          .get(
            `https://api.apiopen.top/getWangYiNews?page=${this.page}&count=20`
          )
          .then((res) => {
            // 加载状态结束
            this.list = this.list.concat(res.data.result) //追加数据
          })
          .catch((error) => {
            console.log(error)
          })
          .finally(() => (this.loading = false))
      }, 1000)
    },
    onRefresh() {
      // 清空列表数据
      this.finished = false

      // 重新加载数据
      // 将 loading 设置为 true，表示处于加载状态
      this.loading = true
      this.onLoad()
    },
  },
}
</script>