import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "btnRemoveHour" ]

  removeField(event) {
    event.preventDefault();

    this._hideWorkingHourField();
    this._handleToggleBtnAddHour();
  }

  _hideWorkingHourField() {
    let dom = $(this.btnRemoveHourTarget);

    dom.parent().find('input[type=hidden]').val('1');
    dom.parents('fieldset').addClass('d-none');
  }

  _handleToggleBtnAddHour() {
    if(this._visibleSessions().length < 2) {
      this._showBtnAddHour();
      this._hideBtnRemoveHours();
    }
  }

  _visibleSessions() {
    return $(this.btnRemoveHourTarget).parents('.working-hours').find("fieldset:not('.d-none')");
  }

  _showBtnAddHour() {
    this._wrapper().find('.add-hour a').removeClass('d-none');
  }

  _hideBtnRemoveHours() {
    this._wrapper().find('.btn-remove-hour').addClass('d-none');
  }

  _wrapper() {
    return $(this.btnRemoveHourTarget).parents('.working-hours');
  }
}
