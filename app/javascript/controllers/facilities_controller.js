import { Controller } from "@hotwired/stimulus"
import Tagify from "@yaireo/tagify"
import toggleCollapse from "commons/toggle_collapse";

export default class extends Controller {
  static targets = [ "email", "website", "fbpage", "tel", "tagList" ]
  localStorageKey = "advance_search_clinic";

  connect() {
    this._initEmailTagify();
    this._initWebsiteTagify(this.websiteTarget);
    this._initWebsiteTagify(this.fbpageTarget);
    this._initTelTagify();
    this._initTagTagify();
  }

  _initTelTagify() {
    new Tagify(this.telTarget);
  }

  _initTagTagify() {
    new Tagify(this.tagListTarget, {
      whitelist: $(this.tagListTarget).data('tags'),
      dropdown: { maxItems: 20, classname: "tags-look", enabled: 0, closeOnSelect: false }
    });
  }

  _initEmailTagify() {
    new Tagify(this.emailTarget, {
      pattern: /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    })
  }

  // @Todo: Pattern not workable yet
  _initWebsiteTagify(target) {
    new Tagify(target), {
      pattern: /https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)/
    }
  }

  submitForm(e) {
    this._reassignValue($(this.emailTarget));
    this._reassignValue($(this.websiteTarget));
    this._reassignValue($(this.fbpageTarget));
    this._reassignValue($(this.telTarget));
    this._reassignValueWithComma($(this.tagListTarget));
  }

  _reassignValue(target) {
    if (target.val().length) {
      let transformValue = JSON.parse(target.val()).map(x => x.value);
      target.val(`{${transformValue.join(',')}}`);
    }
  }

  _reassignValueWithComma(target) {
    if (target.val().length) {
      let transformValue = JSON.parse(target.val()).map(x => x.value);
      target.val(`${transformValue.join(',')}`);
    }
  }
}
