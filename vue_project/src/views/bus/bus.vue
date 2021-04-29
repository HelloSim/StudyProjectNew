<template>
  <div>
    <van-swipe :autoplay="3000">
      <van-swipe-item v-for="(image, index) in images" :key="index">
        <img class="img" v-lazy="image" />
      </van-swipe-item>
    </van-swipe>

    <van-tabs v-model="show">
      <van-tab title="实时公交" disabled>
        <van-search v-model="bus" placeholder="请输入公交线路" />
      </van-tab>

      <van-tab title="出行路线">
        <van-form @submit="onSubmit">
          <van-field v-model="start" name="start" label="起点" placeholder="起点" />
          <van-field v-model="end" name="end" label="终点" placeholder="终点" />
          <div style="margin: 16px;">
            <van-button round block type="info" native-type="submit">换乘方案</van-button>
          </div>
        </van-form>
      </van-tab>

      <van-tab title="站点查询" disabled>
        <van-search v-model="site" placeholder="请输入站点名称" />
      </van-tab>
    </van-tabs>
  </div>
</template>

<script>
export default {
  data() {
    return {
      images: [
        '//fall.qiyutianxia.com/./images/2019-03-08/5c823ff37470c7.13157357.jpg',
        '//fall.qiyutianxia.com/./images/2019-04-25/5cc1829f6b93a9.49257255.jpg',
        '//fall.qiyutianxia.com/./images/2019-03-07/5c80dc941ec429.98205740.jpg',
        '//fall.qiyutianxia.com/./images/2019-02-18/5c6a8082ddebd3.55263298.jpg',
        '//fall.qiyutianxia.com/./images/2019-03-08/5c823ff37470c7.13157357.jpg',
      ],
      show: 1, //默认显示
      bus: '', //公交路线
      start: '', //起点
      end: '', //终点
      site: '', //站点
    }
  },
  methods: {
    onSubmit(values) {
      console.log('submit', values)
    },
  },
}
</script>

<style>
.img {
  width: 100%;
  height: 150px;
}
</style>