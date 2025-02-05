<template>
	<v-snackbar v-model="snackbar" :color="snackbarColor">{{ snackbarText }}</v-snackbar>
	<div class="text-center">
		<v-dialog v-model="dialog" width="500">
			<v-card>
				<v-card-title class="text-h5 grey lighten-2" v-if="!action">Update working Times for {{ userData.User }} </v-card-title>
				<v-card-title class="text-h5 grey lighten-2" v-if="action" id="title">
					<span class="text"> Add working Times for </span
					><v-select
						class="select"
						label="Users"
						:items="users"
						multiple
						item-title="name"
						item-value="user_id"
						return-object
						v-model="selectedUser"
					></v-select
				></v-card-title>

				<v-row class="dates">
					<div>
						<v-card-title class="text-h5 grey lighten-2"> Start date </v-card-title>

						<Datepicker class="Datepicker" v-model="startDate" :autoPosition="false" teleportCenter></Datepicker>
					</div>
					<div>
						<v-card-title class="text-h5 grey lighten-2"> End date </v-card-title>

						<Datepicker v-model="endDate" :autoPosition="false" teleportCenter></Datepicker>
					</div>
				</v-row>
				<v-divider></v-divider>

				<v-card-actions>
					<v-spacer></v-spacer>
					<v-btn color="primary" text @click="dialog = false"> Close </v-btn>
					<v-btn color="primary" text @click="addUsers" v-if="action"> Add </v-btn>
					<v-btn color="primary" text @click="updateUsers" v-if="!action"> Update </v-btn>
				</v-card-actions>
			</v-card>
		</v-dialog>
	</div>
</template>
<script lang="ts">
import Send from "@/helpers/sendRequest";

export default {
	props: {
		users: { type: Array },
		userData: {
			type: Object,
		},
		dilog: { type: Boolean },
		action: { type: Boolean },
	},
  emits: ["addData", "updateData"],
	methods: {
		addUsers() {
			if (this.selectedUser !== null) {
				if (this.startDate !== "Invalid Date" && this.endDate !== "Invalid Date") {
					for (let user of this.selectedUser) {
						const data = {
							start: this.startDate,
							end: this.endDate,
						};
						Send.postRequest(`/workingtimes/${user.id}`, data).then((response) => {
							if (response.status === 201) {
								this.snackbar = true;
								this.snackbarText = "You just added the working time for " + user.name;
								this.dialog = false;
								this.$emit("addData", Object.assign(user, { startDate: this.startDate, endDate: this.endDate }));
							} else {
								this.snackbarText = "Error when adding ";
								this.dialog = false;
								this.snackbar = true;
								this.snackbarColor = "red";
							}
						});
					}
				} else {
					this.snackbarText = "Start/End  date cannot be blank.";
					this.snackbar = true;
					this.snackbarColor = "red";
				}
			} else {
				this.snackbarText = "Choose a user or users.";
				this.snackbar = true;
				this.snackbarColor = "red";
			}
		},
		updateUsers() {
			const data = {
				start: this.startDate,
				end: this.endDate,
			};
			Send.patchRequest(`/workingtimes/${this.userData.user_id}`, data).then((response) => {
				if (response.status === 200) {
					this.snackbarColor = "yellow";
					this.snackbarText = "You just updated the working time for " + this.userData.User;
					this.snackbar = true;
					this.dialog = false;
					this.$emit("updateData", Object.assign(this.userData, { startDate: this.startDate, endDate: this.endDate }));
				} else {
					this.snackbarText = "Error when updating. ";
					this.dialog = false;
					this.snackbar = true;
					this.snackbarColor = "red";
				}
			});
		},
	},
	watch: {
		dilog() {
			if (this.action) {
				this.startDate = new Date();
				this.endDate = new Date();
			}
			this.dialog = true;
			this.startDate = new Date(this.userData.scheduleStart);
			this.endDate = new Date(this.userData.scheduleEnd);
		},
	},
	data() {
		return {
			selectedUser: null,
			startDate: null,
			endDate: null,
			dialog: false,
			snackbar: false,
			snackbarText: "",
			snackbarColor: "green",
		};
	},
};
</script>
<style>
.Datepicker {
	margin-right: 10px;
}
.dates {
	margin-top: 20px;
	display: flex;
	justify-content: center;
}
.select {
	margin-left: 15px;
}
#title {
	display: flex;
}
.text {
	margin-top: 10px;
}
</style>
