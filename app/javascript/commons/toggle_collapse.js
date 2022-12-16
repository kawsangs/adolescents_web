export default (function() {
  return { init, handleLocalStorage };

  function init(localStorageKey='advance_search') {
    let css_class = localStorage.getItem(localStorageKey);

    if(!!css_class) {
      document.getElementById('collapseOne').classList.add(css_class);
    }
  }

  function handleLocalStorage(localStorageKey) {
    let css_class = !!localStorage.getItem(localStorageKey) ? '' : 'show'

    localStorage.setItem(localStorageKey, css_class);
  }
})();
