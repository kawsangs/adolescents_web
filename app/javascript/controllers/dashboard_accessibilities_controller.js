import { Controller } from "@hotwired/stimulus"
import Tagify from "@yaireo/tagify"

export default class extends Controller {
  static targets = [ "email" ]

  connect() {
    this._initEmailTagify();
  }

  _initEmailTagify() {
    new Tagify(this.emailTarget, {
      whitelist: $(this.emailTarget).data('emails'),
      enforceWhitelist: true,
      pattern: /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/,
      dropdown: {
        maxItems: 20,           // <- mixumum allowed rendered suggestions
        enabled: 0,             // <- show suggestions on focus
        closeOnSelect: true    // <- do not hide the suggestions dropdown once an item has been selected
      }
    })
  }

  submitForm(e) {
    this._assignUserEmails();
    this._assignUserRoles();
  }

  _assignUserEmails() {
    let target = $(this.emailTarget);
    let emails = !!target.val().length ? JSON.parse(target.val()).map(x => x.value) : [];

    this._appendToForm(emails, "dashboard_accessible_emails[]");
  }

  _assignUserRoles() {
    let roles = $( ".role :checkbox:checked" ).map( function() {
      return this.id }
    ).get();

    this._appendToForm(roles, "dashboard_accessible_roles[]");
  }

  _appendToForm(values=[], inputName) {
    let form = $(".dashboard-form");

    if (!values.length) {
      form.append($(`<input type="hidden" name="${inputName}" />`))
      return
    }

    for (var i=0; i<values.length; i++) {
      form.append($(`<input type="hidden" name="${inputName}" value="${values[i]}" />`));
    }
  }
}
