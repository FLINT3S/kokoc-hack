import {defineStore} from "pinia";
import {axiosInstance} from "@data/api/axiosInstance.ts";
import {Fund} from "@data/types/fund.ts";

export const useFundsStore = defineStore('funds', {
  state() {
    return {
      funds: [] as Fund[],
      fundsOnModeration: [] as Fund[],
      fundsRejected: [] as Fund[],
      loadingRejected: false,
      loading: false,
      loadingModeration: false
    }
  },
  actions: {
    async fetchFunds() {
      this.loading = true
      const data = await axiosInstance.get('/funds/get-all-approved')
      this.funds = data.data
      this.loading = false
    },
    async fetchFundsOnModeration() {
      this.loadingModeration = true
      const data = await axiosInstance.get('/funds/get-all-moderation')
      this.fundsOnModeration = data.data
      this.loadingModeration = false
    },
        async fetchFundsRejected() {
      this.loadingModeration = true
      const data = await axiosInstance.get('/funds/get-all-canceled')
      this.fundsRejected = data.data
      this.loadingModeration = false
    }
  }
})