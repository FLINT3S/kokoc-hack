<template>
  <div>
    <h2 class="text-center">Компания «{{ companyName }}»</h2>

    <div class="d-flex justify-content-end my-3">
      <n-button type="primary" secondary @click="isAddDivisionModalShown = true">
        Добавить подразделение
      </n-button>
    </div>

    <n-data-table :columns="divisionsColumns" :data="divisions" :pagination="{pageSize: 10}" :loading="isDivisionLoading"/>

    <n-modal v-model:show="isAddDivisionModalShown" closable :loading="isDivisionLoading">
      <n-card class="card-md" title="Добавить подразделение" closable @close="isAddDivisionModalShown = false">
        <n-input placeholder="Название дивизиона" v-model:value="createDivisionTitle"/>

        <template #action>
          <n-space>
            <n-button type="primary" :disabled="createDivisionTitle === ''" @click="onClickAddDivision">
              Добавить
            </n-button>

            <n-button @click="isAddDivisionModalShown = false">
              Отменить
            </n-button>
          </n-space>
        </template>
      </n-card>
    </n-modal>
  </div>
</template>

<script lang="ts" setup>
import {computed, h, ref} from 'vue';
import {useUserStore} from "@data/store/userStore.ts";
import {Company} from "@data/types/company.ts";
import {DataTableColumn, NButton} from "naive-ui";
import {router} from "@/app/router";
import {axiosInstance} from "@data/api/axiosInstance.ts";
import {Division} from "@data/types/division.ts";
import {useRoute} from "vue-router";

const userStore = useUserStore()
const route = useRoute()

const mode = ref<any | null>(userStore.currentUser!.role)
const companyItem = ref<Company | null>(null)
const divisions = ref<Division[]>([])

const createDivisionTitle = ref('')
const isAddDivisionModalShown = ref(false)
const isDivisionLoading = ref(false)

const onClickAddDivision = async () => {
  isDivisionLoading.value = true
  await axiosInstance.post('/divisions/create', {title: createDivisionTitle.value, company_id: companyId.value})
  await loadDivisions()
  isDivisionLoading.value = false

  isAddDivisionModalShown.value = false
  createDivisionTitle.value = ''
}

const companyName = computed(() => {
  if (mode.value === 'superadmin') {
    return companyItem.value?.title
  } else {
    return userStore.currentUser!.company?.title
  }
})

const companyId = computed(() => {
  if (mode.value === 'superadmin') {
    return route.params.id
  } else {
    return userStore.currentUser!.company?.id
  }
})

const loadCompany = async () => {
  isDivisionLoading.value = true
  companyItem.value = (await axiosInstance.get('/companies/get/' + companyId.value)).data as Company
  isDivisionLoading.value = false
}

const loadDivisions = async () => {
  isDivisionLoading.value = true
  divisions.value = (await axiosInstance.get('/divisions/get-all/' + companyId.value)).data as Division[]
  isDivisionLoading.value = false
}

loadCompany()
loadDivisions()


const divisionsColumns: DataTableColumn[] = [
  {
    title: '#',
    key: 'index',
    render: (_, i) => {
      return `${i + 1}`
    }
  },
  {
    title: 'Название',
    key: 'title'
  },
  {
    title: 'Количество сотрудников',
    key: 'employeeCount'
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
              if (mode.value === 'superuser') {
                router.push('/division/' + companyItem.value?.id + '/' + row.id)
              } else {
                router.push('/mycompany/' + companyItem.value?.id + '/' + row.id)
              }
            }
          },
          {default: () => 'Открыть подразделение'}
      )
    }
  }
]
</script>

<style scoped>

</style>