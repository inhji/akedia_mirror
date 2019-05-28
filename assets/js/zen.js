document.addEventListener('DOMContentLoaded', function() {
  const zenCheckbox = document.querySelector('#zen-toggle-comment')
  const ESC = 27

  document.addEventListener('keyup', function(e) {
    if (e.keyCode === ESC && zenCheckbox && zenCheckbox.checked) {
      e.preventDefault();
      zenCheckbox.checked = false
    }
  })
})
