import { Controller } from "@hotwired/stimulus";
import confirm_modal from 'confirm_modal';

export default class extends Controller {
  connect() {
    confirm_modal.init('confirmModalPublish');
  }
}
