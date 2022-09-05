import { Controller } from "@hotwired/stimulus"
import datePicker from "filter_date_picker";

export default class extends Controller {
  connect() {
    datePicker.init();
  }
}
