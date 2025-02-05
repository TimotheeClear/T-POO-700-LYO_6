<script lang="ts">
import { defineComponent } from "vue";
import NavBar from "./components/navBar/NavBar.vue";

export default defineComponent({
  name: "AppView",
  components: {
    NavBar,
  },
});
</script>

<template>
  <header class="main-header">
    <NavBar />
  </header>
  <main class="main-wrapper bg-color-light">
    <router-view></router-view>
  </main>
</template>

<style lang="scss">
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #0d0a0b;
  min-height: 100vh;
  background-color: #fcfcfc;
}

body {
  margin: 0;
}

.main-wrapper {
  display: flex;
  flex-direction: column;
  padding-top: 5em;
  width: 100%;
}

h1 {
  margin-left: 3rem;
}

a {
  padding: 1rem;
  font-weight: bold;
  font-size: 25px;
  text-decoration: none;
  color: #fcfcfc;
}

nav {
  padding: 15px;

  a {
    font-weight: bold;
    font-size: 1em;
    color: #0d0a0b;

    &.router-link-exact-active {
      color: #3f7d20;
    }
  }
}
</style>
