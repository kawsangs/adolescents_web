import { Controller } from "@hotwired/stimulus";
import datePicker from "commons/filter_date_picker";

export default class extends Controller {
  connect() {
    datePicker.init();
  }
}
