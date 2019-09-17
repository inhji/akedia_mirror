import {Socket} from "phoenix"

const socket = new Socket("/socket")
socket.connect()

// Now that you are connected, you can join channels with a topic:
export const channel = socket.channel("admin:dashboard", {})

channel.join()
	.receive("ok", resp => {console.log("Joined successfully", resp) })
	.receive("error", resp => { console.log("Unable to join", resp) })