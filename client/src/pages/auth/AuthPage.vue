<template>
  <n-layout class="auth-page">
    <n-card class="card-md">
      <CMLogo/>

      <router-view/>
    </n-card>
  </n-layout>
</template>

<script lang="ts" setup>
import CMLogo from "@components/CMLogo.vue";
</script>

<style scoped>
.auth-page {
  min-height: 100vh;
  padding: 12px;
  display: flex;
  justify-content: center;
  align-items: center;
}
</style>