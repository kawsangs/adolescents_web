import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggleSaveButton(event) {
    $("#importModals .btn-primary").attr('disabled', !event.target.value)
  }
}
