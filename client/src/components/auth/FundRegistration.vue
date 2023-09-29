<template>
  <n-form :model="fundRegistrationData" :rules="userRegistrationRules">
    <n-form-item label="Название фонда" path="title" required>
      <n-input v-model:value="fundRegistrationData.title"/>
    </n-form-item>

    <n-form-item feedback="Латинскими буквами, цифрами и нижним подчеркиванием" label="Логин" path="login" required>
      <n-input v-model:value="fundRegistrationData.login"/>
    </n-form-item>

    <n-form-item label="Пароль" path="password" required>
      <n-input v-model:value="fundRegistrationData.password" show-password-on="click" type="password">
        <template #password-visible-icon>
          <n-icon :component="VisibilityFilled" :size="16"/>
        </template>
        <template #password-invisible-icon>
          <n-icon :component="VisibilityOffFilled" :size="16"/>
        </template>
      </n-input>
    </n-form-item>

    <n-form-item label="Пароль ещё раз" path="passwordReenter" required>
      <n-input v-model:value="fundRegistrationData.passwordReenter" show-password-on="click" type="password">
        <template #password-visible-icon>
          <n-icon :component="VisibilityFilled" :size="16"/>
        </template>
        <template #password-invisible-icon>
          <n-icon :component="VisibilityOffFilled" :size="16"/>
        </template>
      </n-input>
    </n-form-item>

    <n-button :disabled="isSubmitDisabled" block size="large" type="primary" @click="onClickSubmitCompanyRegistration">
      Создать аккаунт
    </n-button>
  </n-form>
</template>

<script lang="ts" setup>
import {computed, reactive} from 'vue'
import {FormRules} from "naive-ui";
import {VisibilityFilled, VisibilityOffFilled} from "@vicons/material"
import {axiosInstance} from "@data/api/axiosInstance.ts";


const fundRegistrationData = reactive({
  title: '',
  login: '',
  password: '',
  passwordReenter: ''
})


const isSubmitDisabled = computed(() => {
  const {title, login, password, passwordReenter} = fundRegistrationData
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
      if (fundRegistrationData.password !== fundRegistrationData.passwordReenter) {
        return new Error('Пароли не совпадают')
      }
      return true
    },
    trigger: ['input', 'blur']
  }],
}

const onClickSubmitCompanyRegistration = () => {
  axiosInstance.post('/auth/fund-registration', fundRegistrationData)
}
</script>

<style scoped>

</style>