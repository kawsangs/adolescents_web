import { Controller } from "@hotwired/stimulus"
import "libs/tempusDominus.min";

export default class extends Controller {
  static targets = [ "title", "body", "titleCount", "bodyCount" ];
  static picker;

  connect() {
    let options = {};

    if(!!$('#mobile_notification_schedule_date').val()) {
      options.defaultDate = $('#mobile_notification_schedule_date').val();
    }

    this.picker = new tempusDominus.TempusDominus(document.getElementById('schedule_date'), options);
  }

  toggleAppVersion(event) {
    const selectElement = event.target;
    const appVersionContainer = document.getElementById('appVersion');
    const appVersionTitle = appVersionContainer.querySelector('label span');

    if (selectElement.value) {
      appVersionTitle.textContent = selectElement.options[selectElement.selectedIndex].text;
      appVersionContainer.classList.remove('d-none');
    } else {
      appVersionContainer.classList.add('d-none');
      $('#appVersion select').selectpicker('val', []);
    }
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
    } else {
      $('#mobile_notification_schedule_date').val('');
    }

    $(e.target).parents('form').submit();
  }
}
