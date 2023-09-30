<template>
  <div class="text-center">
    <h2 class="m-0 mb-3">Регистрация</h2>
    <p>
      Уже есть аккаунт?
      <router-link class="accent-text" to="/auth/login">Войти</router-link>
    </p>
  </div>

  <n-tabs type="segment">
    <n-tab-pane name="oasis" tab="Пользователь">
      <UserRegistration/>
    </n-tab-pane>
    <n-tab-pane name="the beatles" tab="Компания">
      <CompanyRegistration/>
    </n-tab-pane>
    <n-tab-pane name="jay chou" tab="Фонд">
      <FundRegistration/>
    </n-tab-pane>
  </n-tabs>
</template>

<script lang="ts" setup>
import UserRegistration from "@components/auth/UserRegistration.vue";
import CompanyRegistration from "@components/auth/CompanyRegistration.vue";
import FundRegistration from "@components/auth/FundRegistration.vue";
</script>

<style scoped>

</style>