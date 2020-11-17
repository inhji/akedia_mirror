import MainView from '../main';
import tags from 'bulma-tagsinput'
import Zen from '../../zen'

export default class View extends MainView {
  mount() {
    super.mount();

    // Attach Tagsinput
    tags.attach()

    // Attach Zen Input
    Zen.attach()
  }

  unmount() {
    super.unmount();
  }
};