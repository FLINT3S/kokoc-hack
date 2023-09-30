<template>
  <n-layout style="height: 100vh">
    <n-layout-header bordered style="height: 64px; padding: 2px">
      <section class="container py-2 px-3 d-flex justify-content-between align-items-center">
        <div class="text-center my-auto lh-1 ms-2" @click="$router.push('/')">
          <h1 class="app-title my-0">
            <CMLogo :icon-width="42" class="top-bar-logo"/>
          </h1>
        </div>

        <div class="d-flex align-items-center">
          <n-button @click="userStore.toggleTheme()">
            <n-icon v-if="userStore.theme === 'dark'" :component="LightModeFilled"/>
            <n-icon v-else :component="DarkModeFilled"/>
          </n-button>
        </div>
      </section>
    </n-layout-header>

    <n-layout
        has-sider
        position="absolute"
        style="top: 64px; bottom: 64px; height: calc(100% - 64px)"
    >
      <n-layout-sider
          v-model:collapsed="isMenuCollapsed"
          :collapsed-width="64"
          :native-scrollbar="false"
          bordered
          collapse-mode="width"
          content-style="height: 100%; display: flex; flex-direction: column"
          show-trigger
      >
        <SideMenu :collapsed="isMenuCollapsed"/>

        <div class="mt-auto p-2">
          <n-collapse-transition :show="!isMenuCollapsed">
            <n-button block type="error" @click="onClickLogout">
              Выйти

              <template #icon>
                <n-icon :component="LogOutFilled"/>
              </template>
            </n-button>
          </n-collapse-transition>
        </div>
      </n-layout-sider>

      <n-layout
          :native-scrollbar="false"
      >
        <main style="min-height: calc(100vh - 64px)">
          <div class="d-flex flex-column">
            <main style="padding: 12px; min-height: calc(100vh - 127px)">
              <slot></slot>
            </main>

            <n-layout-footer
                bordered
                class="py-1 px-3"
            >
              <div class="container py-1">
                <span class="fw-light">
                    Solution for Kokoc Hackathon created by flint3s. 2023
                </span>
              </div>
            </n-layout-footer>
          </div>

        </main>
      </n-layout>
    </n-layout>
  </n-layout>
</template>

<script lang="ts" setup>
import {ref} from 'vue'
import CMLogo from "@components/CMLogo.vue";
import SideMenu from "@components/menu/SideMenu.vue";
import {DarkModeFilled, LightModeFilled, LogOutFilled} from '@vicons/material'
import {userUserStore} from "@data/store/userStore.ts";

const userStore = userUserStore()

const isMenuCollapsed = ref(false);

const onClickLogout = () => {
  localStorage.clear()
  window.location.href = '/'
}
</script>

<style>
.top-bar-logo h1 {
  font-size: 24px;
}
</style>