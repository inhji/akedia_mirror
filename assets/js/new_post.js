import Vue from 'vue'
import tags from 'bulma-tagsinput'
import EmojiButton from '@joeattardi/emoji-button'

window.addEventListener('DOMContentLoaded', () => {
  const button = document.querySelector('#emoji-button')

  if (!button) return

  const picker = new EmojiButton()

  picker.on('emoji', emoji => {
    document.querySelector('#content-area').value += emoji
  })

  button.addEventListener('click', () => {
    picker.pickerVisible ? picker.hidePicker() : picker.showPicker(button)
  })
})

if (document.querySelector("form.vue")) {
  new Vue({
    el: "form.vue",
    data: {
      charCount: 0,
      maxChars: 400,
      zenActive: false
    },
    mounted() {
      tags.attach()
    },
    methods: {
      updateCharCount(e) {
        const charCount = e.target.value.length
        this.charCount = charCount
      },
      closeZen() {
        this.zenActive = false
      }
    }
  })
}