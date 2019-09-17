import "phoenix_html"
import "./webauthn.js"
import "./new_post.js"
import Chart from "chart.js"
import moment from "moment"

import Vue from 'vue'
import AppComponent from './components/AdminComponent.vue'

document.addEventListener('DOMContentLoaded', function () {
	new Vue({ 
		render: h => h(AppComponent),
	}).$mount('#app')
})

