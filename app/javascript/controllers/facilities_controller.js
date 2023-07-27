import { Controller } from "@hotwired/stimulus"
import Tagify from "@yaireo/tagify"
import tagList from 'commons/tag_list';
import logo from 'commons/logo';

export default class extends Controller {
  static targets = [ "email", "website", "fbpage", "tel", "tagList" ]

  connect() {
    logo.init();
    this._initEmailTagify();
    this._initWebsiteTagify(this.websiteTarget);
    this._initWebsiteTagify(this.fbpageTarget);
    this._initTelTagify();

    tagList.initTagify(this.tagListTarget);
  }

  _initTelTagify() {
    new Tagify(this.telTarget);
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
    tagList.reassignValueWithComma($(this.tagListTarget));
  }

  _reassignValue(target) {
    if (target.val().length) {
      let transformValue = JSON.parse(target.val()).map(x => x.value);
      target.val(`{${transformValue.join(',')}}`);
    }
  }
}
