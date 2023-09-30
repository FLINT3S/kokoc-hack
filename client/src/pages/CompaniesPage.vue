<template>
  <div class="content-container">
    <n-tabs type="segment">
      <n-tab-pane name="oasis" tab="Одобренные компании">
        <n-space vertical>
          <n-input v-model:value="filterQuery" placeholder="Поиск по компаниям"/>

          <n-data-table :columns="companiesColumns" :data="filteredCompanies" :loading="companiesStore.loading"
                        :pagination="{pageSize: 5}"/>
        </n-space>
      </n-tab-pane>

      <n-tab-pane name="moderation" tab="На модерации">
        <n-spin v-if="companiesStore.companiesOnModeration.length && !companiesStore.loadingModeration"
                :show="companiesStore.loadingModeration"
                class="mt-3">
          <n-grid :x-gap="10" :y-gap="10" cols="1 400:2 800:3">
            <n-gi v-for="company in companiesStore.companiesOnModeration">
              <n-card :title="company.title" size="small">
                <template #header-extra>
                  {{
                    new Date(company.requestedAt).toLocaleDateString() + ' в ' + new Date(company.requestedAt).getHours() + ':' + new Date(company.requestedAt).getMinutes()
                  }}
                </template>

                <template #action>
                  <n-space>
                    <n-button secondary type="primary" @click="onClickAcceptCompany(company)">
                      Одобрить
                    </n-button>

                    <n-button type="error" @click="onClickRejectCompany(company)">
                      Отклонить
                    </n-button>
                  </n-space>
                </template>
              </n-card>
            </n-gi>
          </n-grid>
        </n-spin>
        <div class="mt-3 text-center">
          Нет компаний на модерации
        </div>
      </n-tab-pane>

      <n-tab-pane name="rejected" tab="Отклоненные">
        <n-spin v-if="companiesStore.companiesRejected.length && !companiesStore.loadingRejected"
                :show="companiesStore.loadingRejected"
                class="mt-3">
          <n-grid :x-gap="10" :y-gap="10" cols="1 400:2 800:3">
            <n-gi v-for="company in companiesStore.companiesRejected">
              <n-card :title="company.title" size="small">
                <template #header-extra>
                  {{
                    new Date(company.requestedAt).toLocaleDateString() + ' в ' + new Date(company.requestedAt).getHours() + ':' + new Date(company.requestedAt).getMinutes()
                  }}
                </template>

                <template #action>
                  <n-space>
                    <n-button secondary type="primary" @click="onClickAcceptCompany(company)">
                      Одобрить
                    </n-button>
                  </n-space>
                </template>
              </n-card>
            </n-gi>
          </n-grid>
        </n-spin>
        <div class="mt-3 text-center">
          Нет отклоненных компаний
        </div>
      </n-tab-pane>
    </n-tabs>
  </div>
</template>

<script lang="ts" setup>
import {computed, h, ref} from 'vue'
import {DataTableColumn, NButton, useDialog, useMessage} from 'naive-ui';
import {useCompaniesStore} from "@data/store/companiesStore.ts";
import {Company} from "@data/types/company.ts";
import {router} from "@/app/router";
import {axiosInstance} from "@data/api/axiosInstance.ts";

const companiesStore = useCompaniesStore()

const dialog = useDialog()
const message = useMessage()

const onClickAcceptCompany = (company: Company) => {
  dialog.create({
    title: `Принять ${company.title}?`,
    positiveText: 'Принять заявку',
    negativeText: 'Отмена',
    onPositiveClick: async () => {
      await axiosInstance.post('/companies/moderate', {company_id: company.id, status: true})
      await fetchAll()
      message.success('Принято!')
    }
  })
}

const onClickRejectCompany = (company: Company) => {
  dialog.error({
    title: `Отклонить ${company.title}?`,
    positiveText: 'Отклонить заявку',
    negativeText: 'Отмена',
    onPositiveClick: async () => {
      await axiosInstance.post('/companies/moderate', {company_id: company.id, status: true})
      await fetchAll()
      message.error('Заявка отклонена')
    }
  })
}

const filterQuery = ref('')
const filteredCompanies = computed(() => {
  return companiesStore.companies.filter(c => c.title.toLowerCase().includes(filterQuery.value.toLowerCase()))
})

const fetchAll = async () => {
  await Promise.all([
    companiesStore.fetchCompanies(),
    companiesStore.fetchCompaniesOnModeration(),
    companiesStore.fetchCompaniesRejected()
  ])
}

fetchAll()

const companiesColumns: DataTableColumn[] = [
  {
    title: '#',
    key: 'index',
    render: (_, i) => {
      return `${i + 1}`
    }
  },
  {
    title: 'Название',
    key: 'title',
  },
  {
    title: 'Число сотрудников',
    key: 'employeesNumber',
    sorter: (row1: Company, row2: Company) => row1.employeesNumber - row2.employeesNumber
  },
  {
    title: 'Заявка подана',
    key: 'requestedAt',
    sorter: (row1: Company, row2: Company) => row1.requestedAt - row2.requestedAt,
    render: (row: Company, _) => {
      return new Date(row.requestedAt).toLocaleDateString() + ' в ' + new Date(row.requestedAt).getHours() + ':' + new Date(row.requestedAt).getMinutes()
    }
  },
  {
    title: 'Перейти на страницу',
    key: 'goto',
    render: (row, _) => {
      return h(
          NButton,
          {
            size: 'small',
            onClick: () => {
              router.push('/companies/' + row.id)
            }
          },
          {default: () => 'Открыть компанию'}
      )
    }
  }
]
</script>

<style scoped>

</style>