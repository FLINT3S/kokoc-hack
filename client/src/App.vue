<template>
  <n-theme-editor>
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
                <transition :name="transitionName" mode="out-in">
                  <component :is="Component"/>
                </transition>
              </router-view>
            </component>
          </transition>
        </n-message-provider>
      </n-dialog-provider>
    </n-config-provider>
  </n-theme-editor>
</template>

<script lang="ts" setup>
import {type Component, computed} from "vue";
import {useRoute} from "vue-router";
import {darkTheme, dateRuRU, lightTheme, ruRU} from "naive-ui";

import themeOverrides from "@/app/style/naive-ui-theme-overrides.json"
import EmptyLayout from "@components/layout/EmptyLayout.vue";

const route = useRoute()

const layout = computed(() => {
  return route.meta?.layout as Component ?? EmptyLayout
})

const transitionName = computed(() => {
  return layout.value === EmptyLayout ? '' : 'fade'
})

const appTheme = computed(() => {
  return 'light' === 'light' ? lightTheme : darkTheme
})
</script>

