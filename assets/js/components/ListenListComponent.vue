<template>
	<div class="card">
	  <div class="card-content">    
      <p class="heading">Listens per Month</p>
      <canvas id="likes-per-month" height="100px"></canvas>
    </div>
	</div>
</template>

<script>
	import {Socket} from "phoenix"
	import moment from 'moment'
	import {channel} from '../channel'

	const colors = {
		red: '#d34',
		purple: '#311B92',
		teal: '#006064',
		green: '#33691E'
	}

	function color(color) {
		return Chart.helpers.color(colors[color])
	}

	function handleListens(payload) {
		const data = payload.listens.map((i) => i[0])
		const labels = payload.listens.map((i) => moment(i[1]).format("MMM YY"))

		const chart = new Chart("likes-per-month", {
			type: "line",
			data: {
				labels: labels,
				datasets: [
					{ 
						backgroundColor: color("green").alpha(0.5).rgbString(),
						borderColor: Chart.helpers.color(colors.green).alpha(0.8).rgbString(),
						borderWidth: 2,
						label: 'Listens',
						data: data
					}
				]
			}
		})
	}

	export default{
		mounted: function () {			
			channel.on("listens", handleListens)
			channel.push("get_listens")
		},
	}
</script>