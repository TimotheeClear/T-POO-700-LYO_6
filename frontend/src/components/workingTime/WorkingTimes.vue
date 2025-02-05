<template>
	<Dialog :dilog="dialog" :userData="memberData" :action="action" :users="users" @addData="addWK" @updateData="updateWK" />
	<v-snackbar v-model="snackbar" :color="snackbarColor">{{ snackbarText }}</v-snackbar>
	<v-card elevation="4">
		<v-card-title>
			Working Times
			<v-btn
				v-if="user.role_id > 1"
				style="position: absolute; right: 0"
				prepend-icon="mdi-plus"
				append-icon="mdi-plus"
				depressed
				elevation="4"
				color="green"
				x-large
				@click="add()"
				>Add</v-btn
			>
		</v-card-title>
		<table id="tableComponent" class="table table-bordered table-striped">
			<thead>
				<tr>
					<!-- loop through each value of the fields to get the table header -->
					<th v-for="field in fields" :key="field">{{ field }} <i class="bi bi-sort-alpha-down" aria-label="Sort Icon"></i></th>
					<th v-if="user.role_id > 1">Action <i class="bi bi-sort-alpha-down" aria-label="Sort Icon"></i></th>
				</tr>
			</thead>
			<tbody>
				<!-- Loop through the list get the each student data -->
				<tr v-for="item in employeesData" :key="item.ID">
					<td v-for="field in fields" :key="field">{{ item[field] }}</td>
					<td v-if="user.role_id > 1">
						<v-btn depressed elevation="2" color="yellow" large @click="update(item)" icon>
							<v-icon color="white">mdi-pencil</v-icon>
						</v-btn>
						<v-btn depressed elevation="2" large color="red" icon @click="deleteWorkingTime(item)">
							<v-icon color="white">mdi-delete</v-icon>
						</v-btn>
					</td>
				</tr>
			</tbody>
		</table>
	</v-card>
</template>
<script lang="ts">
import Dialog from "./WorkingTimeDialog.vue";
import Swal from "sweetalert2";
import { useRoute } from "vue-router";
import { userChartStore } from "../../stores/usersCharts";
import { watch } from "vue";
import Send from "@/helpers/sendRequest";

export default {
	name: "WorkingTimes",
	components: {
		Dialog,
	},
	props: {
		Allusers: { type: Array },
		AllusersData: { type: Array },
	},
	setup() {
		const userStore = userChartStore();

		return { userStore };
	},
	watch: {
		AllusersData() {
			this.allData = this.AllusersData;
			this.employeesData = this.AllusersData;
			this.users = this.Allusers.filter((v) => v.name !== "All Users");
		},
	},
	methods: {
		formatDate(start, end = new Date()) {
			const dtStart = new Date(start);
			const dtEnd = new Date(end);
			const padLStart = (nr, len = 2, chr = `0`) => `${nr}`.padStart(2, chr);
			return {
				hour: `${padLStart(dtStart.getHours())}:${padLStart(dtStart.getMinutes())} - ${padLStart(dtEnd.getHours())}:${padLStart(
					dtEnd.getMinutes()
				)}`,
				date: `${padLStart(dtStart.getDate())}/${padLStart(dtStart.getMonth() + 1)}/${dtStart.getFullYear()}`,
			};
		},
		datesAreOnSameDay(first, second) {
			first = new Date(first);
			second = new Date(second);
			return (
				first.getFullYear() === second.getFullYear() &&
				first.getMonth() === second.getMonth() &&
				first.getDate() === second.getDate()
			);
		},
		addWK(v) {
			const index = this.employeesData.findIndex((data) => this.formatDate(v.startDate).date === data.Date && v.id === data.user_id);
			this.employeesData[index].scheduleStart = new Date(v.startDate);
			this.employeesData[index].scheduleEnd = new Date(v.endDate);
			this.employeesData[index]["Scheduled Working Times"] = this.formatDate(v.startDate, v.endDate).hour;
		},
		updateWK(v) {
			const index = this.employeesData.findIndex((data) => data.id === v.id);
			this.employeesData[index].scheduleStart = new Date(v.startDate);
			this.employeesData[index].scheduleEnd = new Date(v.endDate);
			this.employeesData[index]["Scheduled Working Times"] = this.formatDate(v.startDate, v.endDate).hour;
		},
		add() {
			this.action = true;
			this.dialog ? (this.dialog = false) : (this.dialog = true);
		},
		update(v) {
			this.action = false;
			this.memberData = v;
			this.dialog ? (this.dialog = false) : (this.dialog = true);
		},
		deleteWorkingTime(v) {
			Swal.fire({
				icon: "error",
				text: "Are you sure to delete " + v.User + " working time ?",
				confirmButtonText: "Yes",
				showLoaderOnConfirm: true,
			}).then(async (res) => {
				if (res.isConfirmed) {
					const deleteResponse = await Send.deleteRequest(`workingtimes/${v.id}`);
					if (deleteResponse.status === 200) {
						this.snackbarColor = "green";
						this.snackbar = true;
						this.snackbarText = "You just deleted the working time for " + v.User;
						const index = this.employeesData.findIndex((data) => data === v);
						delete this.employeesData[index]["Scheduled Working Times"];
					}
				}
			});
		},
	},
	mounted() {
		this.userStore.$subscribe((u) => {
			if (u.events.newValue !== null) {
				this.employeesData = this.allData.filter((v) => v.User === u.events.newValue);
			} else {
				this.employeesData = this.allData;
			}
		});
	},
	data() {
		const route = useRoute();
		const id = route.params.teamid;
		return {
			user: JSON.parse(localStorage.getItem("user")),
			teamid: id,
			action: true,
			dialog: false,
			snackbar: false,
			snackbarText: "",
			snackbarColor: "green",
			memberData: {},
			users: [],
			allData: this.AllusersData,
			employeesData: [
				{
					User: "No data",
					Date: "No data",
					"Scheduled Working Times": "No data",
					"Real Working Times": "No data",
					ID: 0.0,
				},
			],
			fields: ["User", "Date", "Scheduled Working Times", "Real Working Times"],
		};
	},
};
</script>
<style>
.v-btn {
	margin-right: 10px;
}
</style>
