import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this._init();
  }

  _init() {
    this._handleDisplayToggle()
    this._onChangeTelegramToggle()
  }

  _onChangeTelegramToggle() {
    let self = this;
    $(document).off('change', "[name='telegram_bot[enabled]']");
    $(document).on('change', "[name='telegram_bot[enabled]']", function(event) {
      self._handleDisplayToggle();
    });
  }

  _handleDisplayToggle() {
    let isChecked = !!$("[name='telegram_bot[enabled]']:checked").length;

    $('.tokens').toggleClass('d-none', !isChecked);
  };
}
