export default (function() {
  return { init };

  function init(modalId='confirmModal') {
    var modal = document.getElementById(modalId)

    modal.addEventListener('show.bs.modal', function (event) {
      var modalTitle = modal.querySelector('.modal-title')
      var modalBody = modal.querySelector('.modal-body')
      var button = event.relatedTarget

      var type = button.getAttribute('data-bs-message-type')
      var name = button.getAttribute('data-bs-message-name')
      var url = button.getAttribute('data-bs-message-url')

      let title = modalTitle.getAttribute('data-content').replace(/_type_/, type)
      let body = modalBody.getAttribute('data-content').replace(/_name_/, name).replace(/_type_/, type)

      modalTitle.innerHTML = title
      modalBody.innerHTML = body
      modal.querySelector('form').setAttribute('action', url)
    })
  }
})();
