<template>
  <div class="register">
    <User type="Register" />
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import User from "@/components/User.vue"; // @ is an alias to /src

export default defineComponent({
  name: "LoginView",
  components: {
    User,
  },
});
</script>

<style lang="scss">
.register {
  display: flex;
  justify-content: center;
  align-items: center;
}
</style>
