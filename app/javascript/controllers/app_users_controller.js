import { Controller } from "@hotwired/stimulus"
import datePicker from "commons/filter_date_picker";
import noUiSlider from "nouislider";

export default class extends Controller {
  rawLabel = "";

  connect() {
    this.rawLabel = document.getElementById('age-range-label').innerHTML;

    datePicker.init();
    this.initAgeRageSlider();
  }

  initAgeRageSlider() {
    let slider = document.getElementById('slider-round');
    let inputStartAge = document.getElementById('start-age');
    let inputEndAge = document.getElementById('end-age');
    let minAge = -1;
    let maxAge = 99;
    let self = this;

    noUiSlider.create(slider, {
      start: [(inputStartAge.value || minAge), (inputEndAge.value || maxAge)],
      connect: true,
      range: {
        'min': minAge,
        'max': maxAge
      },
      step: 1,
    });

    slider.noUiSlider.on('update', function (values, handle) {
      let value = Math.round(values[handle]);

      if (handle) {
        inputEndAge.value = value;
      } else {
        inputStartAge.value = value;
      }

      self._updateAgeLabel(inputStartAge.value, inputEndAge.value);
    });
  }

  _updateAgeLabel(startAge, endAge) {
    let str = this.rawLabel.replace(/start_age/g, startAge);
    str = str.replace(/end_age/g, endAge);

    document.getElementById('age-range-label').setHTML(str);
  }
}
