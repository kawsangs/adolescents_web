import { Controller } from "@hotwired/stimulus"
import imageFile from 'commons/image_file';

import $ from "jquery";
import "jquery-minicolors";

export default class extends Controller {
  connect() {
    imageFile.init();
    this.initializeMinicolors('#theme_bg_color');
    this.initializeMinicolors('#theme_text_color');
    this.initializeMinicolors('#theme_button_color');
    this.initializeMinicolors('#theme_nav_bar_color');
  }

  initializeMinicolors(domId) {
    $(domId).minicolors({
      theme: "bootstrap",
      format: "hex",
      opacity: false,
      change: (value, opacity) => {
        console.log("Color changed to:", value, "with opacity:", opacity);
      },
    });
  }
}
