import "phoenix_html"
import "./webauthn/register.js"
import "./new_post.js"
import Chart from "chart.js"
import moment from "moment"
import Slideout from "slideout"

import Vue from 'vue'
import AppComponent from './components/AdminComponent.vue'

var slideout = new Slideout({
  'panel': document.getElementById('panel'),
  'menu': document.getElementById('menu'),
  'padding': 256,
  'tolerance': 70
});

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

