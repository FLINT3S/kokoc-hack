import {defineStore} from "pinia";
import {CurrentUser} from "@data/models/CurrentUser.ts";
import {axiosInstance} from "@data/api/axiosInstance.ts";

export const useUserStore = defineStore('user', {
  state(): {
    currentUser: CurrentUser | null,
    token: string | null,
    theme: 'light' | 'dark',
    userInitLoading: boolean
  } {
    return {
      currentUser: null,
      token: null,
      theme: 'light',
      userInitLoading: true
    }
  },
  actions: {
    initTheme() {
      this.theme = (localStorage.getItem('appTheme') || 'light') as 'light' | 'dark'
    },
    toggleTheme() {
      this.theme = this.theme === 'light' ? 'dark' : 'light'
      localStorage.setItem('appTheme', this.theme)
    },
    async initUser() {
      this.userInitLoading = true
      const data = JSON.parse(localStorage.getItem('userData') || 'null')

      if (!data?.userId) return false

      try {
        const userData = (await axiosInstance.post(`/auth/check`, {accessToken: data.token})).data;
        axiosInstance.defaults.headers['Authorization'] = `Bearer ${data.token}`
        this.currentUser = new CurrentUser(userData)
        this.userInitLoading = false
        return true
      } catch {
        this.userInitLoading = false
        return false
      }
    }
  }
})