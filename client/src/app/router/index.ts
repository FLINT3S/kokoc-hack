import {createRouter, createWebHashHistory} from "vue-router";
import {routes} from "@/app/router/routes.ts";
import {useUserStore} from "@data/store/userStore.ts";

export const router = createRouter({
  routes: routes,
  history: createWebHashHistory()
})


router.beforeEach(async (to, _, next) => {
  const userStore = useUserStore()
  if (!userStore.currentUser && !to.path.includes('auth') && !(await userStore.initUser())) {
    next('/auth')
  } else if (userStore.currentUser?.id && to.path.includes('auth') && await userStore.initUser()) {
    next('/')
  } else {
    next()
  }
})