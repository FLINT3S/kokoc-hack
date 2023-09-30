import {createRouter, createWebHashHistory} from "vue-router";
import {routes} from "@/app/router/routes.ts";
import {userUserStore} from "@data/store/userStore.ts";

export const router = createRouter({
  routes: routes,
  history: createWebHashHistory()
})


router.beforeEach((to, _, next) => {
  const userStore = userUserStore()
  if (!userStore.currentUser && !to.path.includes('auth')) {
    next('/auth')
  } else {
    next()
  }
})