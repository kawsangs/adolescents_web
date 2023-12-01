import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.onSelectReason()
  }

  onSelectReason() {
    $('input[type=radio][name="app_user[reason_code]"]').change(function() {
       $(".btn-submit").removeClass('disabled')
    });
  }
}
