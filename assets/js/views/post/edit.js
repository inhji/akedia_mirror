import MainView from '../main';
import Zen from '../../zen'
import tags from 'bulma-tagsinput'

export default class View extends MainView {
  mount() {
    super.mount();

    const $form = document.querySelector("form.post")

    // Attach Tagsinput
    tags.attach()

    // Attach Zen Input
    Zen.attach()
  }

  unmount() {
    super.unmount();
  }
};