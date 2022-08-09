import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    var modal = document.getElementById('confirmModal')

    modal.addEventListener('show.bs.modal', function (event) {
      var modalTitle = modal.querySelector('.modal-title')
      var modalBody = modal.querySelector('.modal-body')
      var button = event.relatedTarget

      var type = button.getAttribute('data-bs-message-type')
      var name = button.getAttribute('data-bs-message-name')
      var url = button.getAttribute('data-bs-message-url')

      let title = modalTitle.innerHTML.replace(/_type_/, type)
      let body = modalBody.innerHTML.replace(/_name_/, name).replace(/_type_/, type)

      modalTitle.innerHTML = title
      modalBody.innerHTML = body
      modal.querySelector('form').setAttribute('action', url)
    })
  }
}
