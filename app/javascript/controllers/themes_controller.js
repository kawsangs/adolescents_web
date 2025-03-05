import { Controller } from "@hotwired/stimulus"
import imageFile from 'commons/image_file';

import $ from "jquery";
import "jquery-minicolors";

export default class extends Controller {
  connect() {
    imageFile.init();
    this.initPreviewTheme();
    this.initializeMinicolors('#theme_bg_color_primary', function(value, opacity) {
      let primaryColor = value;
      let secondaryColor = $('#theme_bg_color_secondary').val() || primaryColor;
      let bgColor = `linear-gradient(135deg, ${primaryColor}, ${secondaryColor})`

      $('.preview-bg').css({background: bgColor});
    });

    this.initializeMinicolors('#theme_bg_color_secondary', function(value, opacity) {
      let secondaryColor =  value;
      let primaryColor = $('#theme_bg_color_primary').val() || secondaryColor;
      let bgColor = `linear-gradient(135deg, ${primaryColor}, ${secondaryColor})`

      $('.preview-bg').css({background: bgColor});
    });
    this.initializeMinicolors('#theme_text_color');
    this.initializeMinicolors('#theme_button_color');
    this.initializeMinicolors('#theme_nav_bar_color');
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
