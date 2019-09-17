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

const toggleListeners = document.querySelectorAll('[toggles]');

Array.from(toggleListeners).forEach((listener) => {
  listener.addEventListener('click', () => {
    const target = document.querySelector(listener.getAttribute('toggles-target'));
    target.classList.toggle(listener.getAttribute('toggles-class'));
  });
});

