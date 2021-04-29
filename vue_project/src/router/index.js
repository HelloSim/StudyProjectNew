import Vue from "vue";
import Router from "vue-router";
import App from "@/App";

import home from "@/views/wangyi/home.vue";
import bus from "@/views/bus/bus.vue";
import record from "@/views/record/record.vue";
import user from "@/views/user/user.vue";
import userInfo from "@/views/user/userInfo.vue";
import userCollected from "@/views/user/userCollected.vue";

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
      path: "/user/userInfo",
      name: "userInfo",
      component: userInfo
    },
    {
      path: "/user/userCollected",
      name: "userCollected",
      component: userCollected
    }
  ]
});
