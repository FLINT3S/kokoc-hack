import {defineStore} from "pinia";
import {Company} from "@data/types/company.ts";
import {axiosInstance} from "@data/api/axiosInstance.ts";

export const useCompaniesStore = defineStore('companies', {
  state() {
    return {
      companies: [] as Company[],
      companiesOnModeration: [] as Company[],
      companiesRejected: [] as Company[],
      loadingRejected: false,
      loading: false,
      loadingModeration: false
    }
  },
  actions: {
    async fetchCompanies() {
      this.loading = true
      const data = await axiosInstance.get('/companies/get-all-approved')
      this.companies = data.data
      this.loading = false
    },
    async fetchCompaniesOnModeration() {
      this.loadingModeration = true
      const data = await axiosInstance.get('/companies/get-all-moderation')
      this.companiesOnModeration = data.data
      this.loadingModeration = false
    },
        async fetchCompaniesRejected() {
      this.loadingModeration = true
      const data = await axiosInstance.get('/companies/get-all-canceled')
      this.companiesRejected = data.data
      this.loadingModeration = false
    }
  }
})