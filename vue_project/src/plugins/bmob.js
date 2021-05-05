import Vue from "vue";
import Bmob from "hydrogen-js-sdk";

Vue.prototype.Bmob = Bmob;
Bmob.initialize("e35d936748f5a791", "176186");
Bmob.debug(false);
