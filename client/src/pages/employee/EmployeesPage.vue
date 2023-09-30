<template>
  <div class="content-container">
    <n-tabs v-if="userStore?.currentUser?.role === 'companyadmin'" type="segment">
      <n-tab-pane name="oasis" tab="Одобренные сотрудники">
        <n-space vertical>
          <n-input v-model:value="filterQuery" placeholder="Поиск по сотрудникам"/>

          <n-data-table :columns="employeesColumns" :data="filteredEmployees" :loading="employeesStore.loading"
                        :pagination="{pageSize: 5}"/>
        </n-space>
      </n-tab-pane>

      <n-tab-pane name="moderation" tab="На модерации">
        <n-spin v-if="employeesStore.employeesOnModeration.length && !employeesStore.loadingModeration"
                :show="employeesStore.loadingModeration"
                class="mt-3">
          <n-grid :x-gap="10" :y-gap="10" cols="1 400:2 800:3">
            <n-gi v-for="employee in employeesStore.employeesOnModeration">
              <n-card :title="`${employee.name} ${employee.surname}`" size="small">
                <p class="m-0">Подразделение: {{employee.division.title}}</p>

                <template #header-extra>
                  {{
                    new Date(employee.requestedAt).toLocaleDateString() + ' в ' + new Date(employee.requestedAt).getHours() + ':' + new Date(employee.requestedAt).getMinutes()
                  }}
                </template>

                <template #action>
                  <n-space>
                    <n-button secondary type="primary" @click="onClickAcceptEmployee(employee)">
                      Одобрить
                    </n-button>

                    <n-button type="error" @click="onClickRejectEmployee(employee)">
                      Отклонить
                    </n-button>
                  </n-space>
                </template>
              </n-card>
            </n-gi>
          </n-grid>
        </n-spin>
        <div v-else class="mt-3 text-center">
          Нет пользователей на модерации
        </div>
      </n-tab-pane>

      <n-tab-pane name="rejected" tab="Отклоненные">
        <n-spin v-if="employeesStore.employeesRejected.length && !employeesStore.loadingRejected"
                :show="employeesStore.loadingRejected"
                class="mt-3">
          <n-grid :x-gap="10" :y-gap="10" cols="1 400:2 800:3">
            <n-gi v-for="employee in employeesStore.employeesRejected">
              <n-card :title="`${employee.name} ${employee.surname}`" size="small">
                <p class="m-0">Подразделение: {{employee.division.title}}</p>

                <template #header-extra>
                  {{
                    new Date(employee.requestedAt).toLocaleDateString() + ' в ' + new Date(employee.requestedAt).getHours() + ':' + new Date(employee.requestedAt).getMinutes()
                  }}
                </template>

                <template #action>
                  <n-space>
                    <n-button secondary type="primary" @click="onClickAcceptEmployee(employee)">
                      Одобрить
                    </n-button>
                  </n-space>
                </template>
              </n-card>
            </n-gi>
          </n-grid>
        </n-spin>
        <div v-else class="mt-3 text-center">
          Нет отклоненных пользователей
        </div>
      </n-tab-pane>
    </n-tabs>

    <n-space v-else vertical>
      <n-input v-model:value="filterQuery" placeholder="Поиск по сотрудникам"/>

      <n-data-table :columns="employeesColumns" :data="filteredEmployees" :loading="employeesStore.loading"
                    :pagination="{pageSize: 5}"/>
    </n-space>
  </div>
</template>

<script lang="ts" setup>
import {computed, h, ref} from 'vue'
import {DataTableColumn, NButton, useDialog, useMessage} from 'naive-ui';
import {router} from "@/app/router";
import {axiosInstance} from "@data/api/axiosInstance.ts";
import {useUserStore} from "@data/store/userStore.ts";
import {useEmployeesStore} from "@data/store/employeesStore.ts";
import {Employee} from "@data/types/employee.ts";

const employeesStore = useEmployeesStore()
const userStore = useUserStore()

const dialog = useDialog()
const message = useMessage()

const onClickAcceptEmployee = (employee: Employee) => {
  dialog.create({
    title: `Принять ${employee.name} ${employee.surname}?`,
    positiveText: 'Принять заявку',
    negativeText: 'Отмена',
    onPositiveClick: async () => {
      await axiosInstance.post('/employees/moderate', {employee_id: employee.id, status: true})
      await fetchAll()
      message.success('Принято!')
    }
  })
}

const onClickRejectEmployee = (employee: Employee) => {
  dialog.error({
    title: `Отклонить ${employee.name} ${employee.surname}?`,
    positiveText: 'Отклонить заявку',
    negativeText: 'Отмена',
    onPositiveClick: async () => {
      await axiosInstance.post('/employees/moderate', {employee_id: employee.id, status: false})
      await fetchAll()
      message.error('Заявка отклонена')
    }
  })
}

const filterQuery = ref('')
const filteredEmployees = computed(() => {
  return employeesStore.employees.filter(c => (c.name.toLowerCase() + c.surname.toLowerCase()).includes(filterQuery.value.toLowerCase()))
})

const fetchAll = async () => {
  await Promise.all([
    employeesStore.fetchEmployees(),
    employeesStore.fetchEmployeesOnModeration(),
    employeesStore.fetchEmployeesRejected()
  ])
}

fetchAll()

const employeesColumns: DataTableColumn[] = [
  {
    title: '#',
    key: 'index',
    render: (_, i) => {
      return `${i + 1}`
    }
  },
  {
    title: 'ФИО',
    key: 'name',
    render: (row: any, _) => `${row.name} ${row.surname}`
  },
  {
    title: 'Заявка подана',
    key: 'requestedAt',
    sorter: (row1: any, row2: any) => new Date(row1.requestedAt).getTime() - new Date(row2.requestedAt).getTime(),
    render: (row: any, _) => {
      return new Date(row.requestedAt).toLocaleDateString() + ' в ' + new Date(row.requestedAt).getHours() + ':' + new Date(row.requestedAt).getMinutes()
    }
  },
  {
    title: 'Профиль',
    key: 'goto',
    render: (row, _) => {
      return h(
          NButton,
          {
            size: 'small',
            onClick: () => {
              router.push('/employees/' + row.id)
            }
          },
          {default: () => 'Открыть профиль'}
      )
    }
  }
]
</script>

<style scoped>

</style>