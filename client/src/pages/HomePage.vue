// @ts-nocheck

<template>
  <div class="content-container">
    <div v-if="mode === 'companyadmin'">
      <div class="d-flex flex-column flex-md-row mb-4 justify-content-between align-items-center">
        <h2>Компания «{{ userStore.currentUser?.company?.title }}»</h2>
        <n-button secondary type="primary" @click="isSettingsModalShown = true">Настройки компании</n-button>
      </div>

      <n-grid cols="1 400:2 800:4" x-gap="10" y-gap="10">
        <n-gi v-for="s in stats">
          <n-card :title="s.header" class="h-100">
            <h1 class="m-0">{{ s.value }}</h1>
          </n-card>
        </n-gi>
      </n-grid>

      <n-divider/>

      <h3>Активность сотрудников</h3>

      <n-data-table
          :data="activitiesInCompany"
          :columns="activitiesColumns"
          :pagination="{pageSize: 10}"
      />
    </div>

    <n-modal :show="isSettingsModalShown">
      <n-card class="card-md" closable title="Настройки компании" @close="isSettingsModalShown = false">

        <n-form-item label="Цена за калорию">
          <n-input :value="'0.01'">
          </n-input>
        </n-form-item>

        <template #action>
          <n-button disabled primary>
            Сохранить
          </n-button>

          <n-button secondary @click="isSettingsModalShown = false">
            Отмена
          </n-button>
        </template>
      </n-card>
    </n-modal>
  </div>
</template>

<script lang="ts" setup>
import {useUserStore} from "@data/store/userStore.ts";
import {axiosInstance} from "@data/api/axiosInstance.ts";
import {DataTableColumn} from "naive-ui";

const userStore = useUserStore()

const isSettingsModalShown = ref(false);

const mode = ref(userStore?.currentUser?.role)

const stats = [
  {
    header: 'Сотрудников',
    value: 24
  },
  {
    header: 'Подразделений',
    value: 3
  },
  {
    header: 'Калорий',
    value: '1440K'
  },
  {
    header: 'Пожертвований',
    value: '38.000р'
  }
]


const activitiesInCompany = ref<any>([])
const employees = ref<any[]>()

const loadEmployees = async () => {
  employees.value = (await axiosInstance.get('/employees/get-employees-in-company/' + userStore.currentUser?.company?.id)).data
}

const loadActivitiesInCompany = async () => {
  await loadEmployees()
  activitiesInCompany.value = (await axiosInstance.get('/activities/get-all-in-company/' + userStore.currentUser?.company?.id)).data.map((e: any) => {
    return {...e, training_information: JSON.parse(e.training_information), images: JSON.parse(e.images), employee: employees.value?.find(emp => emp.id === e.employee_id)}
  })
  console.log(activitiesInCompany.value)
}

const activitiesColumns: DataTableColumn[] = [
  {
    title: '#',
    key: 'index',
    render: (_, i) => {
      return `${i + 1}`
    }
  },
  {
    title: 'ФИО',
    key: 'employee',
    render: (row, _) => {
      return `${row.employee.name} ${row.employee.surname}`
    }
  },
]

loadActivitiesInCompany()
</script>

<style scoped>

</style>