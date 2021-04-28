// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from "vue";
import App from "./App";
import router from "./router";
import ElementUI from "element-ui";
import "element-ui/lib/theme-chalk/index.css";
import Vant from "vant";
import "vant/lib/index.css";
import Bmob from "hydrogen-js-sdk";

Vue.use(ElementUI);
Vue.use(Vant);
Vue.prototype.Bmob = Bmob;
Vue.config.productionTip = true;
Bmob.initialize("e35d936748f5a791", "176186");
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
