<template>
  <div v-if="employee">
    <h2>Пользователь {{employee.name}} {{employee.surname}}</h2>

    <h3>Список активностей</h3>

    <n-collapse>
      <!-- @vue-ignore @ts-ignore -->
      <n-collapse-item v-for="r in requests" :title="`Тренировка ${new Date(r.date).toLocaleDateString()}: [${trainingTypeMap[r.training_information.type]}] - ${r.training_information[intensityMap[r.training_information.type]]} ${r.training_information.duration}`">
        <img v-for="img in r.images" :src="'https://kokoc.flint3s.ru/' + img" width="200" height="200" class="object-fit-cover ms-3" alt="">
      </n-collapse-item>
    </n-collapse>
  </div>
</template>

<script lang="ts" setup>
import {axiosInstance} from "@data/api/axiosInstance.ts";
import {useRoute} from "vue-router";

const employee = ref<{ name: string, surname: string } | null>(null)
const requests = ref<{date: string, images: string[], training_information: { type: 'run' | 'strength' | 'bicycle' | 'swim', duration: number }}[]>([])
const route = useRoute()

const trainingTypeMap = {
  'run': 'бег',
  'strength': 'силовые упражнения',
  'bicycle': 'велосипед',
  'swim': 'плавание',
}

const intensityMap = {
  'run': 'runIntensity',
  'strength': 'strengthIntensity',
  'bicycle': 'bicycleIntensity',
  'swim': 'swimStyle',
}

const loadEmployeeInfo = async () => {
  employee.value = (await axiosInstance.get('employees/get-employee-by-id/' + route.params.id)).data;
}

const loadRequests = async () => {
  requests.value = (await axiosInstance.get('activities/get-activities-request-by-employee/' + route.params.id)).data.map((r: any) => ({
    date: r.date,
    training_information: JSON.parse(r.training_information),
    images: JSON.parse(r.images),
  }));
  console.log(requests.value)
}


loadEmployeeInfo()
loadRequests()
</script>

<style scoped>

</style>