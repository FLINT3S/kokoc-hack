<template>
  <div class="auth-page">
    <n-card class="card-md">
      <CMLogo/>

      <router-view/>
    </n-card>
  </div>
</template>

<script lang="ts" setup>
import CMLogo from "@components/CMLogo.vue";
</script>

<style scoped>
.auth-page {
  height: calc(100vh - 24px);
  padding: 12px;
  display: flex;
  justify-content: center;
  align-items: center;
}
</style>