<template>
  <div class="clockContainer">
    <div class="ReportClock">
      <div class="clock">
        <h3 class="ReportClock-title">Report Workingtime</h3>
        <div class="ReportClock-timer">
          <p v-if="clock_status">
            Logged since
            <span v-if="chrono.time.hours">{{ chrono.time.hours }}h</span>
            <span v-if="chrono.time.minutes"
              >{{ chrono.time.minutes
              }}<span v-if="!chrono.time.hours">min</span></span
            >
            <span>{{ chrono.time.seconds }}s</span>
          </p>
          <p v-if="!clock_status">Press start to start your clock</p>
        </div>
        <div
          class="ReportClock-button-green"
          @click="triggerClock"
          v-if="!clock_status"
        >
          start
        </div>
        <div
          class="ReportClock-button-red"
          @click="triggerClock"
          v-if="clock_status"
        >
          end
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
/* eslint-disable */
import Send from "@/helpers/sendRequest";
import Clock from "@/types/Clock";

export default {
  name: "ClockTrigger",
  data() {
    return {
      previous_clock: null,
      last_clock: null,
      clock_status: null,
      chrono: {
        time: {
          hours: 0,
          minutes: 0,
          seconds: 0,
        },
        timer: 0,
        total_seconds: 0,
      },
      clocks_list: [],
    };
  },
  methods: {
    async triggerClock() {
      await this.createClock();
      if (this.clock_status) {
        let date1 = new Date(this.last_clock.time);
        let date2 = new Date(date1.getTime() + 60 * 60000);
        const last_date = date2.getTime();
        const time_now = Date.parse(new Date().toUTCString());
        this.chrono.total_seconds = Math.floor((time_now - last_date) / 1000);
        this.chronoStart();
      } else {
        this.chronoStop();
        this.chronoReset();
        this.$emit("end-clock");
      }
    },

    async createClock() {
      const user_id = this.getUserId();
      this.previous_clock = this.last_clock;

      try {
        const response = Send.postRequest<Clock>(`/clocks/${user_id}`, {});
        this.last_clock = (await response).data.data;
        this.clock_status = this.last_clock.status;
        this.addToClocksList(this.last_clock);
      } catch (error) {
        console.log(error);
      }
    },

    async getAllClocks() {
      const user_id = this.getUserId();

      try {
        const response = Send.getRequest<Clock[]>(`/clocks/${user_id}`);
        const clock_list = (await response).data.data;
        clock_list.sort((a, b) => {
          return a.id - b.id;
        });

        for (const i in clock_list) {
          this.addToClocksList(clock_list[i]);
        }
      } catch (error) {
        this.clocks_list = [];
      }
    },

    addToClocksList(clock) {
      this.clocks_list
        ? this.clocks_list.push(clock)
        : (this.clocks_list = [clock]);
    },

    async initData() {
      await this.lastClock();

      this.clock_status = this.last_clock ? this.last_clock.status : false;
      await this.getAllClocks();

      if (this.clock_status) {
        let date1 = new Date(this.last_clock.time);
        let date2 = new Date(date1.getTime() + 60 * 60000);
        const last_date = date2.getTime();
        const time_now = Date.parse(new Date().toUTCString());
        this.chrono.total_seconds = Math.floor((time_now - last_date) / 1000);
        this.chronoStart();
      }
    },

    async lastClock() {
      const user_id = this.getUserId();

      try {
        const response = Send.getRequest<Clock>(`/clocks/last/${user_id}`);
        this.last_clock = (await response).data.data;
      } catch (error) {
        this.last_clock = null;
      }
    },

    chronoStart() {
      this.timer = setInterval(() => {
        ++this.chrono.total_seconds;
        this.chrono.time.hours = Math.floor(this.chrono.total_seconds / 3600);
        this.chrono.time.minutes = Math.floor(
          (this.chrono.total_seconds - this.chrono.time.hours * 3600) / 60
        );
        this.chrono.time.seconds =
          this.chrono.total_seconds -
          this.chrono.time.minutes * 60 -
          this.chrono.time.hours * 3600;
      }, 1000);
    },

    chronoStop() {
      clearInterval(this.timer);
    },

    chronoReset() {
      this.chrono.total_seconds = 0;
      this.chrono.time.hours = 0;
      this.chrono.time.minutes = 0;
      this.chrono.time.seconds = 0;
    },

    getUserId() {
      return JSON.parse(localStorage.getItem("user")).id;
    },
  },
  async mounted() {
    await this.initData();
  },
};
</script>

<style scoped lang="scss">
.clockContainer {
  display: flex;
  justify-content: center;
  align-items: center;
  .clock {
    height: 100%;
    box-shadow: 0 1.833px 2.58px -1.166px rgba(0, 0, 0, 0.2),
      0px 4px 6.332px 0.5px rgba(0, 0, 0, 0.14),
      0px 1.5px 7.664px 1.333px rgba(0, 0, 0, 0.12);
    border-radius: 5px;
    padding: 20px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
  }

  .ReportClock {
    &-title {
      padding: 5px;
    }

    &-timer {
      height: fit-content;
      margin: 10px;
      padding: 5px;
    }

    &-button {
      width: fit-content;
    }
  }
}

.ReportClock-button-green {
  color: white;
  background-color: green;
  border-radius: 5px;
  padding: 10px;
}

.ReportClock-button-red {
  color: white;
  background-color: #e10e0e;
  border-radius: 5px;
  padding: 10px;
}
</style>
