import "phoenix_html"
import "./webauthn.js"
import "./new_post.js"
import Dailychart from 'dailychart'

document.addEventListener('DOMContentLoaded', function () {
  Dailychart.create('.chart', { 
    lineWidth: 2,
    colorPositive: "#000" 
  });
})