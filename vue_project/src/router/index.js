import Vue from "vue";
import Router from "vue-router";
import App from "@/App";

import home from "@/views/home.vue";
import bus from "@/views/bus.vue";
import record from "@/views/record.vue";

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
    }
  ]
});
