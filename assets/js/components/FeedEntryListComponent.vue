<template>
	<div class="card is-marginless">
	  <div class="card-content">    
      <p class="subtitle">Unread Feed Entries</p>

			<ul>
	      <li v-for="item in entries">
	      	<i class="fa fa-circle has-text-primary"></i>
	      	<span class="has-text-grey">{{item.author}}</span>
	      	<a v-bind:href="item.url" target="_blank">{{item.title}}</a>
	      	<span class="has-text-grey">{{formatDate(item.published_at)}}</span>
	      </li>
			</ul>
    </div>
	</div>
</template>

<script>
	import moment from 'moment'
	import {channel} from '../channel'

	export default{
		data: () => ({
			entries: []
		}),
		methods: {
			handleEntries: function ({ entries }) {
				console.log(this)
				this.entries = entries
			},
			formatDate: function (date) {
				return moment(date).fromNow()
			}
		},
		mounted: function () {			
			channel.on("feed_entries", this.handleEntries)
			channel.push("get_feed_entries")
		}
	}
</script>