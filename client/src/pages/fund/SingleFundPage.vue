<template>
  <h2>Фонд «{{fund?.title}}»</h2>
</template>

<script setup lang="ts">
import {useRoute} from "vue-router";
import {axiosInstance} from "@data/api/axiosInstance.ts";

const route = useRoute()
const fund = ref<any>(null)

const loadFundInfo = async () => {
  fund.value = (await axiosInstance.get('/funds/get/' + route.params.id)).data
}

loadFundInfo()
</script>

<style scoped>

</style>