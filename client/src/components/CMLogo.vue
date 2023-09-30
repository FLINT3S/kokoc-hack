<template>
  <div class="d-flex align-items-center justify-content-center cm-logo">
    <img v-if="userStore.theme === 'light'" alt="" src="../assets/logo-dark.svg" :width="iconWidth">
    <img v-else alt="" src="../assets/logo.svg" :width="iconWidth">

    <h1 class="ms-2 my-0"><span class="accent-text">Charity</span> Motion</h1>
  </div>
</template>

<script setup lang="ts">
import {useUserStore} from "@data/store/userStore.ts";

withDefaults(defineProps<{
  iconWidth?: number
}>(), {
  iconWidth: 56
})

const userStore = useUserStore()
</script>

<style>
.cm-logo {
  cursor: pointer;
}
</style>