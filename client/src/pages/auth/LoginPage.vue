<template>
  <section>
    <div class="text-center">
      <h2 class="m-0 mb-3">Вход</h2>
      <p>Нет аккаунта?
        <router-link class="accent-text" to="/auth/register">Зарегистрироваться</router-link>
      </p>
    </div>

    <n-form>
      <n-form-item label="Логин">
        <n-input v-model:value="loginData.login" :loading="isLoading" placeholder="Введите логин"/>
      </n-form-item>

      <n-form-item label="Пароль">
        <n-input v-model:value="loginData.password" :loading="isLoading" placeholder="Введите пароль"
                 show-password-on="click" type="password">
          <template #password-visible-icon>
            <n-icon :component="VisibilityFilled" :size="16"/>
          </template>
          <template #password-invisible-icon>
            <n-icon :component="VisibilityOffFilled" :size="16"/>
          </template>
        </n-input>
      </n-form-item>

      <n-collapse-transition :show="!!loginError" class="mb-3 text-center">
        <span class="text-danger">{{ loginError }}</span>
      </n-collapse-transition>

      <n-button :disabled="!(loginData.login && loginData.password)" :loading="isLoading" block size="large" type="primary"
                @click="submitLogin">
        Войти
      </n-button>
    </n-form>
  </section>
</template>

<script lang="ts" setup>
import {reactive, ref} from "vue";

import {VisibilityFilled, VisibilityOffFilled} from "@vicons/material"
import {axiosInstance} from "@data/api/axiosInstance.ts";
import {useRouter} from "vue-router";
import {userUserStore} from "@data/store/userStore.ts";
import {CurrentUser} from "@data/models/CurrentUser.ts";

const loginData = reactive({
  login: "",
  password: ""
})

const router = useRouter();
const loginError = ref('');
const isLoading = ref(false);

const userStore = userUserStore();

const submitLogin = () => {
  isLoading.value = true
  axiosInstance.post('/auth/login', {login: loginData.login, password: loginData.password})
      .then(async (res: any) => {
        axiosInstance.defaults.headers['Authorization'] = `Bearer ${res.data.accessToken}`
        localStorage.setItem('userData', JSON.stringify({userId: res.data.user.id, token: res.data.accessToken}))
        if (await userStore.initUser()) {
          await router.replace('/');
        } else {
          loginError.value = 'Ошибка логина'
        }
      })
      .catch((err: any) => {
        loginError.value = `Ошибка логина: ${err?.response?.data?.detail || 'неизвестная ошибка'}`
      })
      .finally(() => {
        isLoading.value = false
      })
}
</script>

<style scoped>

</style>