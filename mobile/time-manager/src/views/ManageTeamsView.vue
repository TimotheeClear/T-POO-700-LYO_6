<script lang="ts">
import { defineComponent } from "vue";
import TeamsMgmt from "@/components/teams/TeamsMgmt.vue";

export default defineComponent({
  name: "ManageTeamsView",
  components: {
    TeamsMgmt,
  },
});
</script>

<template>
  <TeamsMgmt />
</template>
