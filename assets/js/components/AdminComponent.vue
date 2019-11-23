<template>
   <div id="admin">
   	<div class="columns">
	   	<div class="column">
	   		<h1 class="title">{{ username }}</h1>
	   	<h2 class="subtitle">{{ greeting }}</h2>
	   	</div>
	   	<div class="column">
	   		<weather-component></weather-component>
	   	</div>
   	</div>

    <div class="columns">
      <div class="column">
        <feed-entry-list-component />
      </div>
      <div class="column"></div>
    </div>

    <hr />

   	<div class="columns">
   		<div class="column">
   			<post-list-component></post-list-component>
   		</div>
   	</div>
   </div>
</template>
<script>
	import moment from 'moment'
	import {Socket} from "phoenix"
	import PostListComponent from './PostListComponent.vue'
  import WeatherComponent from './WeatherComponent.vue'
  import FeedEntryListComponent from './FeedEntryListComponent.vue'

  export default {
  	components: {
  		PostListComponent,
      WeatherComponent,
      FeedEntryListComponent
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
        } else if (hour >= 7 && hour <= 9) {
          return "Good morning!"
  			} else if (hour > 20) {
  				return "Good night!"
  			} else {
  				return "Hello!"
  			}
  		},

  	}
  }
</script>