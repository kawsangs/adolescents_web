import { Controller } from "@hotwired/stimulus"
import $ from 'jquery';

export default class extends Controller {
  connect() {
    this.onSubmitForm();
  }

  onSubmitForm() {
    let self = this;
    $("#session-form").on('submit', function(e) {
      if (!self.isValidEmail()) return e.preventDefault();
    })
  }

  isValidEmail() {
    const email = $(".input-email").val();

    if(!email) {
      this.showError('មិនអាចទទេរ')
      this.enableButtonSubmit();
      return false;
    }

    if (!this.validateEmail(email)) {
      this.showError('មិនត្រឹមត្រូវ');
      this.enableButtonSubmit();
      return false;
    }

    this.hideError();
    return true;
  }

  validateEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  }

  showError(error) {
    let wrapper = $('.user_email');

    wrapper.addClass('form-group-invalid');
    wrapper.find('.form-control').addClass('is-invalid');
    wrapper.find('.invalid-feedback').remove();
    wrapper.append(`<div class='invalid-feedback'>${error}</div>`);
  }

  hideError() {
    let wrapper = $('.user_email');

    wrapper.removeClass('form-group-invalid');
    wrapper.find('.form-control').removeClass('is-invalid');
    wrapper.find('.invalid-feedback').remove();
  }

  enableButtonSubmit() {
    setTimeout(() => {
      $('.btn-submit').attr('disabled',false);
    }, 100);
  }
}
