import { defineStore } from "pinia";

export const userChartStore = defineStore({
	id: "userChartStore",
	state: () => ({
		users: null,
	}),
	actions: {
		setUsers(users: string | null) {
			this.users = users;
		},
		getUsers() {
			return this.users;
		},
	},
});
