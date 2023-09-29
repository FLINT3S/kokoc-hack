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
      Пользователь
    </n-tab-pane>
    <n-tab-pane name="the beatles" tab="Администратор">
      Администратор
    </n-tab-pane>
    <n-tab-pane name="jay chou" tab="Фонд">
      Фонд
    </n-tab-pane>
  </n-tabs>
</template>

<script lang="ts" setup>

</script>

<style scoped>

</style>