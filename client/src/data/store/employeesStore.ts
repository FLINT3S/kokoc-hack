import {defineStore} from "pinia";
import {axiosInstance} from "@data/api/axiosInstance.ts";
import {Employee} from "@data/types/employee.ts";

export const useEmployeesStore = defineStore('employees', {
  state() {
    return {
      employees: [] as Employee[],
      employeesOnModeration: [] as Employee[],
      employeesRejected: [] as Employee[],
      loadingRejected: false,
      loading: false,
      loadingModeration: false
    }
  },
  actions: {
    async fetchEmployees() {
      this.loading = true
      const data = await axiosInstance.get('/employees/get-all-approved')
      this.employees = data.data
      this.loading = false
    },
    async fetchEmployeesOnModeration() {
      this.loadingModeration = true
      const data = await axiosInstance.get('/employees/get-all-moderation')
      this.employeesOnModeration = data.data
      this.loadingModeration = false
    },
    async fetchEmployeesRejected() {
      this.loadingModeration = true
      const data = await axiosInstance.get('/employees/get-all-canceled')
      this.employeesRejected = data.data
      this.loadingModeration = false
    }
  }
})