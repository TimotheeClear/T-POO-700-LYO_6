import { defineStore } from "pinia";
import Send from "@/helpers/sendRequest";
import User from "@/types/User";

export const useTeamMembersStore = defineStore("teamMembers", {
  state: () => ({
    currentTeamMembers: [],
    currentTeamName: null,
    currentTeamId: null,
  }),
  getters: {
    getNumberTeamMembers: (state) => {
      return state.currentTeamMembers.length;
    },
  },
  actions: {
    async fetchCurrentTeamMembers(teamId: number): Promise<void> {
      const { data } = await Send.getRequest(`/users/teams/${teamId}`);
      this.currentTeamMembers = data.data;
    },
    setCurrentTeam(currentTeamId: number, currentTeamName: string): void {
      this.currentTeamId = currentTeamId;
      this.currentTeamName = currentTeamName;
    },
    removeTeamMember(teamMemberId: number): void {
      this.currentTeamMembers = this.currentTeamMembers.filter((e) => e.id !== teamMemberId);
    },
    addTeamMember(teamMember: User): void {
      this.currentTeamMembers.push(teamMember);
    },
  },
});
