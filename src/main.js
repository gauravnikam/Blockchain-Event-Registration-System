/* eslint-disable */
import Vue from 'vue'
import App from './App.vue'

import VueToastr from "vue-toastr";
Vue.use(VueToastr, {});

export const eventBus = new Vue();

import VueLoading from 'vuejs-loading-plugin';
Vue.use(VueLoading);

Vue.config.productionTip = false

new Vue({
  render: h => h(App),
}).$mount('#app')
