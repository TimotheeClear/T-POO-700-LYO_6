<script lang="ts">
import { defineComponent } from "vue";
import ClockTrigger from "@/components/clocks/ClockTrigger.vue";

export default defineComponent({
  name: "HomeView",
  components: {
    ClockTrigger,
  },
});
</script>

<style lang="scss">
.container {
  padding: 1rem;
}
ClockTrigger {
  columns: 1/3;
}
</style>

<template>
  <div class="container">
    <ClockTrigger />
  </div>
</template>

