export default (function() {
  return {
    init
  }

  function init() {
    console.log("init")
    onChangeLogoFile();
    onClickButtonDeleteLogo();
  }

  function onClickButtonDeleteLogo() {
    $('.btn-delete').on('click', function() {
      showDefaultImage();
      hideDeleteButton();
      setCheckRemoveAvatar();
    })
  }

  function onChangeLogoFile() {
    $(".logo-input").change(function() {
      readURL(this);
      showButtonDelete();
      setUncheckRemoveAvatar();
    });
  }

  function setCheckRemoveAvatar() {
    $('.remove-logo-wrapper input').attr('checked', true);
  }

  function showDefaultImage() {
    $('.preview-logo').attr('src', $('.preview-logo').data('default'));
  }

  function hideDeleteButton() {
    $('.btn-delete').addClass('d-none');
  }

  function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();

      reader.onload = function(e) {
        $('.preview-logo').attr('src', e.target.result);
      }

      reader.readAsDataURL(input.files[0]);
    }
  }

  function showButtonDelete() {
    $('.btn-delete').removeClass('d-none');
  }

  function setUncheckRemoveAvatar() {
    $('#user_remove_avatar').attr('checked', false);
  }
})();
