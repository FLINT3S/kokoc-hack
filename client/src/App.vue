<template>
  <n-config-provider
      :date-locale="dateRuRU"
      :locale="ruRU"
      :theme="appTheme"
      :theme-overrides="themeOverrides"
  >
    <n-dialog-provider>
      <n-message-provider>
        <transition mode="out-in" name="fade">
          <component :is="layout">
            <router-view v-slot="{ Component }">
              <component :is="Component"/>
            </router-view>
          </component>
        </transition>
      </n-message-provider>
    </n-dialog-provider>
  </n-config-provider>
</template>

<script lang="ts" setup>
import {type Component, computed} from "vue";
import {useRoute, useRouter} from "vue-router";
import {darkTheme, dateRuRU, lightTheme, ruRU} from "naive-ui";

import themeOverrides from "@/app/style/naive-ui-theme-overrides.json"
import EmptyLayout from "@components/layout/EmptyLayout.vue";
import {useUserStore} from "@data/store/userStore.ts";

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()


const layout = computed(() => {
  return route.meta?.layout as Component ?? EmptyLayout
})

const appTheme = computed(() => {
  return userStore.theme === 'light' ? lightTheme : darkTheme
})

userStore.initTheme()

onMounted(async () => {
  if (!await userStore.initUser()) {
    await router.replace('/auth')
  }
})
</script>

