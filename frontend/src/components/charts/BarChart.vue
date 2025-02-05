<template>
	<div class="container text-center">
		<div class="row" id="chart">
			<div class="col">
				<div>
					<Bar
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
import { Bar } from "vue-chartjs";
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale } from "chart.js";
ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale);
export default {
	name: "PieChart",
	components: {
		Bar,
	},
	props: {
		bool: Boolean,
		ArrayData: Array,
		chartId: {
			type: String,
			default: "bar-chart",
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
	data() {
		return {
			chartData: {
				labels: this.ArrayData.map(({ Date }) => Date),
				datasets: [
					{
						label: "Working Hours",
						backgroundColor: "#f87979",
						data: this.ArrayData,
						parsing: {
							xAxisKey: "scheduleTotalMinutes",
							yAxisKey: "scheduleTotalMinutes",
						},
					},

					{
						label: "Registred Working Hours",
						data: this.ArrayData,
						fill: true,
						pointBorderColor: "white",
						backgroundColor: "#74bcd2",
						parsing: {
							xAxisKey: "realtotalMinutes",
							yAxisKey: "realtotalMinutes",
						},
					},
				],
			},
			chartOptions: {
				plugins: {
					doughnutlabel: {
						labels: [
							{
								text: "550",
								font: {
									size: 20,
									weight: "bold",
								},
							},
							{
								text: "total",
							},
						],
					},
					tooltip: {
						callbacks: {
							label: function (context) {
								const label = context.formattedValue;
								const username = context.dataset.data[context.dataIndex].User;

								const hours = Math.floor(label / 60);
								const minutes = label % 60;
								return `${username} :  ${hours} heures ${minutes > 0 ? minutes + " minutes" : ""}`;
							},
						},
					},
				},
				responsive: true,
				maintainAspectRatio: false,
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
