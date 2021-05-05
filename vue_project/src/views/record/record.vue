<template>
  <div>
    <van-calendar class="calendar" :value="date" :poppable="false" color="#66B1F4" :first-day-of-week="0"
      :min-date="mindate" :show-title="false" :show-subtitle="false" :show-confirm="false" :formatter="formatter"
      @select="select" />
    <van-button class="btn" type="primary" round block @click="submit">
      {{ btnText }}
    </van-button>

    <van-popup v-model="showPopup" :round="true" style="width: 90%; height: 130px; align-items: center">
      <van-form @submit="onSubmit">
        <van-field v-model="other" name="other" label="备忘" placeholder="填写备忘" />
        <div style="margin: 16px">
          <van-button round block type="info" native-type="submit">确认</van-button>
        </div>
      </van-form>
    </van-popup>
  </div>
</template>

<script>
export default {
  data() {
    return {
      mindate: new Date(2019, 0, 1),
      date: '',
      btnText: '打卡', //按钮内容
      list: [], //打卡记录的数据
      selectedDate: new Date(),

      isLogin: Bmob.User.current() == null ? false : true,
      showPopup: false,
      other: '',
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
      if (day.date.toDateString() == new Date().toDateString()) {
        day.text = '今'
      }
      return day
    },
    //切换选中日期执行
    select(day) {
      this.selectedDate = day
      //显示备注
      for (var a in this.list) {
        if (
          this.list[a].date ==
          `${day.getFullYear()}-${day.getMonth() + 1}-${day.getDate()}`
        ) {
          if (this.list[a].other && !/^\s+$/g.test(this.list[a].other)) {
            this.other = this.list[a].other
            this.$toast(this.list[a].other)
          } else {
            this.other = ''
          }
        } else {
          this.other = ''
        }
      }
      //当天显示打卡，其他显示备注
      if (day.toDateString() == new Date().toDateString()) {
        this.btnText = '打卡'
      } else {
        this.btnText = '备忘'
      }
    },
    //按钮事件
    submit(val) {
      if (this.isLogin) {
        if (this.btnText == '打卡') {
          console.log('打卡')
        } else {
          this.showPopup = true
        }
      } else {
        this.$toast('未登录')
      }
    },
    //弹窗确认事件
    onSubmit(values) {
      this.showPopup = false
      var that = this
      var data = this.list.filter(function (item) {
        return (
          item.date ==
          `${that.selectedDate.getFullYear()}-${
            that.selectedDate.getMonth() + 1
          }-${that.selectedDate.getDate()}`
        )
      })
      if (data.length > 0) {
        //有记录修改
        const query = Bmob.Query('RecordBean')
        query
          .get(data[0].objectId)
          .then((res) => {
            res.set('other', that.other)
            res.save()
            this.list[this.list.indexOf(data[0])].other = that.other
          })
          .catch((err) => {
            console.log(err)
          })
      } else {
        //无记录新增
        const pointer = Bmob.Pointer('_User')
        const user = pointer.set(Bmob.User.current().objectId)
        const query = Bmob.Query('RecordBean')
        query.set('user', user)
        query.set(
          'date',
          `${that.selectedDate.getFullYear()}-${
            that.selectedDate.getMonth() + 1
          }-${that.selectedDate.getDate()}`
        )
        query.set(
          'yearAndMonth',
          `${that.selectedDate.getFullYear()}${
            that.selectedDate.getMonth() + 1
          }`
        )
        query.set('serial', that.selectedDate.getDate())
        query.set('week', '星期六')
        query.set('isLate', false)
        query.set('isLeaveEarly', false)
        query.set('other', this.other)
        query
          .save()
          .then((res) => {
            console.log(res)
          })
          .catch((err) => {
            console.log(err)
          })
      }
      this.other = ''
    },
  },
  created: function () {
    //获取指定用户的打卡记录
    if (this.isLogin) {
      const query = Bmob.Query('RecordBean')
      query.equalTo('user', '==', Bmob.User.current().objectId)
      query.find().then((res) => {
        for (var a in res) {
          this.list.push(res[a])
        }
      })
    }
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
/* .van-popup {
  align-items: center;
} */
</style>