import "phoenix_html"
import loadView from './views/loader';

//
// Page specific JavaScript in Phoenix framework
// http://codeloveandboards.com/blog/2016/04/26/page-specific-javascript-in-phoenix-framework-pt-2/
// 

function handleDOMContentLoaded() {
  const viewName = document.getElementsByTagName('body')[0].dataset.jsViewPath;

  const {view: view, path: path} = loadView(viewName);

  console.log(`Mounting view for ${path}`)
  view.mount();

  window.currentView = view;
}

function handleDocumentUnload() {
  window.currentView.unmount();
}

window.addEventListener('DOMContentLoaded', handleDOMContentLoaded, false);
window.addEventListener('unload', handleDocumentUnload, false);

// Register Service Worker
if ('serviceWorker' in navigator) {
  navigator.serviceWorker.register('/sw.js')
    .catch(function(err) {
        console.error("Service worker not registered. This happened:", err)
    });
}
