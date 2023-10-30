export default (function() {
  return { init }

  function init() {
    onRemoveAudio();
    onChangeAudio();
  }

  function onRemoveAudio() {
    $(document).on('click', '.remove-file-button', function(e) {
      let wrapper = $(e.target).parents('.file-wrapper')

      wrapper.find('.file-inputbox').parent().removeClass('d-none')
      wrapper.find('.remove-file-checkbox').val(1)
      wrapper.find('.remove-file-wrapper').hide()
    })
  }

  function onChangeAudio() {
    $(document).on('change', '.file-inputbox', function(e) {
      let wrapper = $(e.target).parents('.file-wrapper')
      !!wrapper.find('.remove-file-checkbox') && wrapper.find('.remove-file-checkbox').val(0)
    })
  }
})();
