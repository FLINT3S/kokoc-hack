import {createRouter, createWebHashHistory} from "vue-router";
import {routes} from "@/app/router/routes.ts";

export const router = createRouter({
  routes: routes,
  history: createWebHashHistory()
})