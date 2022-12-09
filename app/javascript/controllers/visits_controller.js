import { Controller } from "@hotwired/stimulus"
import datePicker from "commons/filter_date_picker";

export default class extends Controller {
  localStorageKey = "advance_search_visit";

  connect() {
    datePicker.init();
    this.initAdvanceSearchToggle();
  }

  initAdvanceSearchToggle() {
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
