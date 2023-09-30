<template>
  <div class="content-container">
    <n-tabs type="segment">
      <n-tab-pane name="oasis" tab="Одобренные компании">
        <n-space vertical>
          <n-input placeholder="Поиск по компаниям"/>

          <n-data-table :columns="companiesColumns" :data="filteredCompanies"/>
        </n-space>
      </n-tab-pane>

      <n-tab-pane name="the beatles" tab="На модерации">
        <n-grid :x-gap="10" :y-gap="10" cols="1 400:2 800:3">
          <n-gi v-for="company in companiesStore.companiesOnModeration">
            <n-card size="small" :title="company.title">
              <template #header-extra>
                {{ company.requestedAt }}
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
      </n-tab-pane>
    </n-tabs>
  </div>
</template>

<script lang="ts" setup>
import {h, ref, computed} from 'vue'
import {DataTableColumn, NButton, useDialog, useMessage} from 'naive-ui';
import {useCompaniesStore} from "@data/store/companiesStore.ts";
import {Company} from "@data/types/company.ts";

const companiesStore = useCompaniesStore()

const dialog = useDialog()
const message = useMessage()

const onClickAcceptCompany = (company: Company) => {
  dialog.create({
    title: `Принять ${company.title}?`,
    positiveText: 'Принять заявку',
    negativeText: 'Отмена',
    onPositiveClick: () => {
      message.success('Принято!')
    }
  })
}

const onClickRejectCompany = (company: Company) => {
  dialog.error({
    title: `Отклонить ${company.title}?`,
    positiveText: 'Отклонить заявку',
    negativeText: 'Отмена',
    onPositiveClick: () => {
      message.error('Заявка отклонена')
    }
  })
}

const filterQuery = ref('')
const filteredCompanies = computed(() => {
  return companiesStore.companies.filter(c => c.title.toLowerCase().includes(filterQuery.value.toLowerCase()))
})

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
    key: 'employeesNumber'
  },
  {
    title: 'Перейти на страницу',
    key: 'goto',
    render: () => {
      return h(
          NButton,
          {
            size: 'small',
            onClick: () => {}
          },
          { default: () => 'Открыть компанию' }
        )
    }
  }
]
</script>

<style scoped>

</style>