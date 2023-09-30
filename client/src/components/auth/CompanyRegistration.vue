<template>
  <n-form :model="companyRegistrationData" :rules="userRegistrationRules">
    <n-form-item label="Название компании" path="title" required>
      <n-input v-model:value="companyRegistrationData.title"/>
    </n-form-item>

    <n-form-item feedback="Латинскими буквами, цифрами и нижним подчеркиванием" label="Логин" path="login" required>
      <n-input v-model:value="companyRegistrationData.login"/>
    </n-form-item>

    <n-form-item label="Пароль" path="password" required>
      <n-input v-model:value="companyRegistrationData.password" show-password-on="click" type="password">
        <template #password-visible-icon>
          <n-icon :component="VisibilityFilled" :size="16"/>
        </template>
        <template #password-invisible-icon>
          <n-icon :component="VisibilityOffFilled" :size="16"/>
        </template>
      </n-input>
    </n-form-item>

    <n-form-item label="Пароль ещё раз" path="passwordReenter" required>
      <n-input v-model:value="companyRegistrationData.passwordReenter" show-password-on="click" type="password">
        <template #password-visible-icon>
          <n-icon :component="VisibilityFilled" :size="16"/>
        </template>
        <template #password-invisible-icon>
          <n-icon :component="VisibilityOffFilled" :size="16"/>
        </template>
      </n-input>
    </n-form-item>

    <n-collapse-transition :show="!!regError" class="mb-3 text-center">
      <span class="text-danger">{{ regError }}</span>
    </n-collapse-transition>

    <n-button :disabled="isSubmitDisabled" :loading="isLoading" block size="large" type="primary"
              @click="onClickSubmitCompanyRegistration">
      Создать аккаунт
    </n-button>
  </n-form>
</template>

<script lang="ts" setup>
import {computed, reactive, ref} from 'vue'
import {FormRules} from "naive-ui";
import {VisibilityFilled, VisibilityOffFilled} from "@vicons/material"
import {axiosInstance} from "@data/api/axiosInstance.ts";
import {CurrentUser} from "@data/models/CurrentUser.ts";
import {useRouter} from "vue-router";
import {userUserStore} from "@data/store/userStore.ts";


const companyRegistrationData = reactive({
  title: '',
  login: '',
  password: '',
  passwordReenter: ''
})


const isSubmitDisabled = computed(() => {
  const {title, login, password, passwordReenter} = companyRegistrationData
  return !(title && login && password && (password === passwordReenter));
})

const userRegistrationRules: FormRules = {
  title: [{required: true, message: 'Нужно заполнить это поле', trigger: ['input', 'blur']}],
  login: [{required: true, message: 'Нужно заполнить это поле', trigger: ['input', 'blur']}, {
    validator(_: any, value: string) {
      if (!/^[A-z0-9_]*$/.test(value)) {
        return new Error('Логин должен состоять из латинских букв, цифр и символа нижнего подчеркивания')
      }
      return true
    },
    trigger: ['input', 'blur']
  }],
  password: [{required: true, message: 'Нужно заполнить это поле', trigger: ['input', 'blur']}],
  passwordReenter: [{required: true, message: 'Нужно заполнить это поле', trigger: ['input', 'blur']}, {
    validator() {
      if (companyRegistrationData.password !== companyRegistrationData.passwordReenter) {
        return new Error('Пароли не совпадают')
      }
      return true
    },
    trigger: ['input', 'blur']
  }],
}

const router = useRouter();
const regError = ref('');
const isLoading = ref(false);

const userStore = userUserStore();

const onClickSubmitCompanyRegistration = () => {
  axiosInstance.post('/auth/company-registration', companyRegistrationData)
      .then((res: any) => {
        axiosInstance.defaults.headers['Authorization'] = `Bearer ${res.data.accessToken}`
        localStorage.setItem('userData', JSON.stringify({userId: res.data.user.id, token: res.data.accessToken}))
        userStore.currentUser = new CurrentUser(res.data);
        router.replace('/auth/moderation');

      })
      .catch((err: any) => {
        regError.value = `Ошибка регистрации: ${err?.response?.data?.detail || 'неизвестная ошибка'}`
      })
      .finally(() => {
        isLoading.value = false
      })
}
</script>

<style scoped>

</style>