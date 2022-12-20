import { Controller } from "@hotwired/stimulus"
import toggleCollapse from "commons/toggle_collapse";

export default class extends Controller {
  localStorageKey = "advance_search_clinic";

  connect() {
    toggleCollapse.init(this.localStorageKey);
  }

  handleLocalStorage() {
    toggleCollapse.handleLocalStorage(this.localStorageKey);
  }
}
