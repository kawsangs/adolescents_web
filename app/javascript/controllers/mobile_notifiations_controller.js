import { Controller } from "@hotwired/stimulus"
import "libs/tempusDominus.min";

export default class extends Controller {
  static targets = [ "title", "body", "titleCount", "bodyCount" ];
  static picker;

  connect() {
    this.picker = new tempusDominus.TempusDominus(document.getElementById('schedule_date'));
  }

  updateTitle(e) {
    this.titleTarget.innerHTML = e.target.value;
    this.titleCountTarget.innerHTML = e.target.value.length;
  }

  updateBody(e) {
    this.bodyTarget.innerHTML = e.target.value;
    this.bodyCountTarget.innerHTML = e.target.value.length;
  }

  submit(e) {
    e.preventDefault();

    if (!!$("#view-date").val()) {
      $('#mobile_notification_schedule_date').val(this.picker.viewDate);
    }

    $(e.target).parents('form').submit();
  }
}
