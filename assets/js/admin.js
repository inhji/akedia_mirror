import "phoenix_html"
import "./webauthn.js"
import "./new_post.js"
import {Socket} from "phoenix"
import Chart from "chart.js"
import moment from "moment"

const colors = {
	red: '#d34',
	purple: '#311B92',
	teal: '#006064',
	green: '#33691E'
}

const socket = new Socket("/socket")
socket.connect()

// Now that you are connected, you can join channels with a topic:
const channel = socket.channel("admin:dashboard", {})

channel.on("on_listens", function (payload) {
	console.log(payload)
	const data = payload.listens.map((i) => i[0])
	const labels = payload.listens.map((i) => moment(i[1]).format("MMM YY"))

	const chart = new Chart("likes-per-month", {
		type: "bar",
		data: {
			labels: labels,
			datasets: [
				{ 
					backgroundColor: Chart.helpers.color(colors.red).alpha(0.5).rgbString(),
					label: '# of Listens',
					data: data
				}
			]
		}
	})
})

channel.on("on_posts", function (payload) {
	const data = payload.posts.map((i) => i[0])
	const labels = payload.posts.map((i) => moment(i[1]).format("Wo MMM"))

	const chart = new Chart("posts-per-week", {
		type: "bar",
		data: {
			labels: labels,
			datasets: [
				{ 
					backgroundColor: Chart.helpers.color(colors.purple).alpha(0.5).rgbString(),
					label: '# of Posts',
					data: data
				}
			]
		}
	})
})

channel.on("on_bookmarks", function (payload) {
	const data = payload.bookmarks.map((i) => i[0])
	const labels = payload.bookmarks.map((i) => moment(i[1]).format("Wo MMM"))

	const chart = new Chart("bookmarks-per-week", {
		type: "bar",
		data: {
			labels: labels,
			datasets: [
				{ 
					backgroundColor: Chart.helpers.color(colors.teal).alpha(0.5).rgbString(),
					label: '# of Bookmarks',
					data: data
				}
			]
		}
	})
})

channel.on("on_likes", function (payload) {
	const data = payload.likes.map((i) => i[0])
	const labels = payload.likes.map((i) => moment(i[1]).format("Wo MMM"))

	const chart = new Chart("likes-per-week", {
		type: "bar",
		data: {
			labels: labels,
			datasets: [
				{ 
					backgroundColor: Chart.helpers.color(colors.green).alpha(0.5).rgbString(),
					label: '# of Likes',
					data: data
				}
			]
		}
	})
})


document.addEventListener('DOMContentLoaded', function () {
	channel.join()
		.receive("ok", resp => {console.log("Joined successfully", resp) })
		.receive("error", resp => { console.log("Unable to join", resp) })

	channel.push("get_listens")
	channel.push("get_posts")
	channel.push("get_bookmarks")
	channel.push("get_likes")
})