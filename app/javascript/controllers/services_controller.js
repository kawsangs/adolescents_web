import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "btnAddService" ]

  appendField(event) {
    event.preventDefault();

    let dom = $(this.btnAddServiceTarget);
    let time = new Date().getTime();
    let regexp = new RegExp(dom.data('id'), 'g');
    let field = $(dom.data('fields').replace(regexp, time));

    dom.parents('.service-wrappers').find('.btnAddField').before(field);
  }

  removeField(event) {
    event.preventDefault();
    let wrapper = $(event.target).parents('.service-wrapper');

    wrapper.find('input[type=hidden]').val('1');
    wrapper.addClass('d-none');
  }
}
