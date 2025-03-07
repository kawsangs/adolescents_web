export default (function() {
  return {
    init
  }

  function init() {
    onChangeLogoFile();
    onClickButtonDeleteLogo();
    onClickBtnView();
  }

  function onClickBtnView() {
    $('.btn-view').on('click', function(e) {
      let themBgSrc = querySelectorInParent(e.target, 'img.preview-image').attr('src');
      let url = this.checked ? `url('${themBgSrc}')` : 'none';

      setPreviewTheme(url);
    })
  }

  function setPreviewTheme(url) {
    $('#theme-bg').css({'background-image': url});
  }

  function onClickButtonDeleteLogo() {
    $('.btn-delete').on('click', function(e) {
      e.preventDefault;
      e.stopPropagation();

      showDefaultImage(this);
      hideDeleteButton(this);
      setCheckRemoveAvatar(this);
      removeErrorMessage(this);
      hideButtonView(this);
    })
  }

  function onChangeLogoFile() {
    $(".image-parent input").change(function() {
      readURL(this);
      showButtonView(this);
      showButtonDelete(this);
      setUncheckRemoveAvatar(this);
    });
  }

  function showButtonView(dom) {
    let btnView = querySelectorInParent(dom, '.btn-view');
    btnView.removeClass('d-none');
  }

  function hideButtonView(dom) {
    let btnView = querySelectorInParent(dom, '.btn-view');
    btnView.addClass('d-none');
  }

  function setCheckRemoveAvatar(dom) {
    let checkBox = querySelectorInParent(dom, '.checkbox-remove')
    checkBox.attr('checked', true);
  }

  function setUncheckRemoveAvatar(dom) {
    let checkBox = querySelectorInParent(dom, '.checkbox-remove')
    checkBox.attr('checked', false);
  }

  function showDefaultImage(dom) {
    let imagePreview = querySelectorInParent(dom, 'img');
    imagePreview.attr('src', imagePreview.data('default'));
  }

  function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      let imagePreview = querySelectorInParent(input, 'img');

      reader.onload = function(e) {
        imagePreview.attr('src', e.target.result);
      }

      reader.readAsDataURL(input.files[0]);
    }
  }

  function showButtonDelete(dom) {
    let btnDelete = querySelectorInParent(dom, '.btn-delete');
    btnDelete.removeClass('d-none');
  }

  function hideDeleteButton(dom) {
    let btnDelete = querySelectorInParent(dom, '.btn-delete');
    btnDelete.addClass('d-none');
  }

  function removeErrorMessage(dom) {
    let errorMessage = querySelectorInParent(dom, '.text-danger');
    errorMessage.remove();
  }

  function querySelectorInParent(dom, selector) {
    return $(dom).parents('.image-parent').find(selector);
  }

})();
