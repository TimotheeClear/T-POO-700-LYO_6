<template>
  <nav class="nav-cmp">
    <div class="nav-menu">
      <router-link to="/" class="nav-txt">Home</router-link>
    </div>
    <div class="nav-menu">
      <router-link
          to="/manage_team"
          class="nav-txt"
          v-if="userStore.isUserConnected && userStore.getUserRole !== 1"
      >Teams
      </router-link
      >
    </div>
    <div v-if="userStore.isUserConnected" class="nav-menu">
      <router-link :to="'/profile/' + userStore.getUserId" class="nav-txt"
      >Profile
      </router-link
      >
      <a @click="disconnect" href="#" class="nav-txt">Logout</a>
    </div>
    <div v-else class="nav-menu">
      <router-link to="/login" class="nav-txt">Login</router-link>
    </div>
  </nav>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import { useUserStore } from "@/stores/user";

export default defineComponent({
  name: "NavBarComponent",
  methods: {
    disconnect() {
      localStorage.removeItem("user");
      localStorage.removeItem("token");
      this.userStore.$reset();
    },
  },
  setup() {
    const userStore = useUserStore();
    return {
      userStore,
    };
  },
});
</script>

<style>
.nav-cmp {
  display: flex;
  width: 100%;
  flex-direction: row;
  justify-content: space-around;
  position: fixed;
  z-index: 2;
  background-color: #fcfcfc;
  box-shadow: 0 0 7px 0 rgba(0, 0, 0, 0.5);
}

.nav-txt {
  text-decoration: none;
  font-weight: bold;
}
</style>
