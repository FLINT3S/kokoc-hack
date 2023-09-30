import {defineStore} from "pinia";
import {CurrentUser} from "@data/models/CurrentUser.ts";

export const userUserStore = defineStore('user', {
  state(): {
    currentUser: CurrentUser | null,
    token: string | null,
    theme: 'light' | 'dark'
  } {
    return {
      currentUser: new CurrentUser('superadmin'),
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
    }
  }
})