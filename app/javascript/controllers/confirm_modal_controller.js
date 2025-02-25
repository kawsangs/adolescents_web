import { Controller } from "@hotwired/stimulus"
import confirmModal from 'commons/confirm_modal';

export default class extends Controller {
  static values = {
    domId: String
  };
  connect() {
    confirmModal.init(this.domIdValue);
  }
}
