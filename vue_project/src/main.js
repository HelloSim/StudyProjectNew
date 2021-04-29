// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from "vue";
import App from "./App";
import router from "./router";

import axios from "axios";
import VueAxios from "vue-axios";
import "./plugins/element.js";
import "./plugins/vant.js";
import "./plugins/bmob.js";

Vue.use(VueAxios, axios);
Vue.config.productionTip = true;
/* eslint-disable no-new */
new Vue({
  //绑定组件
  el: "#app",

  //路由
  router,

  //挂载组件
  components: { App },

  //模板，优先级高于el
  template: "<App/>"
});
