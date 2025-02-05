<template>
	<div class="clockContainer">
		<div class="ReportClock">
			<div class="clock">
				<h3 class="ReportClock-title">Report Workingtime</h3>
				<div class="ReportClock-timer">
					<p v-if="clock_status">
						Logged since
						<span v-if="chrono.time.hours">{{ chrono.time.hours }}h</span>
						<span v-if="chrono.time.minutes">{{ chrono.time.minutes }}<span v-if="!chrono.time.hours">min</span></span>
						<span>{{ chrono.time.seconds }}s</span>
					</p>
					<p v-if="!clock_status">Press start to start your clock</p>
				</div>
				<v-btn class="ReportClock-button" v-on:click="triggerClock" color="green" v-if="!clock_status">start</v-btn>
				<v-btn class="ReportClock-button" v-on:click="triggerClock" color="red" v-if="clock_status">end</v-btn>
			</div>
		</div>

		<v-card elevation="4">
			<LineChartGenerator
				:chart-options="chartOptions"
				:chart-data="chartData"
				:chart-id="chartId"
				:dataset-id-key="datasetIdKey"
				:css-classes="cssClasses"
				:styles="styles"
				:width="width"
				:height="height"
			/>
		</v-card>
	</div>
</template>

<script lang="ts">
/* eslint-disable */
import "chartjs-adapter-moment";
import Send from "@/helpers/sendRequest";
import { Line as LineChartGenerator, Doughnut } from "vue-chartjs";
import {
	Chart as ChartJS,
	Title,
	Tooltip,
	Legend,
	LineElement,
	LinearScale,
	CategoryScale,
	PointElement,
	ArcElement,
	Filler,
	TimeScale,
} from "chart.js";
import Clock from "@/types/Clock";
ChartJS.register(Title, Filler, Tooltip, Legend, LineElement, LinearScale, CategoryScale, PointElement, ArcElement, TimeScale);

export default {
	name: "ClockTrigger",
	components: {
		LineChartGenerator,
	},
	props: {
		bool: Boolean,
		ArrayData: Array,
		chartId: {
			type: String,
			default: "line-chart",
		},
		datasetIdKey: {
			type: String,
			default: "label",
		},
		width: {
			type: Number,
			default: 400,
		},
		height: {
			type: Number,
			default: 400,
		},
		cssClasses: {
			default: "",
			type: String,
		},
		styles: {
			type: Object,
		},
		plugins: {
			type: Array,
			default: () => [],
		},
	},
  emits: ["end-clock"],
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
			chartData: {
				labels: [],
				datasets: [
					{
						label: "Number of working hours",
						data: [],
						fill: true,
						pointBorderColor: "white",
						backgroundColor: "#74bcd2",
					},
				],
			},
			chartOptions: {
				responsive: true,
				maintainAspectRatio: false,

				scales: {
					y: {
						suggestedMin: 0,
						suggestedMax: 10,
						ticks: {
							callback: function (value) {
								return value + " h";
							},
						},
					},
				},
			},
			chartInit: {
				chartSpendTime: [],
				chartLabel: [],
			},
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
				this.addToClocksChart(this.clocks_list, this.clocks_list.length - 1);
				this.sendSpendTimeToChart();
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
					this.addToClocksChart(clock_list, i);
				}
				this.sendSpendTimeToChart();
			} catch (error) {
				this.clocks_list = [];
			}
		},

		addToClocksChart(clocks, i) {
			const clock = clocks[i];
			if (!clock.status) {
				const opt_date = {
					year: "numeric",
					month: "2-digit",
					day: "2-digit",
				} as const;

				const date = new Date(clock.time).toLocaleDateString("fr-FR", opt_date);
				const time_spend = (new Date(clock.time).getTime() - new Date(clocks[i - 1].time).getTime()) / 3600000;

				const indexOf = this.chartInit.chartLabel.indexOf(date);
				if (indexOf >= 0) {
					this.chartInit.chartSpendTime[indexOf] += time_spend;
				} else {
					this.chartInit.chartLabel.push(date);
					this.chartInit.chartSpendTime.push(time_spend);
				}
			}
		},

		sendSpendTimeToChart() {
			const chartDataLastData = this.chartInit.chartSpendTime.length - 1;
			const chartLabelLastData = this.chartInit.chartLabel.length - 1;
			const listToChartData = [];
			const listToChartLabel = [];
			this.chartInit.chartLabel.sort();
			for (let i = 0; i < 7; i++) {
				listToChartData.push(this.chartInit.chartSpendTime[chartDataLastData - i]);
				listToChartLabel.push(this.chartInit.chartLabel[chartLabelLastData - i]);
			}
			this.chartData.datasets[0].data = listToChartData.reverse();
			this.chartData.labels = listToChartLabel.reverse();
		},

		addToClocksList(clock) {
			this.clocks_list ? this.clocks_list.push(clock) : (this.clocks_list = [clock]);
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
				this.chrono.time.minutes = Math.floor((this.chrono.total_seconds - this.chrono.time.hours * 3600) / 60);
				this.chrono.time.seconds = this.chrono.total_seconds - this.chrono.time.minutes * 60 - this.chrono.time.hours * 3600;
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
	display: grid;
	grid-template-columns: 1fr 2fr;
	column-gap: 50px;
	margin-bottom: 10%;
	.clock {
		width: 100%;
		height: 100%;
		box-shadow: 0 1.833px 2.58px -1.166px rgba(0, 0, 0, 0.2), 0px 4px 6.332px 0.5px rgba(0, 0, 0, 0.14),
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
</style>
