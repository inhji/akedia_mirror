<template>
	<div class="media weather">
		<figure class="media-left">
			<p class="image is-64x64">
				<canvas id="weather" width="48" height="48" v-bind:data-icon="weather.icon" v-bind:class="weather.icon"></canvas>
			</p>
		</figure>
		<div class="media-content">
			<div class="content">
				<strong>{{ weather.now }} at {{ weather.temperature }} °C ({{weather.humidity * 100}}% Humidity)</strong>
				<p>
					Looks like it's going to be from {{weather.min}} to {{weather.max}} and {{weather.summary.toLowerCase()}}
				</p>
			</div>
		</div>
	</div>
</template>

<script>
	import {channel} from '../channel'
	import Skycons from '../../vendor/skycons.js'

  export default {
  	data() {
  		return {
  			weather: {
  				humidity: 0.76,
  				icon: "partly-cloudy-night",
  				max: 18.3,
  				min: 3.1,
  				now: "Partly Cloudy",
  				summary: "Partly cloudy throughout the day.",
  				temperature: 6.8
  			}
  		}
  	},
  	methods: {
  		handleWeather: function (payload) {
  			this.weather = payload.weather
  		}
  	},
  	mounted: function () {			
			channel.on("weather", this.handleWeather)
			channel.push("get_weather")
		}
  }
</script>