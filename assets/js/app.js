// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import Prism from 'prismjs'
import tags from 'bulma-tagsinput'
import { EmojiButton } from '@joeattardi/emoji-button';

import "phoenix_html"

import "./webauthn/login.js"
import "./webauthn/register.js"

import Skycons from '../vendor/skycons.js'

// Register Service Worker
if ('serviceWorker' in navigator) {
  navigator.serviceWorker.register('/sw.js')
    .catch(function(err) {
        console.error("Service worker not registered. This happened:", err)
    });
}

document.addEventListener("DOMContentLoaded", function () {
  const $form = document.querySelector("form.post")
  const $weatherCanvas = document.querySelector('canvas#weather')
  const $emojiButton = document.querySelector('#emoji-button')
  const $zenTextarea = document.querySelector(".zen textarea")
  const $zenCheckbox = document.querySelector(".zen input[type=checkbox]")
  const ESC = 27

  if ($form) {
    // Attach Tagsinput
    tags.attach()

    // Add Zen Close from textarea
    $zenTextarea.addEventListener("keydown", function (e) {
      if (e.keyCode === ESC) {
        $zenCheckbox.checked = false
      }
      console.log(e.keyCode)
    })
  }

  if ($emojiButton) {
    const picker = new EmojiButton()

    picker.on('emoji', selection => {
      document.querySelector('#content-area').value += ` ${selection.emoji} `
    })

    $emojiButton.addEventListener('click', () => {
      picker.togglePicker($emojiButton)
    })
  }

  // Highlight Syntax
  Prism.highlightAll()

  // Animated Weather 
  if ($weatherCanvas) {
    const skycons = new Skycons({ monochrome: false })
    const icon = $weatherCanvas.dataset["icon"]
    const skyconsId = icon.toUpperCase().replace(/-/g, "_")

    skycons.add("weather", Skycons[skyconsId])
    skycons.play()
  }

  // Navbar Burger
  const $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);

  if ($navbarBurgers.length > 0) {
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
