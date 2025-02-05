<template>
	<v-card elevation="4">
		<v-row>
			<v-col>
				<div class="column" style="width: 100%">
					<v-select
						style="margin: 10px"
						label="Charts"
						v-model="selectedChart"
						:items="['Line', 'Bar']"
						variant="solo"
					></v-select>
					<v-select
						v-if="teamId >= 0"
						style="margin: 10px"
						label="All Users"
						@update:modelValue="onChange"
						:items="Allusers"
						item-title="name"
						variant="solo"
					>
					</v-select>
				</div>
			</v-col>
		</v-row>
		<v-row
			><v-col>
				<LineChart v-if="selectedChart === 'Line'" :ArrayData="chartData" :bool="bool" />
				<BarChart v-if="selectedChart === 'Bar'" :ArrayData="chartData" :bool="bool" />
			</v-col>
		</v-row>
	</v-card>
</template>

<script lang="ts">
import { userChartStore } from "@/stores/usersCharts";
import { useRoute } from "vue-router";
import LineChart from "./LineChart.vue";
import BarChart from "./BarChart.vue";
export default {
	name: "ChartManager",
	components: {
		LineChart,
		BarChart,
	},
	props: {
		Allusers: { type: Array },
		AllUsersData: { type: Array },
	},
  setup() {
		const userStore = userChartStore();
		return { userStore };
	},
	watch: {
		AllUsersData(n) {
      this.allData = n;
      this.chartData = n;
		},
	},
	data() {
		const route = useRoute();
		const id = route.params.teamid;
		return {
			user: JSON.parse(localStorage.getItem("user")),
			teamId: Number(id),
			selectedChart: "Line",
			bool: true,
			chartData: null,
			allData: null,
		};
	},
	methods: {
		onChange(changedUser) {
			if (changedUser === "All Users") {
				this.userStore.setUsers(null);
				this.chartData = this.allData;
			} else {
				this.userStore.setUsers(changedUser);
				this.bool ? (this.bool = false) : (this.bool = true);
				this.chartData = this.allData.filter((v) => v.User === changedUser);
			}
		},
	},
};
</script>
<style scoped>
.v-card {
	padding: 1rem;
}
.column {
	display: flex;
}
</style>
