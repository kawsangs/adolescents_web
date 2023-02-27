import { Controller } from "@hotwired/stimulus";
import Sortable from 'sortablejs';

export default class extends Controller {
  connect() {
    this._initSortable();
  }

  _initSortable() {
    var el = document.getElementById('tag-group');
    let self = this;
    new Sortable(el, {
        animation: 150,
        ghostClass: 'blue-background-class',
        handle: '.handle',
        store: {
            /**
             * Get the order of elements. Called once during initialization.
             * @param   {Sortable}  sortable
             * @returns {Array}
             */
            get: function (sortable) {
              var order = localStorage.getItem(sortable.options.group.name);
              return order ? order.split('|') : [];
            },

            /**
             * Save the order of elements. Called onEnd (when the item is dropped).
             * @param {Sortable}  sortable
             */
            set: function (sortable) {
              let ids = [];

              $.each(sortable.el.children, function(key, el) {
                ids.push($(el).data('tag_id'))
              })

              $.ajax({
                url: $('.tag-form').attr('url'),
                data: {
                  authenticity_token: $('[name="authenticity_token"]').val(),
                  tags: ids
                },
                type: 'POST',
                success: (response) => {
                  self._alertSuccess();
                }
              });
            }
          }
    });
  }

  _alertSuccess() {
    $("body").append('<div class="alert alert-success success-alert" role="alert">Successfully updated!</div>');

    setTimeout(function() {
      $(".success-alert").remove();
    }, 3000);
  }
}
