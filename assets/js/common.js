// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import $ from "jquery"
import Prism from 'prismjs'
import Dailychart from 'dailychart'
import Masonry from 'masonry-layout'

import "imagelightbox"
import "phoenix_html"

import "./webauthn/login.js"
import Skycons from '../vendor/skycons.js'

// Register Service Worker
if ('serviceWorker' in navigator) {
  navigator.serviceWorker.register('/sw.js')
    .then(function(reg){
      console.debug("Service worker registered.");
   }).catch(function(err) {
      console.error("Service worker not registered. This happened:", err)
  });
}

$(function() {
  // Highlight Syntax
  Prism.highlightAll()

  const grid = document.querySelector(".grid")
  const msnry = new Masonry(grid, {
    itemSelector: '.grid-item',
    columnWidth: '.grid-sizer',
    percentPosition: false,
    gutter: 10
  })

  Dailychart.create('#artist-listen-chart', { 
    lineWidth: 2, 
    height: 30, 
    width: 200,
    colorPositive: '#00d1b2',
    fillPositive: '#00d1b290'
  });

  $('a[data-imagelightbox="x"]').imageLightbox({
    overlay:true,
    caption: true
  });

  // Animated Weather
  const $weatherCanvas = document.querySelector('canvas#weather')
  const skycons = new Skycons({
    monochrome: false
  })

  if ($weatherCanvas) {
    const icon = $weatherCanvas.dataset["icon"]
    const skyconsId = icon.toUpperCase().replace(/-/g, "_")

    skycons.add("weather", Skycons[skyconsId])
    skycons.play()
  }

  // Get all "navbar-burger" elements
  const $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);

  // Check if there are any navbar burgers
  if ($navbarBurgers.length > 0) {

    // Add a click event on each of them
    $navbarBurgers.forEach( el => {
      el.addEventListener('click', () => {

        // Get the target from the "data-target" attribute
        const target = el.dataset.target;
        const $target = document.getElementById(target);

        // Toggle the "is-active" class on both the "navbar-burger" and the "navbar-menu"
        el.classList.toggle('is-active');
        $target.classList.toggle('is-active');

      });
    });
  }
})
