document.addEventListener('DOMContentLoaded', function() {
  const offcanvasToggle = document.querySelector('[data-toggle="offcanvas"]')

  offcanvasToggle.addEventListener('click', function () {
    const offcanvasCollapse = document.querySelector('.offcanvas-collapse')
    offcanvasCollapse.classList.toggle('open')
  })
})
