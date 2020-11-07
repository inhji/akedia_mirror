import Prism from 'prismjs'
// import Skycons from './skycons.js'

export default class MainView {
  mount() {
    // Highlight Syntax
    Prism.highlightAll()

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

    // Animated Weather 
    // if ($weatherCanvas) {
    //   const skycons = new Skycons({ monochrome: false })
    //   const icon = $weatherCanvas.dataset["icon"]
    //   const skyconsId = icon.toUpperCase().replace(/-/g, "_")

    //   skycons.add("weather", Skycons[skyconsId])
    //   skycons.play()
    // }
  }

  unmount() {}
}