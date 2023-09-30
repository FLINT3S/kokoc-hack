<template>
  <n-form :model="userRegistrationData" :rules="userRegistrationRules">
    <n-form-item label="Имя" path="name" required>
      <n-input v-model:value="userRegistrationData.name"/>
    </n-form-item>

    <n-form-item label="Фамилия" path="surname" required>
      <n-input v-model:value="userRegistrationData.surname"/>
    </n-form-item>

    <n-form-item feedback="Латинскими буквами, цифрами и нижним подчеркиванием" label="Логин" path="login" required>
      <n-input v-model:value="userRegistrationData.login"/>
    </n-form-item>

    <n-form-item label="Пароль" path="password" required>
      <n-input v-model:value="userRegistrationData.password" show-password-on="click" type="password">
        <template #password-visible-icon>
          <n-icon :component="VisibilityFilled" :size="16"/>
        </template>
        <template #password-invisible-icon>
          <n-icon :component="VisibilityOffFilled" :size="16"/>
        </template>
      </n-input>
    </n-form-item>

    <n-form-item label="Пароль ещё раз" path="passwordReenter" required>
      <n-input v-model:value="userRegistrationData.passwordReenter" show-password-on="click" type="password">
        <template #password-visible-icon>
          <n-icon :component="VisibilityFilled" :size="16"/>
        </template>
        <template #password-invisible-icon>
          <n-icon :component="VisibilityOffFilled" :size="16"/>
        </template>
      </n-input>
    </n-form-item>

    <n-form-item label="Компания" path="companyId">
      <n-select v-model:value="userRegistrationData.companyId" :options="companies" label-field="title"
                value-field="id">
      </n-select>
    </n-form-item>

    <n-form-item label="Подразделение" path="divisionId">
      <n-select v-model:value="userRegistrationData.divisionId" :disabled="userRegistrationData.companyId === null"
                :options="divisions" label-field="title" value-field="id">
      </n-select>
    </n-form-item>

    <n-collapse-transition :show="!!regError" class="mb-3 text-center">
      <span class="text-danger">{{ regError }}</span>
    </n-collapse-transition>

    <n-button :disabled="isSubmitDisabled" block size="large" type="primary" @click="onClickSubmitUserRegistration">
      Создать аккаунт
    </n-button>
  </n-form>
</template>

<script lang="ts" setup>
import {computed, onMounted, reactive, ref, watch} from 'vue'
import {FormRules} from "naive-ui";
import {VisibilityFilled, VisibilityOffFilled} from "@vicons/material"
import {axiosInstance} from "@data/api/axiosInstance.ts";
import {CurrentUser} from "@data/models/CurrentUser.ts";
import {useRouter} from "vue-router";
import {userUserStore} from "@data/store/userStore.ts";


const userRegistrationData = reactive({
  name: '',
  surname: '',
  login: '',
  password: '',
  passwordReenter: '',
  companyId: null,
  divisionId: null
})


const isSubmitDisabled = computed(() => {
  const {name, surname, login, password, passwordReenter, companyId, divisionId} = userRegistrationData
  return !(name && surname && login && password && (password === passwordReenter) && companyId && divisionId);
})

const userRegistrationRules: FormRules = {
  name: [{required: true, message: 'Нужно заполнить это поле', trigger: ['input', 'blur']}],
  surname: [{required: true, message: 'Нужно заполнить это поле', trigger: ['input', 'blur']}],
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
      if (userRegistrationData.password !== userRegistrationData.passwordReenter) {
        return new Error('Пароли не совпадают')
      }
      return true
    },
    trigger: ['input', 'blur']
  }],
  companyId: [{required: true, message: 'Нужно заполнить это поле'}],
  divisionId: [{required: true, message: 'Нужно заполнить это поле'}],
}

const companies = ref([] as any[])
const divisions = ref([] as any[])


const loadCompanies = () => {
  companies.value = [{
    title: 'kokoc',
    id: 1
  }]
}

const loadDivisions = () => {
  divisions.value = [{
    title: 'IT-департамент',
    id: 1
  }]
}

watch(() => userRegistrationData.companyId, loadDivisions);

onMounted(() => {
  loadCompanies()
})

const router = useRouter();
const regError = ref('');
const isLoading = ref(false);

const userStore = userUserStore();

const onClickSubmitUserRegistration = () => {
  axiosInstance.post('/auth/user-registration', userRegistrationData)
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