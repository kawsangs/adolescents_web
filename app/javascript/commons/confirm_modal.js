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

      // Replace the title and body content with the data content attributes
      const elements = modal.querySelectorAll('[data-content]');
      elements.forEach(element => {
        const newContent = element.getAttribute('data-content').replace(/_name_/, name).replace(/_type_/, type);
        element.innerHTML = newContent;
      });

      modal.querySelector('form').setAttribute('action', url)
    })
  }
})();
