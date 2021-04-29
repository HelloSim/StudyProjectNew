<template>
  <div>
    <van-calendar class="calendar" :show-title="false" :show-subtitle="false" :poppable="false" color="#66B1F4"
      :first-day-of-week="0" :show-confirm="false" confirm-text="打卡" :formatter="formatter" :select="select" />
    <van-button class="btn" round block type="info" native-type="submit" :disabled="showBtn">{{btnText}}</van-button>
  </div>
</template>

<script>
export default {
  data() {
    return {
      today: new Date(),
      btnText: '打卡',
      showBtn: true,
    }
  },
  methods: {
    formatter(day) {
      const year = day.date.getFullYear()
      const month = day.date.getMonth() + 1
      const date = day.date.getDate()
      return day
    },
    select(day) {
      console.log(1)
    },
  },
}
</script>

<style scoped>
.calendar {
  background: rgb(230, 226, 226);
  height: 450px;
}
.btn {
  margin-top: 10px;
}
</style>