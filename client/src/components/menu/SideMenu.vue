<template>
  <n-menu
      :collapsed-icon-size="22"
      :collapsed-width="64"
      :collapsed="collapsed"
      :value="$route.path.split('/')[1]"
      :options="menuOptionsFiltered"
  />
</template>

<script lang="ts" setup>
import {menuOptions} from "@data/menuData.ts";
import {computed} from "vue";
import {userUserStore} from "@data/store/userStore.ts";

defineProps<{collapsed: boolean}>()

const userStore = userUserStore();

const menuOptionsFiltered = computed(() => {
  return menuOptions.filter((m) => m.roles.includes(userStore.currentUser?.role || ''))
})
</script>

<style scoped>

</style>