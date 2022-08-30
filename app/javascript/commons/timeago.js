export default (function() {
  return { init };

  function init() {
    onClickDate();
  }

  function onClickDate() {
    $(document).off('click', '.timeago')
    $(document).on('click', '.timeago', function(event) {
      $(this).html($(this).data('date'))
      $(this).off('click')
    });
  }
})();
