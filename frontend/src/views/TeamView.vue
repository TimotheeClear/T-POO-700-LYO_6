<template>
  <v-container class="grey lighten-5">
    <v-row no-gutters>
      <v-col sm="12">
        <v-col>
          <ChartManager :Allusers="users" :AllUsersData="employeesData" />
        </v-col>
        <v-spacer></v-spacer>
        <v-col>
          <WorkingTimes :Allusers="users" :AllusersData="employeesData" />
        </v-col>
      </v-col>
    </v-row>
  </v-container>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import ChartManager from "@/components/charts/ChartManager.vue"; // @ is an alias to /src
import WorkingTimes from "@/components/workingTime/WorkingTimes.vue"; // @ is an alias to /src
import { useRoute } from "vue-router";
import Send from "@/helpers/sendRequest";

interface UserWorkingHours {
  id: number;
  email: string;
  end: Date;
  start: Date;
  team_id: number;
  user_id: number;
  username: string;
}
interface Clock {
  id: number;
  status: boolean;
  time: Date;
  user_id: number;
  username: string;
}
export default defineComponent({
  name: "TeamView",
  components: {
    ChartManager,
    WorkingTimes,
  },
  async mounted() {
    const route = useRoute();
    const id = route.params.teamid;
    if (id !== undefined) {
      this.getTeamDetails(id);
    }
  },
  methods: {
    getTimeDiff(startDate, endDate) {
      startDate = new Date(startDate);
      endDate = new Date(endDate);
      const msInMinute = 1000 * 60;

      return Math.round(
        Math.abs(endDate.getTime() - startDate.getTime()) / msInMinute
      );
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

    getEmployeesData(filteredUserClocks) {
      const employees = [];
      filteredUserClocks.forEach((v) => {
        v.forEach((u) => {
          employees.push(
            Object.assign(u, {
              realtotalMinutes: this.getTimeDiff(u.start, u.end),
              scheduleTotalMinutes: this.getTimeDiff(
                u.scheduleStart,
                u.scheduleEnd
              ),
            })
          );
        });
      });
      this.employeesData = null;
      const allDates = employees.map(({ Date }) => Date);
      allDates.forEach((v) => {
        const result = employees.filter((emp) => emp.Date === v);

        result.reduce((accumulator, object) => {
          return accumulator + object.realtotalMinutes;
        }, 0);
      });
      if (employees.length == 0) {
        this.employeesData = [
          {
            User: "No data",
            Date: "No data",
            "Scheduled Working Times": "No data",
            "Real Working Times": "No data",
            ID: 0.0,
          },
        ];
      } else {
        this.employeesData = employees;
      }
    },

    getTeamDetails(teamid: string) {
      const getData = async () => {
        let clocks: Clock[];
        try {
          clocks = (
            await Send.getRequest<any>(
              `${process.env.VUE_APP_TIME_MANAGER_API}/clocks/teams/${teamid}`
            )
          ).data.data;
        } catch (e) {
          return;
        }
        const users = clocks.map((a) => ({
          id: a.user_id,
          name: a.username,
        }));
        const uniqueIds = new Set();
        const unique = users.filter((element) => {
          const isDuplicate = uniqueIds.has(element.id);
          uniqueIds.add(element.id);
          return !isDuplicate;
        });
        unique.unshift({ name: "All Users", id: 0 });
        this.users = unique;
        const max = Math.max(...clocks.map((o) => o.user_id));
        const AllusersClocks: Clock[][] = [];
        for (let i = 1; i <= max; i++) {
          const userClock = clocks.filter((clock) => clock.user_id === i);
          if (userClock.length > 0) {
            AllusersClocks.push(userClock);
          }
        }

        let filteredUserClocks: {
          start: Date;
          end: Date;
          username: string;
          user_id: number;
          scheduleStart: string;
          scheduleEnd: string;
        }[][] = [];
        AllusersClocks.forEach((UserArray) => {
          const userArr = [];
          for (let i = 0; i < UserArray.length - 1; i++) {
            userArr.push({
              start: UserArray[i].time,
              end: UserArray[i + 1].time,
              User: UserArray[i].username,
              user_id: UserArray[i].user_id,
            });
            i++;
          }
          filteredUserClocks.push(userArr);
        });
        filteredUserClocks.forEach((oneUserClock) => {
          oneUserClock.forEach((v) => {
            const dtStart = new Date(v.start);
            const dtEnd = new Date(v.end);
            const padLStart = (nr, len = 2, chr = `0`) =>
              `${nr}`.padStart(2, chr);
            Object.assign(v, {
              Date: `${padLStart(dtStart.getDate())}/${padLStart(
                dtStart.getMonth() + 1
              )}/${dtStart.getFullYear()}`,
              "Real Working Times": `${padLStart(
                dtStart.getHours()
              )}:${padLStart(dtStart.getMinutes())} - ${padLStart(
                dtEnd.getHours()
              )}:${padLStart(dtEnd.getMinutes())}`,
            });
          });
        });

        try {
          const response = await Send.getRequest<any>(
            `${process.env.VUE_APP_TIME_MANAGER_API}/workingtimes/teams/${teamid}`
          );
          const workingHours: UserWorkingHours[] = response.data.data;
          workingHours.forEach((userWorkingHours) => {
            filteredUserClocks.forEach((oneUserClock) => {
              oneUserClock.forEach((v) => {
                const padLStart = (nr, len = 2, chr = `0`) =>
                  `${nr}`.padStart(2, chr);
                if (userWorkingHours.user_id === v.user_id) {
                  if (this.datesAreOnSameDay(userWorkingHours.start, v.start)) {
                    const ScheduledStart = new Date(userWorkingHours.start);
                    const ScheduledEnd = new Date(userWorkingHours.end);
                    Object.assign(v, {
                      "Scheduled Working Times": `${padLStart(
                        ScheduledStart.getHours()
                      )}:${padLStart(
                        ScheduledStart.getMinutes()
                      )} - ${padLStart(ScheduledEnd.getHours())}:${padLStart(
                        ScheduledEnd.getMinutes()
                      )}`,
                      scheduleStart: userWorkingHours.start,
                      scheduleEnd: userWorkingHours.end,
                      id: userWorkingHours.id,
                    });
                  }
                }
              });
            });
          });
          this.getEmployeesData(filteredUserClocks);
        } catch (e) {
          this.getEmployeesData(filteredUserClocks);
        }
      };
      getData();
    },
  },
  data() {
    return {
      users: [],
      employeesData: [],
    };
  },
});
</script>

<style lang="scss">
ChartManager {
  margin-bottom: 2rem;
}
</style>
