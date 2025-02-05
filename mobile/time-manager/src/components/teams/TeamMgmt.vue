<script lang="ts">
import { useTeamMembersStore } from "@/stores/teamMembers";
import { useUserStore } from "@/stores/user";
import { defineComponent } from "vue";
import TeamMember from "./TeamMember.vue";
import Send from "../../helpers/sendRequest";
import User from "@/types/User";
import CloseIcon from "@/assets/icons/Close.png";
import TeamUser from "@/types/TeamUser";

export default defineComponent({
  name: "TeamMgmtComponent",
  components: {
    TeamMember,
  },
  setup() {
    const teamMembersStore = useTeamMembersStore();
    const userStore = useUserStore();
    return {
      teamMembersStore,
      userStore,
    };
  },
  data() {
    return {
      memberForm: false,
      allEmployees: [],
      userToDelete: null,
      selectedUserName: null,
      addUserSuccess: null,
      closeIcon: CloseIcon,
    };
  },
  methods: {
    displayMemberForm() {
      this.memberForm = !this.memberForm;
    },
    async fetchAllUsers(): Promise<void> {
      if (this.userStore.getUserRole === 2) {
        const { data } = await Send.getRequest("users/roles/1");
        this.allEmployees = data.data;
      } else if (this.userStore.getUserRole === 3) {
        const dataEmployees = await Send.getRequest<User[]>("users/roles/1");
        const dataManagers = await Send.getRequest<User[]>("users/roles/2");
        this.allEmployees = [
          ...dataEmployees.data.data,
          ...dataManagers.data.data,
        ];
      }
    },
    async addMemberToTeam(): Promise<void> {
      console.log(this.selectedUserName);
      try {
        const { data } = await Send.postRequest<TeamUser>(
          `/teams/${this.teamMembersStore.currentTeamId}/users/${this.selectedUserName}`
        );
        const response = await Send.getRequest<User>(
          `/users/${data.data.user_id}`
        );
        this.teamMembersStore.addTeamMember(response.data.data);
        this.addUserSuccess = true;
      } catch (err) {
        this.addUserSuccess = false;
      }
    },
    removeMember(memberId) {
      this.teamMembersStore.removeTeamMember(memberId);
    },
  },
  computed: {
    membersName() {
      return this.allEmployees.map((employee: User) => employee.username);
    },
  },
});
</script>

<template>
  <div class="team-mgmt-wrapper">
    <div class="team-mgmt-close-btn">
      <button class="team-mgmt-close-icon" @click="$emit('displayTeamMgmt')">
        <img :src="closeIcon" alt="Close" width="15" />
      </button>
    </div>
    <h1 class="team-mgmt-title">
      {{ this.teamMembersStore.currentTeamName }}
    </h1>
    <ul class="team-mgmt-members-list">
      <li
        v-for="member in this.teamMembersStore.currentTeamMembers"
        :key="member.id"
      >
        <TeamMember
          :memberId="member.id"
          :memberName="member.username"
          :memberRoleId="member.role_id"
          :teamId="teamMembersStore.currentTeamId"
          @removeMember="removeMember"
        />
      </li>
    </ul>
    <div class="team-mgmt-add-wrapper">
      <button
        v-if="!memberForm"
        class="team-mgmt-add-btn bg-color-green color-light"
        @click="
          displayMemberForm();
          fetchAllUsers();
        "
      >
        Add a member
      </button>
      <div class="team-mgmt-add-form" v-if="memberForm">
        <form>
          <select v-model="selectedUserName">
            <option v-for="option in allEmployees" :value="option.id" :key="option.id">
              {{ option.username }}
            </option>
          </select>
        </form>
      </div>
      <button
        v-if="memberForm"
        class="team-mgmt-add-btn bg-color-green color-light"
        @click="addMemberToTeam"
      >
        Add to team
      </button>
    </div>
    <div v-if="addUserSuccess !== null" class="team-mgmt-add-alert">
      <span v-if="addUserSuccess === true"
        >User {{ selectedUserName.username }} was successfully added to
        {{ this.teamMembersStore.currentTeamName }}</span
      >
      <span v-else
        >Could not add {{ selectedUserName.username }} to
        {{ this.teamMembersStore.currentTeamName }}</span
      >
    </div>
  </div>
</template>

<style>
.team-mgmt-wrapper {
  padding-left: 5%;
  padding-right: 5%;
  padding-top: 30px;
  padding-bottom: 50px;
  box-shadow: 0px 0px 7px 0px rgba(0, 0, 0, 0.5);
  border-radius: 8px;
}

.team-mgmt-close-btn {
  display: flex;
  flex-direction: row-reverse;
}

.team-mgmt-close-icon {
  border-bottom: 2.5px #fcfcfc solid;
}

.team-mgmt-close-icon:hover {
  border-bottom: 2.5px #454955 solid;
}

.team-mgmt-members-list {
  padding: 0;
  padding-top: 50px;
  list-style-type: none;
  display: flex;
  flex-direction: column;
  gap: 30px;
}

.team-mgmt-title {
  margin-left: 0;
  margin-bottom: 10%;
}

.team-mgmt-add-wrapper {
  display: flex;
  flex-direction: row;
  justify-content: center;
  gap: 10%;
}

.team-mgmt-add-btn {
  padding: 1% 1% 1% 1%;
  border-radius: 8px;
  background-color: #72b01d;
  font-weight: bold;
  flex-shrink: 1;
}

.team-mgmt-add-btn:hover {
  background-color: #72b01d;
}

.team-mgmt-add-form {
  flex-grow: 2;
}
</style>
