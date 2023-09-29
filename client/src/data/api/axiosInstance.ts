import axios from 'axios'

export const axiosInstance = axios.create({
  // url: 'https://kokoc.flint3s.ru/api/'
  baseURL: 'https://run.mocky.io/v3/'
})