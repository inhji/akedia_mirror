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
import "phoenix_html"
import "bootstrap"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"
import "./offcanvas"
import "./media_library"
import "./zenmode"
import "./prism"


document.addEventListener('DOMContentLoaded', function() {
  const searchBar = document.querySelector('.search-bar');
  const searchInput = document.querySelector('.search-bar input.search-input')

  searchBar.addEventListener('focusin', () => searchInput.focus());
  searchBar.addEventListener('focusout', () => searchInput.value = "")
})

document.addEventListener('DOMContentLoaded', () => {

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

});

if ('serviceWorker' in navigator) {
  navigator.serviceWorker.register('/sw.js')
    .then(function(reg){
      console.log("Service worker registered.");
   }).catch(function(err) {
      console.log("Service worker not registered. This happened:", err)
  });
 }
