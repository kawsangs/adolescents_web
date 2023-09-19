import { Controller } from "@hotwired/stimulus";
import form from "commons/form";
import tagList from "commons/tag_list";

export default class extends Controller {
  connect() {
    form.init();
    form.onClickAddAssociation("form .add_sections")
  }

  submitForm(e) {
    tagList.reassignValueWithComma($("input.form-tag-list"));
    tagList.reassignValueWithComma($("input.tag-list"));
  }
}
