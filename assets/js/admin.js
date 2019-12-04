// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import adminCss from "../css/admin.scss"

import "phoenix_html"
import "./webauthn/register.js"
import "./new_post.js"
import Chart from "chart.js"
import moment from "moment"
import Slideout from "slideout"

var slideout = new Slideout({
  'panel': document.getElementById('panel'),
  'menu': document.getElementById('menu'),
  'padding': 256,
  'tolerance': 70
});

const toggleListeners = document.querySelectorAll('[toggles]');

Array.from(toggleListeners).forEach((listener) => {
  listener.addEventListener('click', () => {
    const target = document.querySelector(listener.getAttribute('toggles-target'));
    target.classList.toggle(listener.getAttribute('toggles-class'));
  });
});

