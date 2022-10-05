import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "optionStatus", "btnRemoveOption" ]

  handleDisplayMessage(event) {
    event.preventDefault();
    let dom = $(this.optionStatusTarget);
    let isMoveNext = dom.val();

    if (isMoveNext == 'true') {
      dom.parents('.field-wrapper').find('.advance-options').addClass('d-none');
    } else {
      dom.parents('.field-wrapper').find('.advance-options').removeClass('d-none');
    }
  }

  removeOption(event) {
    event.preventDefault();
    let dom = $(this.btnRemoveOptionTarget);

    dom.parent().find('input[type=hidden]').val('1');
    dom.closest('fieldset').hide();
  }
}
