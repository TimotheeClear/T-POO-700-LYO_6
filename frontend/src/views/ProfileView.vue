<template>
  <div class="profile">
    <User type="User Info" :routeUserId="route" />
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import User from "@/components/User.vue"; // @ is an alias to /src

export default defineComponent({
  name: "ProfileView",
  components: {
    User,
  },
  data() {
    return {
      route: parseInt(this.$route.params.user_id as string),
    };
  },
});
</script>

<style lang="scss">
.profile {
  margin: 0 auto;
}
</style>
