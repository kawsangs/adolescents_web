import "bootstrap"

export default (function() {
  return { init };

  function init() {
    initAlert();
  }

  function initAlert() {
    var alertList = document.querySelectorAll('.alert')
    alertList.forEach(function (alert) {
      new bootstrap.Alert(alert)
    })
  }
})();
