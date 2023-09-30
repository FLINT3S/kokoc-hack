import {createApp} from 'vue'
import {createPinia} from "pinia";
import VueApexCharts from "vue3-apexcharts";

import App from './App.vue'
import {router} from "@/app/router";

import '@/app/style/lib/bootstrap-utilities.min.css'
import '@/app/style/style.css'

createApp(App)
  .use(router)
  .use(createPinia())
  .use(VueApexCharts)
  .mount('#app')
