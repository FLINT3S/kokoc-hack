<template>
  <div class="content-container">
    <div v-if="mode === 'companyadmin'">
      <div class="d-flex flex-column flex-md-row mb-4 justify-content-between align-items-center">
        <h2>Компания «{{userStore.currentUser?.company?.title}}»</h2>
        <n-button type="primary" secondary>Настройки компании</n-button>
      </div>

      <n-grid cols="1 400:2 800:4" x-gap="10" y-gap="10">
        <n-gi v-for="s in stats">
          <n-card class="h-100" :title="s.header">
            <h1 class="m-0">{{ s.value }}</h1>
          </n-card>
        </n-gi>
      </n-grid>

      <n-divider/>

      <h3>Активность сотрудников</h3>

    </div>
  </div>
</template>

<script lang="ts" setup>
import {useUserStore} from "@data/store/userStore.ts";

const userStore = useUserStore()

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
</script>

<style scoped>

</style>