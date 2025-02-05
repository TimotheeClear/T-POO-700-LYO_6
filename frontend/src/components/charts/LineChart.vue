<template>
	<div class="container text-center">
		<div class="row" id="chart">
			<div class="col">
				<div>
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
				</div>
			</div>
		</div>
	</div>
</template>

<script lang="ts">
import { Line as LineChartGenerator } from "vue-chartjs";
import "chartjs-adapter-moment";

import {
	Chart as ChartJS,
	Title,
	Tooltip,
	Legend,
	LineElement,
	LinearScale,
	CategoryScale,
	TimeScale,
	PointElement,
	ArcElement,
	Filler,
} from "chart.js";
ChartJS.register(Title, Filler, Tooltip, Legend, LineElement, TimeScale, LinearScale, CategoryScale, PointElement, ArcElement);
export default {
	name: "LineChart",
	components: {
		LineChartGenerator,
	},
	props: {
		bool: Boolean,
		ArrayData: { type: Array, of: { Date: String } },
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
	watch: {
		bool() {
			this.chartData.datasets[0].data = this.ArrayData;
		},
		ArrayData(n) {
			this.chartData.datasets[0].data = n;
			this.chartData.datasets[1].data = n;
			this.chartData.labels = n.map(({ Date }) => Date);
		},
	},
	mounted() {
		if (this.ArrayData) {
			this.chartData.labels = this.ArrayData.map(({ Date }) => Date);
		}
	},
	methods: {
		convertMinutes(min: number) {
			const hours = Math.floor(min / 60);
			const minutes = min % 60;
			return `${hours} hours ${minutes > 0 ? minutes + " minutes" : ""}`;
		},
	},
	data() {
		return {
			allData: [],
			chartData: {
				labels: [],
				datasets: [
					{
						label: "Registred Working Hours",
						data: this.ArrayData,
						fill: true,
						order: 2,
						pointBorderColor: "white",
						backgroundColor: "#a9e8a9",
            beginAtZero: true   // minimum value will be 0.
,
						parsing: {
							xAxisKey: "scheduleTotalMinutes",
							yAxisKey: "scheduleTotalMinutes",
						},
					},
					{
						label: "Actual Working Hours",
						data: this.ArrayData,
						fill: true,
						order: 1,
						pointBorderColor: "white",
						backgroundColor: "#74bcd2"
               // minimum value will be 0.
,
						parsing: {
							xAxisKey: "realtotalMinutes",
							yAxisKey: "realtotalMinutes",
						},
					},
				],
			},
			chartOptions: {
				plugins: {
					tooltip: {
						callbacks: {
							label: function (context) {
								const username = context.dataset.data[context.dataIndex].User;
								const label = context.formattedValue;
								const hours = Math.floor(label / 60);
								const minutes = label % 60;
								return `${username} :  ${hours} hours ${minutes > 0 ? minutes + " minutes" : ""}`;
							},
						},
					},
				},
				responsive: true,
				maintainAspectRatio: false,
				scales: {
					y: {
            beginAtZero: true,
						ticks: {
							callback: function (label) {
								const hours = Math.floor(label / 60);
								const minutes = label % 60;
								return `${hours} hours ${minutes > 0 ? minutes + " minutes" : ""}`;
							},
						},
						scaleLabel: {
							display: true,
							labelString: "1k = 1000",
						},
					},
				},
			},
		};
	},
};
</script>

<style>
#id {
	width: 700px;
}
</style>
