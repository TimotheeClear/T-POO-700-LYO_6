<script lang="ts">
import { defineComponent } from "vue";
import ClockTrigger from "@/components/clocks/ClockTrigger.vue";
// import ChartManager from "@/components/charts/ChartManager.vue"; // @ is an alias to /src
// import WorkingTimes from "@/components/workingTime/WorkingTimes.vue"; // @ is an alias to /src

export default defineComponent({
  name: "HomeView",
  components: {
    // ChartManager,
    ClockTrigger,
    // WorkingTimes,
  },
});
</script>

<style lang="scss">
.v-container {
  padding: 1rem;
  //margin-top: 1rem;
}
ClockTrigger {
  columns: 1/3;
}
</style>

<template>
  <v-container class="grey lighten-5">
    <ClockTrigger />
    <!--    <v-row no-gutters>-->
    <!--      <v-col sm="7" class="ml-auto" style="margin-left: 10px">-->
    <!--        <ChartManager style="margin-bottom: 20px" />-->
    <!--        <WorkingTimes style="margin-top: 20px" />-->
    <!--      </v-col>-->
    <!--    </v-row>-->
  </v-container>
</template>
