import MainView from './main';

export default function loadView(viewPath) {
  let view;

  try {
    const ViewClass = require('./' + viewPath).default;
    view = new ViewClass();
  } catch (e) {
    view = new MainView();
    viewPath = 'main'
  }

  return {
  	view: view,
  	path: viewPath
  };
}