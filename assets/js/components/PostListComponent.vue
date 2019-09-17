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

	function handlePosts (payload) {
		const posts = payload.posts.map((i) => i[0])
		const bookmarks = payload.bookmarks.map((i) => i[0])
		const likes = payload.likes.map((i) => i[0])
		const labels = payload.posts.map((i) => moment(i[1]).format("DD MMM"))

		const chart = new Chart("posts-per-week", {
			type: "line",
			data: {
				labels: labels,
				datasets: [
					{ 
						backgroundColor: Chart.helpers.color(colors.purple).alpha(0.5).rgbString(),
						borderColor: Chart.helpers.color(colors.purple).alpha(0.8).rgbString(),
						borderWidth: 2,
						label: '# of Posts',
						data: posts
					},
					{ 
						backgroundColor: Chart.helpers.color(colors.red).alpha(0.5).rgbString(),
						borderColor: Chart.helpers.color(colors.red).alpha(0.8).rgbString(),
						borderWidth: 2,
						label: '# of Bookmarks',
						data: bookmarks
					},
					{ 
						backgroundColor: Chart.helpers.color(colors.teal).alpha(0.5).rgbString(),
						borderColor: Chart.helpers.color(colors.teal).alpha(0.8).rgbString(),
						borderWidth: 2,
						label: '# of Likes',
						data: likes
					}
				]
			},

		})
	}

	export default{
		mounted: function () {			
			channel.on("on_posts", handlePosts)
			channel.push("get_posts")
		}
	}
</script>

<template>
	<div class="card">
	  <div class="card-content">    
      <p class="heading">Posts per Month</p>
      <canvas id="posts-per-week" height="100px"></canvas>
	  </div>
	</div>
</template>