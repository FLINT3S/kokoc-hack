import {defineStore} from "pinia";
import {CurrentUser} from "@data/models/CurrentUser.ts";
import {axiosInstance} from "@data/api/axiosInstance.ts";

export const userUserStore = defineStore('user', {
  state(): {
    currentUser: CurrentUser | null,
    token: string | null,
    theme: 'light' | 'dark'
  } {
    return {
      currentUser: null,
      token: null,
      theme: 'light'
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
      const data = JSON.parse(localStorage.getItem('userData') || 'null')

      if (!data?.userId) return false

      try {
        const userData = (await axiosInstance.post(`/auth/check`, {accessToken: data.token})).data;
        axiosInstance.defaults.headers['Authorization'] = `Bearer ${data.token}`
        this.currentUser = new CurrentUser(userData)
        return true
      } catch {
        return false
      }
    }
  }
})