<template>
   <div id="admin">
   	<div class="columns">
	   	<div class="column">
	   		<h1 class="title">Hi {{ username }}!</h1>
	   	<h2 class="subtitle">{{ greeting }}</h2>
	   	</div>
	   	<div class="column">
	   		<weather-component></weather-component>
	   	</div>
   	</div>

   	<div class="columns">
   		<div class="column">
   			<listen-list-component></listen-list-component>
   		</div>
   		<div class="column">
   			<post-list-component></post-list-component>
   		</div>
   	</div>
   </div>
</template>
<script>
	import moment from 'moment'
	import {Socket} from "phoenix"
	import ListenListComponent from './ListenListComponent.vue'
	import PostListComponent from './PostListComponent.vue'
  import WeatherComponent from './WeatherComponent.vue'

  export default {
  	components: {
  		ListenListComponent,
  		PostListComponent,
      WeatherComponent
  	},
  	data: function () {
  		return {
  			username: "inhji"			
  		}
  	},
  	computed: {
  		greeting: function () {
  			const hour = moment().hour()

  			if (hour == 0 || hour <= 6) {
  				return "You should sleep right now!" 
  			} else if (hour > 20 || hour <= 23) {
  				return "Good night!"
  			} else {
  				return "Hello!"
  			}
  		},

  	}
  }
</script>