<template>
  <div>
    <van-calendar class="calendar" :value="date" :poppable="false" color="#66B1F4" :first-day-of-week="0"
      :min-date="mindate" :show-title="false" :show-subtitle="false" :show-confirm="false" :formatter="formatter"
      @select="select" />
    <van-button class="btn" type="primary" round block :disabled="disabledBtn" @click='submit'>
      {{btnText}}
    </van-button>
  </div>
</template>

<script>
export default {
  data() {
    return {
      mindate: new Date(2019, 0, 1),
      date: '',
      btnText: '打卡', //按钮内容
      disabledBtn: false, //禁用按钮
      list: [], //打卡记录的数据
    }
  },
  methods: {
    //会执行多次，每个日期执行一次。显示打卡时间
    formatter(day) {
      for (var a in this.list) {
        if (
          this.list[a].date ==
          `${day.date.getFullYear()}-${
            day.date.getMonth() + 1
          }-${day.date.getDate()}`
        ) {
          if (this.list[a].startTime) {
            day.topInfo = this.list[a].startTime
          }
          if (this.list[a].endTime) {
            day.bottomInfo = this.list[1].endTime
          }
        }
      }
      return day
    },
    //切换选中日期执行
    select(day) {
      //显示备注
      for (var a in this.list) {
        if (
          this.list[a].date ==
            `${day.getFullYear()}-${day.getMonth() + 1}-${day.getDate()}` &&
          this.list[a].other
        ) {
          this.$toast(this.list[a].other)
        }
      }
      //这里不是当天禁用按钮
      if (day.toDateString() == new Date().toDateString()) {
        this.disabledBtn = false
      } else {
        this.disabledBtn = true
      }
    },
    //按钮事件
    submit(val) {
      // console.log('可以打卡')
    },
  },
  created: function () {
    //获取指定用户的打卡记录
    const query = Bmob.Query('RecordBean')
    query.equalTo('user', '==', sessionStorage.getItem('objectId'))
    query.find().then((res) => {
      for (var a in res) {
        this.list.push(res[a])
      }
    })
  },
}
</script>

<style>
.calendar {
  background: rgb(230, 226, 226);
  height: 450px;
}
.btn {
  margin-top: 10px;
}
</style>