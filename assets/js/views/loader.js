import MainView from './main';

export default function loadView(viewPath) {
  return import(`./${viewPath}`)
  	.then(function ({ default: ViewClass }) {
  		return {
		  	view: new ViewClass(),
		  	path: viewPath
		  }
  	})
  	.catch(function (e) {
  		return {
  			view: new MainView(),
  			path: viewPath
  		}		
  	})
}