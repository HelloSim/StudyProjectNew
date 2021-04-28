import Vue from "vue";
import Router from "vue-router";
import App from "@/App";

import home from "@/views/wangyi/home.vue";
import bus from "@/views/bus/bus.vue";
import record from "@/views/record/record.vue";
import user from "@/views/user/user.vue";
import userInfo from "@/views/user/userInfo.vue";

Vue.use(Router);

export default new Router({
  routes: [
    {
      path: "/",
      name: "home",
      component: home,
      redirect: "/home"
    },
    {
      path: "/home",
      name: "home",
      component: home
    },
    {
      path: "/bus",
      name: "bus",
      component: bus
    },
    {
      path: "/record",
      name: "record",
      component: record
    },
    {
      path: "/user",
      name: "user",
      component: user
    },
    {
      path: "/userInfo",
      name: "userInfo",
      component: userInfo
    },
    {
      path: "/collected",
      name: "collected",
      component: record
    }
  ]
});
