<script lang="ts">
import { defineComponent } from "vue";
import { useUserStore } from "@/stores/user";
import TeamBtn from "./TeamBtn.vue";
import Send from "../../helpers/sendRequest";
import TeamUser from "@/types/TeamUser";

export default defineComponent({
  name: "TeamsList",
  components: {
    TeamBtn,
  },
  setup() {
    const userStore = useUserStore();
    return {
      userStore,
    };
  },
  data() {
    return {
      teams: [],
      teamName: "",
    };
  },
  emits: ['displayTeamMgmt'],
  async mounted() {
    // User is manager
    if (this.userStore.getUserRole === 2) {
      // Get all teams for current user
      const { data } = await Send.getRequest(
          `/teams/users/${this.userStore.getUserId}`
      );
      this.teams = data.data;
      // User is general manager
    } else if (this.userStore.getUserRole === 3) {
      const { data } = await Send.getRequest("/teams");
      this.teams = data.data;
    }
  },
  methods: {
    createTeam() {
      Send.postRequest<any>("/teams", {
        name: this.teamName,
      })
          .then((response) => {
            Send.postRequest<TeamUser>(
                `/teams/${response.data.data.id}/users/${this.userStore.getUserId}`
            );
            this.teams.push(response.data.data);
          })
          .catch(function (error) {
            console.log(error);
          });
    },
    removeTeam(teamId) {
      this.teams = this.teams.filter((t) => t.id !== teamId);
    },
    displayTeamMgmt() {
      this.$emit('displayTeamMgmt');
    }
  },
});
</script>

<template>
  <div class="teams-list-wrapper">
    <h1 class="teams-list-title">Teams</h1>
    <p v-if="teams.length === 0">You have no teams yet</p>
    <ul v-else class="teams-list">
      <li v-for="team in teams" :key="team.id">
        <TeamBtn
            :teamId="team.id"
            :teamName="team.name"
            @displayTeamMgmt="displayTeamMgmt"
            @removeTeam="removeTeam"
        />
      </li>
    </ul>
  </div>
  <div class="create">
    <label>Team name: </label>
    <input class="team-input" v-model="teamName" />
    <button
        class="create-team-button team-edit-btn bg-color-green color-light"
        @click="createTeam"
    >
      Create Team
    </button>
  </div>
</template>

<style>
.teams-list-wrapper {
  padding-bottom: 3em;
  padding-top: 50px;
  box-shadow: 0 0 7px 0 rgba(0, 0, 0, 0.5);
  border-radius: 8px;
}

.teams-list {
  padding-left: 5%;
  padding-right: 5%;
  list-style-type: none;
  display: flex;
  flex-direction: column;
  gap: 30px;
}

.teams-list-title {
  margin-left: 0;
  margin-bottom: 13%;
}

.create-team-button {
  margin-top: 2rem;
}

.team-input {
  border: 1px solid black;
  margin: 10px;
}

.create {
  margin: 2rem 0;
}
</style>
