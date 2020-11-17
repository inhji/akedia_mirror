const ESC = 27

export default {
	attach: function () {
		if (document.querySelector(".zen")) {
			const $zenTextarea = document.querySelector(".zen textarea")
		  const $zenCheckbox = document.querySelector(".zen input[type=checkbox]")

		  // Focus Textarea when Zen is opened
		  $zenCheckbox.addEventListener("click", function (e) {
		  	if (e.target.checked) {
		  		$zenTextarea.focus()
		  	}
		  })

		  // Add Zen Close from textarea
		  $zenTextarea.addEventListener("keydown", function (e) {
		    if (e.keyCode === ESC) {
		      $zenCheckbox.checked = false
		    }
		  })
		}
	}
}