import {defineStore} from "pinia";
import {Company} from "@data/types/company.ts";
import {axiosInstance} from "@data/api/axiosInstance.ts";

export const useCompaniesStore = defineStore('companies', {
  state() {
    return {
      companies: [] as Company[],
      companiesOnModeration: [] as Company[]
    }
  },
  actions: {
    async fetchCompanies() {
      const data = await axiosInstance.get('/companies')
      this.companies = data.data
    },
    async fetchCompaniesOnModeration() {
      const data = await axiosInstance.get('/companies-on-moderation')
      this.companiesOnModeration = data.data
    }
  }
})