<template>
  <div class="content-container">
    <n-tabs type="segment" v-if="userStore?.currentUser?.role === 'superadmin'">
      <n-tab-pane name="oasis" tab="Одобренные фонды">
        <n-space vertical>
          <n-input v-model:value="filterQuery" placeholder="Поиск по фондам"/>

          <n-data-table :columns="fundsColumns" :data="filteredFunds" :loading="fundsStore.loading"
                        :pagination="{pageSize: 5}"/>
        </n-space>
      </n-tab-pane>

      <n-tab-pane name="moderation" tab="На модерации">
        <n-spin v-if="fundsStore.fundsOnModeration.length && !fundsStore.loadingModeration"
                :show="fundsStore.loadingModeration"
                class="mt-3">
          <n-grid :x-gap="10" :y-gap="10" cols="1 400:2 800:3">
            <n-gi v-for="fund in fundsStore.fundsOnModeration">
              <n-card :title="fund.title" size="small">
                <template #header-extra>
                  {{
                    new Date(fund.requestedAt).toLocaleDateString() + ' в ' + new Date(fund.requestedAt).getHours() + ':' + new Date(fund.requestedAt).getMinutes()
                  }}
                </template>

                <template #action>
                  <n-space>
                    <n-button secondary type="primary" @click="onClickAcceptFund(fund)">
                      Одобрить
                    </n-button>

                    <n-button type="error" @click="onClickRejectFund(fund)">
                      Отклонить
                    </n-button>
                  </n-space>
                </template>
              </n-card>
            </n-gi>
          </n-grid>
        </n-spin>
        <div class="mt-3 text-center">
          Нет фондов на модерации
        </div>
      </n-tab-pane>

      <n-tab-pane name="rejected" tab="Отклоненные">
        <n-spin v-if="fundsStore.fundsRejected.length && !fundsStore.loadingRejected"
                :show="fundsStore.loadingRejected"
                class="mt-3">
          <n-grid :x-gap="10" :y-gap="10" cols="1 400:2 800:3">
            <n-gi v-for="fund in fundsStore.fundsRejected">
              <n-card :title="fund.title" size="small">
                <template #header-extra>
                  {{
                    new Date(fund.requestedAt).toLocaleDateString() + ' в ' + new Date(fund.requestedAt).getHours() + ':' + new Date(fund.requestedAt).getMinutes()
                  }}
                </template>

                <template #action>
                  <n-space>
                    <n-button secondary type="primary" @click="onClickAcceptFund(fund)">
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

    <n-space vertical v-else>
          <n-input v-model:value="filterQuery" placeholder="Поиск по фондам"/>

          <n-data-table :columns="fundsColumns" :data="filteredFunds" :loading="fundsStore.loading"
                        :pagination="{pageSize: 5}"/>
        </n-space>
  </div>
</template>

<script lang="ts" setup>
import {computed, h, ref} from 'vue'
import {DataTableColumn, NButton, useDialog, useMessage} from 'naive-ui';
import {Company} from "@data/types/company.ts";
import {router} from "@/app/router";
import {axiosInstance} from "@data/api/axiosInstance.ts";
import {useFundsStore} from "@data/store/fundsStore.ts";
import {Fund} from "@data/types/fund.ts";
import {useUserStore} from "@data/store/userStore.ts";

const fundsStore = useFundsStore()
const userStore = useUserStore()

const dialog = useDialog()
const message = useMessage()

const onClickAcceptFund = (fund: Fund) => {
  dialog.create({
    title: `Принять ${fund.title}?`,
    positiveText: 'Принять заявку',
    negativeText: 'Отмена',
    onPositiveClick: async () => {
      await axiosInstance.post('/funds/moderate', {fund_id: fund.id, status: true})
      await fetchAll()
      message.success('Принято!')
    }
  })
}

const onClickRejectFund = (fund: Company) => {
  dialog.error({
    title: `Отклонить ${fund.title}?`,
    positiveText: 'Отклонить заявку',
    negativeText: 'Отмена',
    onPositiveClick: async () => {
      await axiosInstance.post('/funds/moderate', {fund_id: fund.id, status: false})
      await fetchAll()
      message.error('Заявка отклонена')
    }
  })
}

const filterQuery = ref('')
const filteredFunds = computed(() => {
  return fundsStore.funds.filter(c => c.title.toLowerCase().includes(filterQuery.value.toLowerCase()))
})

const fetchAll = async () => {
  await Promise.all([
    fundsStore.fetchFunds(),
    fundsStore.fetchFundsOnModeration(),
    fundsStore.fetchFundsRejected()
  ])
}

fetchAll()

const fundsColumns: DataTableColumn[] = [
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
    title: 'Заявка подана',
    key: 'requestedAt',
    sorter: (row1: any, row2: any) => row1.requestedAt - row2.requestedAt,
    render: (row: any, _) => {
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
              router.push('/funds/' + row.id)
            }
          },
          {default: () => 'Открыть фонд'}
      )
    }
  }
]
</script>

<style scoped>

</style>