import { Controller } from "@hotwired/stimulus"
import tooltip from "commons/tooltip"

export default class extends Controller {
  connect() {
    tooltip.init();
  }

  toggleSaveButton(event) {
    $("#importModals .btn-primary").attr('disabled', !event.target.value)
  }
}
