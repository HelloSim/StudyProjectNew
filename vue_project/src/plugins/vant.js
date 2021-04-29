import Vue from "vue";
import "vant/lib/index.css";

import {
  Tabbar,
  TabbarItem,
  Icon,
  Cell,
  CellGroup,
  Popup,
  Form,
  Field,
  Button,
  Divider,
  Dialog,
  List,
  Image as VanImage,
  PullRefresh,
  Swipe,
  SwipeItem,
  Lazyload,
  Tab,
  Tabs,
  Search,
  Calendar
} from "vant";

Vue.use(Tabbar)
  .use(TabbarItem)
  .use(Icon)
  .use(Cell)
  .use(CellGroup)
  .use(Popup)
  .use(Form)
  .use(Field)
  .use(Button)
  .use(Divider)
  .use(Dialog)
  .use(List)
  .use(VanImage)
  .use(PullRefresh)
  .use(Swipe)
  .use(SwipeItem)
  .use(Lazyload)
  .use(Tab)
  .use(Tabs)
  .use(Search)
  .use(Calendar);
