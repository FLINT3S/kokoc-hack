import {RouteRecordRaw} from "vue-router";
import HomePage from "@/pages/HomePage.vue";
import AuthPage from "@/pages/auth/AuthPage.vue";
import MainLayout from "@components/layout/MainLayout.vue";
import RegisterPage from "@/pages/auth/RegisterPage.vue";
import LoginPage from "@/pages/auth/LoginPage.vue";
import ModerationPage from "@/pages/auth/ModeartionPage.vue";
import MyCompanyPage from "@/pages/SingleCompanyPage.vue";
import SingleCompanyPage from "@/pages/SingleCompanyPage.vue";
import PersonalPage from "@/pages/PersonalPage.vue";
import LeaderBoardPage from "@/pages/LeaderBoardPage.vue";
import CompaniesPage from "@/pages/CompaniesPage.vue";
import FundsPage from "@/pages/FundsPage.vue";
import SingleFundPage from "@/pages/SingleFundPage.vue";
import SingleDivisionPage from "@/pages/SingleDivisionPage.vue";

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
      },
      {
        path: 'moderation',
        component: ModerationPage
      }
    ]
  },
  {
    path: '/mycompany',
    meta: {
      layout: MainLayout
    },
    children: [
      {
        path: '',
        component: MyCompanyPage
      },
      {
        path: ':companyId/:divisionId',
        component: SingleDivisionPage
      }
    ]
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
    meta: {
      layout: MainLayout
    },
    children: [
      {
        path: '',
        component: CompaniesPage,
      },
      {
        path: ':id',
        component: SingleCompanyPage,
      },
      {
        path: ':companyId/:divisionId',
        component: SingleDivisionPage
      }
    ]
  },
  {
    path: '/funds',
    meta: {
      layout: MainLayout
    },
    children: [
      {
        path: '',
        component: FundsPage,
      },
      {
        path: ':id',
        component: SingleFundPage
      }
    ]
  },
  {
    path: '/myFund',
    component: SingleFundPage,
    meta: {
      layout: MainLayout
    }
  }
]