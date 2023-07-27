import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  localStorageKey = "";

  connect() {
    this.localStorageKey = this.data.get("variable");

    let css_class = localStorage.getItem(this.localStorageKey);

    if(!!css_class) {
      document.getElementById('collapseOne').classList.add(css_class);
    }
  }

  handleLocalStorage() {
    let css_class = !!localStorage.getItem(this.localStorageKey) ? '' : 'show'

    localStorage.setItem(this.localStorageKey, css_class);
  }
}
