<script lang="ts">
import { defineComponent } from "vue";
import Send from "@/helpers/sendRequest";
import router from "@/router";
import { useUserStore } from "@/stores/user";

export default defineComponent({
  name: "TeamMemberComponent",
  props: {
    memberId: {
      readonly: true,
      type: Number,
    },
    memberName: {
      readonly: true,
      type: String,
    },
    memberRoleId: {
      readonly: true,
      type: Number,
    },
    teamId: {
      readonly: true,
      type: Number,
    },
    method: { type: Function },
  },
  emits: ["removeMember"],
  setup() {
    const userStore = useUserStore();
    return {
      userStore,
    };
  },
  data() {
    return {
      removeUserSuccess: null,
      promoteUserSuccess: null,
      deleteUserSuccess: null,
      snackbar: false,
      snackbarText: "",
      snackbarColor: "green",
    };
  },
  computed: {
    toStatus() {
      switch (this.memberRoleId) {
        case 1:
          return "employee";
        case 2:
          return "manager";
        case 3:
          return "general manager";
        default:
          return "employee";
      }
    },
  },
  methods: {
    async removeUser() {
      try {
        await Send.deleteRequest(
          `/teams/${this.teamId}/users/${this.memberId}`
        );
        this.$emit("removeMember", this.memberId);
        this.removeUserSuccess = true;
      } catch (err) {
        this.removeUserSuccess = false;
      }
    },
    async promoteUser() {
      try {
        await Send.patchRequest(`/users/${this.memberId}`, { role_id: 2 });
        this.snackbarColor = "green";
        this.snackbar = true;
        this.snackbarText = "You just promoted user.";
        this.promoteUserSuccess = true;
      } catch (err) {
        this.promoteUserSuccess = false;
      }
    },
    async downgradeUser() {
      try {
        await Send.patchRequest(`/users/${this.memberId}`, { role_id: 1 });
        this.snackbarColor = "green";
        this.snackbar = true;
        this.snackbarText = "You just downgraded user.";
        this.promoteUserSuccess = true;
      } catch (err) {
        this.promoteUserSuccess = false;
      }
    },
    async deleteUser() {
      try {
        await Send.deleteRequest(`/users/${this.memberId}`);
        this.$emit("removeMember", this.memberId);
        this.deleteUserSuccess = true;
      } catch (err) {
        this.deleteUserSuccess = false;
      }
    },
    goToUser() {
      router.push(`/profile/${this.memberId}`);
    },
  },
});
</script>

<template>
  <div class="member-cmp">
    <span class="member-name">
      <a class="member-name-link" href="#" @click="goToUser">
        {{ memberName }}
      </a>
    </span>
    <span class="member-status">{{ toStatus }}</span>
    <button
      v-if="memberRoleId === 1 && userStore.getUserRole === 3"
      class="member-promote-btn bg-color-green color-light"
      @click="promoteUser"
    >
      Promote
    </button>
    <button
      v-if="memberRoleId === 2 && userStore.getUserRole === 3"
      class="member-downgrade-btn bg-color-sec-light color-sec-dark"
      @click="downgradeUser"
    >
      Downgrade
    </button>
    <button
      class="member-remove-btn bg-color-sec-dark color-sec-light"
      @click="removeUser"
    >
      Remove
    </button>
    <button
      v-if="userStore.getUserRole === 3"
      class="member-delete-btn bg-color-sec-red color-sec-light"
      @click="deleteUser"
    >
      Delete
    </button>
  </div>
  <div v-if="removeUserSuccess !== null">
    <span v-if="removeUserSuccess"
      >User {{ memberName }} was removed successfully.</span
    >
    <span v-else>User {{ memberName }} could not be removed.</span>
  </div>
  <v-snackbar v-model="snackbar" :color="snackbarColor">{{ snackbarText }}</v-snackbar>
</template>

<style>
.member-cmp {
  display: grid;
  grid-template-columns: repeat(5, 20%);
  padding-bottom: 6px;
  border-bottom: 2.5px #454955 solid;
}

.member-name {
  grid-column-start: 1;
  grid-column-end: 2;
  justify-self: start;
  font-weight: bold;
}

.member-name-link {
  color: #454955;
  font-size: 1em;
  text-decoration: none;
}

.member-name-link:hover {
  color: #72b01d;
  text-decoration: underline;
}

.member-status {
  grid-column-start: 2;
  grid-column-end: 3;
  justify-self: start;
}

.member-promote-btn {
  justify-self: center;
  padding: 3% 10% 3% 10%;
  grid-column-start: 3;
  grid-column-end: 4;
  border-radius: 8px;
  font-weight: bold;
}

.member-promote-btn:hover {
  background-color: #72b01d;
}

.member-downgrade-btn {
  justify-self: center;
  padding: 3% 10% 3% 10%;
  grid-column-start: 3;
  grid-column-end: 4;
  border-radius: 8px;
  font-weight: bold;
}

.member-downgrade-btn:hover {
  background-color: #0d0a0b;
  color: #fcfcfc;
}

.member-remove-btn {
  justify-self: center;
  padding: 3% 10% 3% 10%;
  grid-column-start: 4;
  grid-column-end: 5;
  border-radius: 8px;
  font-weight: bold;
}

.member-remove-btn:hover {
  background-color: #0d0a0b;
  color: #fcfcfc;
}

.member-delete-btn {
  justify-self: center;
  padding: 3% 10% 3% 10%;
  grid-column-start: 5;
  grid-column-end: 6;
  border-radius: 8px;
  font-weight: bold;
}

.member-delete-btn:hover {
  background-color: #ce1010;
  color: #fcfcfc;
}
</style>
