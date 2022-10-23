import { Controller } from "@hotwired/stimulus"
import confirmModal from 'commons/confirm_modal';

export default class extends Controller {
  connect() {
    confirmModal.init('confirmModal');
  }
}
