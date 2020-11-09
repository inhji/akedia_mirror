import MainView from '../main';
import tags from 'bulma-tagsinput'
import { EmojiButton } from '@joeattardi/emoji-button';

const ESC = 27

export default class View extends MainView {
  mount() {
    super.mount();

    const $form = document.querySelector("form.post")
    const $emojiButton = document.querySelector('#emoji-button')
    const $zenTextarea = document.querySelector(".zen textarea")
    const $zenCheckbox = document.querySelector(".zen input[type=checkbox]")
    const picker = new EmojiButton()

    // Attach Tagsinput
    tags.attach()

    // Add Zen Close from textarea
    $zenTextarea.addEventListener("keydown", function (e) {
      if (e.keyCode === ESC) {
        $zenCheckbox.checked = false
      }
    })

    picker.on('emoji', selection => {
      document.querySelector('#content-area').value += ` ${selection.emoji} `
    })

    $emojiButton.addEventListener('click', () => {
      picker.togglePicker($emojiButton)
    })
  }

  unmount() {
    super.unmount();
  }
};