import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "btnRemoveFile", "inputAudio" ]

  removeAudio(event) {
    event.preventDefault();

    let wrapper = $(this.btnRemoveFileTarget).parents('.file-wrapper')

    wrapper.find('.file-inputbox').parent().removeClass('d-none');
    wrapper.find('.remove-file-checkbox').val(1);
    wrapper.find('.remove-file-wrapper').hide();
  }

  updateAudio(event) {
    let wrapper = $(this.inputAudioTarget).parents('.file-wrapper')
    !!wrapper.find('.remove-file-checkbox') && wrapper.find('.remove-file-checkbox').val(0)
  }
}
