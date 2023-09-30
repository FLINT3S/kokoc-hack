import axios from 'axios'

export const axiosInstance = axios.create({
  baseURL: 'https://kokoc.flint3s.ru/api/'
})