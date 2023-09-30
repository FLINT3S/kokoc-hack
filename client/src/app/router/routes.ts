import {RouteRecordRaw} from "vue-router";
import HomePage from "@/pages/HomePage.vue";
import AuthPage from "@/pages/auth/AuthPage.vue";
import MainLayout from "@components/layout/MainLayout.vue";
import RegisterPage from "@/pages/auth/RegisterPage.vue";
import LoginPage from "@/pages/auth/LoginPage.vue";
import MyCompanyPage from "@/pages/MyCompanyPage.vue";
import PersonalPage from "@/pages/PersonalPage.vue";
import LeaderBoardPage from "@/pages/LeaderBoardPage.vue";
import CompaniesPage from "@/pages/CompaniesPage.vue";
import FundsPage from "@/pages/FundsPage.vue";

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
    component: MyCompanyPage,
    meta: {
      layout: MainLayout
    }
  },
  {
    path: '/personal',
    component: PersonalPage,
    meta: {
      layout: MainLayout
    }
  },
  {
    path: '/leaderboard',
    component: LeaderBoardPage,
    meta: {
      layout: MainLayout
    }
  },
  {
    path: '/companies',
    component: CompaniesPage,
    meta: {
      layout: MainLayout
    }
  },
  {
    path: '/funds',
    component: FundsPage,
    meta: {
      layout: MainLayout
    }
  }
]