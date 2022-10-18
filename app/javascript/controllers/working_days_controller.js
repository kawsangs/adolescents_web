import { Controller } from "@hotwired/stimulus"
import selectPicker from "commons/select_picker"

export default class extends Controller {
  static targets = [ "open", "openAt", "closeAt", "workingDay", "btnAddHour" ]

  connect() {
    this.handleOpenSwitch();
    this.onChangeOpenAt();
    this._handlDisplayBtnAddHourWith24Hours();
    this._handleToggleBtnAddHourWithMultipleSession();
  }

  onChangeOpenAt() {
    if(this.openAtTarget.value == 24) {
      this._hideInputCloseAt();
    } else {
      this._showInputCloseAt();
    }

    this._handlDisplayBtnAddHourWith24Hours();
    this._handleToggleBtnAddHourWithMultipleSession();
  }

  _hideInputCloseAt() {
    let wrapper = this._parentWrapper();

    wrapper.find('.dash').addClass('d-none');
    wrapper.find('.close-at').addClass('d-none');
  }

  _showInputCloseAt() {
    let wrapper = this._parentWrapper();

    wrapper.find('.dash').removeClass('d-none');
    wrapper.find('.close-at').removeClass('d-none');
  }

  onChangeCloseAt() {
    this._handlDisplayBtnAddHourWith24Hours();
    this._handleToggleBtnAddHourWithMultipleSession();
  }

  appendField(event) {
    event.preventDefault();

    let dom = $(this.btnAddHourTarget);
    let time = new Date().getTime();
    let regexp = new RegExp(dom.data('id'), 'g');
    let field = $(dom.data('fields').replace(regexp, time));

    dom.parent().prev().append(field);
    selectPicker.init();

    this._handleToggleBtnAddHourWithMultipleSession();
  }

  _handleToggleBtnAddHourWithMultipleSession() {
    if(this._visibleSessions().length >= 2) {
      this._hideBtnAddHour();
      this._showBtnRemoveHours();
    }
  }

  _showBtnRemoveHours() {
    $(this.workingDayTarget).find('.btn-remove-hour').removeClass('d-none');
  }

  _visibleSessions() {
    return $(this.btnAddHourTarget).parents('.working-hours').find("fieldset:not('.d-none')");
  }

  _parentWrapper() {
    return $(this.workingDayTarget);
  }

  _handlDisplayBtnAddHourWith24Hours() {
    let hours = this._getTargetValues(this.openAtTargets).concat(this._getTargetValues(this.closeAtTargets));
    hours = hours.filter(x => x == '0' || !!x);

    if (hours.includes('24') || hours.length < 2)
      return this._hideBtnAddHour();

    this._showBtnAddHour();
  }

  _hideBtnAddHour() {
    $(this.workingDayTarget).find('.add-hour a').addClass('d-none');
  }

  _showBtnAddHour() {
    $(this.workingDayTarget).find('.add-hour a').removeClass('d-none');
  }

  _getTargetValues(target) {
    return target.map(x => x.value);
  }

  handleOpenSwitch() {
    if (this.openTarget.checked)
      return this._showWorkingHours();

    this._hideWorkingHours();
  }

  _hideWorkingHours() {
    $(this.openTarget).parents('.working-day').addClass('closed');
  }

  _showWorkingHours() {
    $(this.openTarget).parents('.working-day').removeClass('closed');
  }
}
