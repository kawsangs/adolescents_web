import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.initCountDown();
    this.initOtpInput();
    this.onSubmitForm();
  }

  onSubmitForm() {
    const form = document.getElementById("otp-form");
    self = this;
    form.addEventListener("submit", function (e) {
      self.updateInput();
    })
  }

  updateInput() {
    const inputs = document.querySelectorAll("#otp-input input");
    let inputValue = Array.from(inputs).reduce(
      function (otp, input) {
        otp += (input.value.length) ? input.value : ' ';
        return otp;
      },
      ""
    );
    document.querySelector("#otp-token").value = inputValue;
  }

  initOtpInput() {
    const inputs = document.querySelectorAll("#otp-input input");

    for (let i = 0; i < inputs.length; i++) {
      const input = inputs[i];

      input.addEventListener("input", function () {
        // handling normal input
        if (input.value.length == 1 && i+1 < inputs.length) {
         inputs[i+1].focus();
        }

        // if a value is pasted, put each character to each of the next input
        if (input.value.length > 1) {
          // sanitise input
          if (isNaN(input.value)) {
            input.value = "";
            return;
          }

          // split characters to array
          const chars = input.value.split('');

          for (let pos = 0; pos < chars.length; pos++) {
            // if length exceeded the number of inputs, stop
            if (pos + i >= inputs.length) break;

            // paste value
            let targetInput = inputs[pos + i];
            targetInput.value = chars[pos];
          }

          // focus the input next to the last pasted character
          let focus_index = Math.min(inputs.length - 1, i + chars.length);
          inputs[focus_index].focus();
        }
      });

      input.addEventListener("keydown", function (e) {
        // left button
        if (e.keyCode == 37) {
          if (i > 0) {
            e.preventDefault();
            inputs[i-1].focus();
            inputs[i-1].select();
          }
          return;
        }

        // right button
        if (e.keyCode == 39) {
          if (i+1 < inputs.length) {
            e.preventDefault();
            inputs[i+1].focus();
            inputs[i+1].select();
          }
          return;
        }

        // backspace button
        if (e.keyCode == 8 && input.value == '' && i != 0) {
          // shift next values towards the left
          for (let pos = i; pos < inputs.length - 1; pos++) {
            inputs[pos].value = inputs[pos + 1].value;
          }

          // clear previous box and focus on it
          inputs[i-1].value = '';
          inputs[i-1].focus();
          return;
        }

        // delete button
        if (e.keyCode == 46 && i != inputs.length - 1) {
          // shift next values towards the left
          for (let pos = i; pos < inputs.length - 1; pos++) {
            inputs[pos].value = inputs[pos + 1].value;
          }

          // clear the last box
          inputs[inputs.length - 1].value = '';

          // select current input
          input.select();

          // disallow the event delete the new value
          e.preventDefault();
          return;
        }
      })
    }
  }

  initCountDown() {
    // var timer2 = "5:00";
    var timer2 = document.getElementById('countdown').innerHTML;
    var interval = setInterval(function() {
      var timer = timer2.split(':');
      //by parsing integer, I avoid all extra string processing
      var minutes = parseInt(timer[0], 10);
      var seconds = parseInt(timer[1], 10);

      minutes = (seconds < 0) ? --minutes : minutes;
      seconds = (seconds < 0) ? 59 : seconds;
      seconds = (seconds < 10) ? '0' + seconds : seconds;

      document.getElementById('countdown').innerHTML = minutes + ':' + seconds;

      if (minutes < 0) clearInterval(interval);
      //check if both minutes and seconds are 0
      if ((seconds <= 0) && (minutes <= 0)) {
        clearInterval(interval)
        document.getElementById('countdown').innerHTML = "Session Expired"
      };

      --seconds;

      timer2 = minutes + ':' + seconds;
    }, 1000);
  }
}
