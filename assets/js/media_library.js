import $ from "jquery"
import "../vendor/image_picker/image_picker"

function splitIds(ids) {
  if (ids === "") return []
  return ids
    .split(",")
    .map(id => id.trim())
    .map(id => parseInt(id, 10))
}

document.addEventListener('DOMContentLoaded', function() {
  const saveButton = document.querySelector('#mediaLibrary #save')
  const clearButton = document.querySelector('#clear')
  const imageIdsInput = document.querySelector('#image-ids')
  const selectedImages = document.querySelector('.image-picker')

  saveButton && saveButton.addEventListener('click', function() {
    let newIds = [].slice.call(selectedImages.selectedOptions).map(el => el.value)
    imageIdsInput.value = newIds.join(", ")
  })

  clearButton && clearButton.addEventListener("click", function() {
    imageIdsInput.value = ""
  })

  $(".image-picker").imagepicker()
})
