<template>
  <div class="login">
    <User type="Log In" />
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
.login {
  display: flex;
  justify-content: center;
  align-items: center;
}
</style>
