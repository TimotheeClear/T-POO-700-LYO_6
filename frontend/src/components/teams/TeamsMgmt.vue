<script lang="ts">
import TeamsList from "./TeamsList.vue";
import TeamMgmt from "./TeamMgmt.vue";
import { defineComponent } from "vue";

export default defineComponent({
	name: "TeamsMgmtComponent",
	components: {
		TeamsList,
		TeamMgmt,
	},
	data() {
		return {
			displayTeamMgmt: false,
		};
	},
  methods: {
    displayTeamMgmtTrue() {
      this.displayTeamMgmt = true;
    },
    displayTeamMgmtFalse() {
      this.displayTeamMgmt = false;
    }
  }
});
</script>

<template>
	<div class="teams-mgmt-cmp bg-color-light">
		<div class="teams-mgmt-list">
			<TeamsList @displayTeamMgmt="displayTeamMgmtTrue" />
		</div>
		<div v-if="displayTeamMgmt" class="team-selected-mgmt">
			<TeamMgmt @displayTeamMgmt="displayTeamMgmtFalse" />
		</div>
	</div>
</template>

<style>
.teams-mgmt-cmp {
	margin-left: 3%;
	margin-right: 3%;
	margin-bottom: 18%;
	display: flex;
	flex-direction: row;
	gap: 5%;
	justify-content: space-around;
}

.teams-mgmt-list {
	min-width: 30%;
	flex-shrink: 1;
}

.team-selected-mgmt {
	flex-grow: 2;
}
</style>
