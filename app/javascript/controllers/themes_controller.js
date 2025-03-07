import { Controller } from "@hotwired/stimulus"
import "jquery-minicolors";
import imageFile from 'commons/image_file';

document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll('[data-bs-toggle="popover"]').forEach((popover) => {
    new bootstrap.Popover(popover);
  });
});

export default class extends Controller {
  connect() {
    let self = this;
    imageFile.init();
    this.initPreviewTheme();
    this.initializeMinicolors('#theme_primary_color', self.onChangeBgPrimaryColor);
    this.initializeMinicolors('#theme_secondary_color', self.onChangeBgSecondaryColor);
    this.initializeMinicolors('#theme_primary_text_color', self.onChangePrimaryTextColor);
    this.initializeMinicolors('#theme_secondary_text_color', self.onChangeSecondaryTextColor);
  }

  onChangePrimaryTextColor(value, opacity) {
    $('.primary-text-color').css({color: value});
  }

  onChangeSecondaryTextColor(value, opacity) {
    $('.secondary-text-color').css({color: value});
  }

  onChangeBgPrimaryColor(value, opacity) {
    let primaryColor = value;
    let secondaryColor = $('#theme_secondary_color').val() || primaryColor;
    let bgColor = `linear-gradient(135deg, ${secondaryColor}, ${primaryColor})`;

    $('.primary-bg-color').css({background: primaryColor});
    $('.primary-color').css({color: primaryColor});
    $('.preview-bg').css({background: bgColor});
  }

  onChangeBgSecondaryColor(value, opacity) {
    let secondaryColor =  value;
    let primaryColor = $('#theme_primary_color').val() || secondaryColor;
    let bgColor = `linear-gradient(135deg, ${secondaryColor}, ${primaryColor})`;

    $('.secondary-color').css({color: secondaryColor});
    $('.preview-bg').css({background: bgColor});
  }

  initPreviewTheme() {
    let primaryColor = $('#theme_primary_color').val() || '#1E40AF';
    let secondaryColor = $('#theme_secondary_color').val() || '#ea33db';
    let bgColor = `linear-gradient(135deg, ${secondaryColor}, ${primaryColor})`;
    let primaryTextColor = $('#theme_primary_text_color').val() || '#fff';
    let secondaryTextColor = $('#theme_secondary_text_color').val() || 'rgb(33, 37, 41)';

    $('.preview-bg').css({background: bgColor});
    $('.primary-color').css({color: primaryColor});
    $('.primary-bg-color').css({background: primaryColor});
    $('.secondary-color').css({color: secondaryColor});
    $('.primary-text-color').css({color: primaryTextColor});
    $('.secondary-text-color').css({color: secondaryTextColor});
  }

  initializeMinicolors(domId, callback) {
    $(domId).minicolors({
      theme: "bootstrap",
      format: "hex",
      opacity: false,
      change: (value, opacity) => {
        !!callback && callback(value, opacity);
      },
    });
  }
}
