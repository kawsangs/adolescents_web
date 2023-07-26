import { Controller } from "@hotwired/stimulus";
import typeahead from "commons/typeahead";

export default class extends Controller {
  connect() {
    typeahead.initTypeahead($('.typeahead-directory')[0], $("[data-directories]").data('directories'));
  }
}
