<template>
  <n-layout style="height: 100vh">
    <n-layout-header bordered style="height: 64px; padding: 2px">
      <section class="container py-2 d-flex justify-content-between align-items-center">
        <router-link class="d-flex text-decoration-none" to="/">
          <div class="text-center my-auto lh-1 ms-2">
            <h1 class="app-title my-0">
              FitApp
            </h1>
          </div>
        </router-link>

        <menu class="m-0 p-0 d-flex gap-3">

        </menu>

        <div class="d-flex align-items-center">

        </div>
      </section>
    </n-layout-header>

    <n-layout
        has-sider
        position="absolute"
        style="top: 64px; bottom: 64px; height: calc(100% - 64px)"
    >
      <n-layout-sider
          show-trigger
          :native-scrollbar="false"
          bordered
          content-style="padding: 24px;"
      >
        <p v-for="i in 100">{{ i }}</p>
      </n-layout-sider>

      <n-layout
          :native-scrollbar="false"
      >
        <main style="min-height: calc(100vh - 64px)">
          <div class="d-flex flex-column">
            <main style="padding: 24px; min-height: calc(100vh - 151px)">
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
</script>
