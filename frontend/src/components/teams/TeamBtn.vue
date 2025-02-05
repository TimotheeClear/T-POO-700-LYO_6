<script lang="ts">
import { defineComponent } from "vue";
import { useTeamMembersStore } from "@/stores/teamMembers";
import router from "@/router";
import Send from "@/helpers/sendRequest";

export default defineComponent({
	name: "TeamBtn",
	props: {
		teamId: {
			readonly: true,
			type: Number,
		},
		teamName: {
			readonly: true,
			type: String,
		},
	},
  emits: ["removeTeam", "displayTeamMgmt"],
	setup() {
		const teamMembersStore = useTeamMembersStore();
		return {
			teamMembersStore,
		};
	},
	data() {
		return {
			numberOfMembers: 0,
			teamMembers: [],
			displayTeamMembers: false,
		};
	},
	methods: {
		async getTeamData() {
			// Set current team name in store
			this.teamMembersStore.setCurrentTeam(this.teamId, this.teamName);
			// Get all teams for current user
			await this.teamMembersStore.fetchCurrentTeamMembers(this.teamId);
			// Update number of members
			this.numberOfMembers = this.teamMembersStore.getNumberTeamMembers;
			// Update team members
			this.teamMembers = this.teamMembersStore.currentTeamMembers;
		},
		hoverTeamMembers() {
			this.displayTeamMembers = true;
		},
		unhoverTeamMembers() {
			this.displayTeamMembers = false;
		},
		displayDashboards() {
			router.push(`/team/${this.teamId}`);
		},
    deleteTeam() {
      Send.deleteRequest<any>(`/teams/${this.teamId}`)
          .then((response) => {
            this.$emit("removeTeam", this.teamId);
          })
          .catch(function (error) {
            console.log(error);
          });
    },
    displayTeamMgmt() {
      this.$emit("displayTeamMgmt");
    }
	},
	mounted() {
		this.getTeamData();
	},
});
</script>

<template>
	<div class="team-list-cmp">
		<span class="team-title">{{ teamName }}</span>
		<span class="team-members" @mouseover="hoverTeamMembers" @mouseleave="unhoverTeamMembers"> {{ numberOfMembers }} members </span>
		<button
			class="team-edit-btn bg-color-green color-light"
			@click="
				getTeamData();
				displayTeamMgmt();
			"
		>
			Edit
		</button>
		<button class="team-dashboards-btn bg-color-sec-red color-light" @click="displayDashboards">Dashboards</button>
    <button class="team-delete-btn bg-color-sec-black color-light" @click="deleteTeam">Delete</button>
  </div>
	<div v-if="displayTeamMembers" class="team-hover-members-cmp">
		<div v-if="numberOfMembers > 0">
			<ul class="team-hover-list-members">
				<li v-for="member in teamMembers" :key="member.id">
					<span>{{ member.username }}</span>
				</li>
			</ul>
		</div>
		<div v-else class="team-hover-nomember">
			<span>There are no members in this team.</span>
		</div>
	</div>
</template>

<style>
.team-list-cmp {
	display: flex;
	flex-direction: row;
	justify-content: space-between;
	align-content: center;
	padding-bottom: 6px;
	margin-bottom: 10px;
	border-bottom: 2.5px #454955 solid;
}

.team-title {
	font-size: 1.4em;
	font-weight: 600;
	align-self: center;
}

.team-edit-btn {
	align-self: center;
	padding: 8px;
	border-radius: 8px;
	font-weight: bold;
}

.team-dashboards-btn {
	align-self: center;
	padding: 8px;
	border-radius: 8px;
	font-weight: bold;
}

.team-delete-btn {
  align-self: center;
  padding: 8px;
  border-radius: 8px;
  font-weight: bold;
}

.team-members {
	align-self: flex-end;
	padding-bottom: 5px;
}

.team-members:hover {
	font-weight: bold;
	cursor: pointer;
}

.team-edit-btn:hover {
	background-color: #72b01d;
}

.team-dashboards-btn:hover {
	background-color: #a43333;
}

.team-delete-btn:hover {
  background-color: #2f2b2b;
}

.team-hover-nomember {
	background-color: #454955;
	color: #f3eff5;
	padding: 2% 4% 2% 4%;
	font-weight: 600;
	box-shadow: 0px 0px 7px 0px rgba(0, 0, 0, 0.5);
	border-radius: 8px;
}

.team-hover-members-cmp {
	display: flex;
	flex-direction: row;
	justify-content: center;
}

.team-hover-list-members {
	padding: 12px 10px;
	display: flex;
	flex-direction: column;
	align-items: flex-start;
	border-radius: 8px;
	list-style-type: none;
	box-shadow: 0px 0px 7px 0px rgba(0, 0, 0, 0.5);
}
</style>
