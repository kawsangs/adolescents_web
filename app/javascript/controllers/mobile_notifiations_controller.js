import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "title", "body", "titleCount", "bodyCount" ]

  updateTitle(e) {
    this.titleTarget.innerHTML = e.target.value;
    this.titleCountTarget.innerHTML = e.target.value.length;
  }

  updateBody(e) {
    this.bodyTarget.innerHTML = e.target.value;
    this.bodyCountTarget.innerHTML = e.target.value.length;
  }
}
