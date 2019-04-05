const zenmodeCheckbox = document.querySelector('#zen-toggle-comment')
const ESC = 27

document.addEventListener('keyup', function(e) {
  if (e.keyCode === ESC && zenmodeCheckbox && zenmodeCheckbox.checked) {
    e.preventDefault();
    zenmodeCheckbox.checked = false
  }
})
