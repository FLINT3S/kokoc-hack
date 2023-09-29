import {RouteRecordRaw} from "vue-router";
import HomePage from "@/pages/HomePage.vue";
import AuthPage from "@/pages/auth/AuthPage.vue";
import MainLayout from "@components/layout/MainLayout.vue";
import RegisterPage from "@/pages/auth/RegisterPage.vue";
import LoginPage from "@/pages/auth/LoginPage.vue";
import EmptyLayout from "@components/layout/EmptyLayout.vue";

export const routes: RouteRecordRaw[] = [
  {
    path: '/',
    component: HomePage,
    meta: {
      layout: MainLayout
    }
  },
  {
    path: '/auth',
    component: AuthPage,
    redirect: '/auth/login',
    children: [
      {
        path: 'register',
        component: RegisterPage
      },
      {
        path: 'login',
        component: LoginPage
      }
    ]
  },
  {
    path: '/mycompany',
    component: EmptyLayout,
    meta: {
      layout: MainLayout
    }
  },
  {
    path: '/personal',
    component: EmptyLayout,
    meta: {
      layout: MainLayout
    }
  },
  {
    path: '/leaderboard',
    component: EmptyLayout,
    meta: {
      layout: MainLayout
    }
  },
  {
    path: '/companies',
    component: EmptyLayout,
    meta: {
      layout: MainLayout
    }
  },
  {
    path: '/funds',
    component: EmptyLayout,
    meta: {
      layout: MainLayout
    }
  }
]