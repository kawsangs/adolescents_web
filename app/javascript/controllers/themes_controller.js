import { Controller } from "@hotwired/stimulus"
import imageFile from 'commons/image_file';
import "bootstrap";

import $ from "jquery";
import "jquery-minicolors";

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
    this.initializeMinicolors('#theme_bg_color_primary', self.onChangeBgPrimaryColor);
    this.initializeMinicolors('#theme_bg_color_secondary', self.onChangeBgSecondaryColor);
    this.initializeMinicolors('#theme_text_color', self.onChangeTextColor);
    this.initializeMinicolors('#theme_nav_bar_color');
  }

  onChangeTextColor(value, opacity) {
    // Todo: but need confirmation
  }

  onChangeBgPrimaryColor(value, opacity) {
    let primaryColor = value;
    let secondaryColor = $('#theme_bg_color_secondary').val() || primaryColor;
    let bgColor = `linear-gradient(135deg, ${primaryColor}, ${secondaryColor})`

    $('.preview-bg').css({background: bgColor});
  }

  onChangeBgSecondaryColor(value, opacity) {
    let secondaryColor =  value;
    let primaryColor = $('#theme_bg_color_primary').val() || secondaryColor;
    let bgColor = `linear-gradient(135deg, ${primaryColor}, ${secondaryColor})`

    $('.preview-bg').css({background: bgColor});
  }

  initPreviewTheme() {
    let primaryColor = $('#theme_bg_color_primary').val() || '#ea33db';
    let secondaryColor = $('#theme_bg_color_secondary').val() || '#1E40AF';
    let bgColor = `linear-gradient(135deg, ${primaryColor}, ${secondaryColor})`

    $('.preview-bg').css({background: bgColor});
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
