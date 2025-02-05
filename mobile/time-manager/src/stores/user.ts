import { defineStore } from "pinia";

export const useUserStore = defineStore("user", {
  state: () => ({
    user: JSON.parse(localStorage.getItem("user")) || null,
    token: localStorage.getItem("token") || null,
    disallowedRoutes: [],
  }),
  getters: {
    isUserConnected() {
      return this.user ? true : false;
    },
    getUserName() {
      return this.user.username;
    },
    getUserMail() {
      return this.user.email;
    },
    getUserId() {
      return this.user.id;
    },
    getUserRole() {
      return this.user.role_id;
    },
    getDisallowedRoutes() {
      if (this.user.role_id === 1) {
        this.disallowedRoutes = ["team", "manage_team"];
      }
      return this.disallowedRoutes;
    },
  },
  actions: {
    connectUser() {
      this.userConnected = !this.userConnected;
      this.token = localStorage.getItem("token");
      this.user = JSON.parse(localStorage.getItem("user"));
    },
  },
});
