// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

import "phoenix_html"

import {Socket} from "phoenix"
import NProgress from "nprogress"
import LiveSocket from "phoenix_live_view"

import loadView from './views/loader'
import Hooks from './hooks'

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  hooks: Hooks,
  params: {_csrf_token: csrfToken}
})

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())

// Connect if there are any LiveViews on the page
liveSocket.connect()

// Expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
// The latency simulator is enabled for the duration of the browser session.
// Call disableLatencySim() to disable:
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

//
// Page specific JavaScript in Phoenix framework
// http://codeloveandboards.com/blog/2016/04/26/page-specific-javascript-in-phoenix-framework-pt-2/
// 

function handleDOMContentLoaded() {
  const viewName = document.getElementsByTagName('body')[0].dataset.jsViewPath;

  const {view: view, path: path} = loadView(viewName);

  loadView(viewName)
  	.then(function({view: view, path: path}) {
  		console.log(`Mounting view for ${path}`)
  		view.mount();
  		window.currentView = view;
  	})  
}

function handleDocumentUnload() {
  window.currentView.unmount();
}

window.addEventListener('DOMContentLoaded', handleDOMContentLoaded, false);
window.addEventListener('unload', handleDocumentUnload, false);

// Register Service Worker
if ('serviceWorker' in navigator) {
  navigator.serviceWorker.register('/sw.js')
    .catch(function(err) {
        console.error("Service worker not registered. This happened:", err)
    });
}
