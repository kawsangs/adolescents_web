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
    this.onClickPlatformTemplate();
    this.onChangeResoutionSelect();
    this.initializeMinicolors('#theme_primary_color', self.onChangeBgPrimaryColor);
    this.initializeMinicolors('#theme_secondary_color', self.onChangeBgSecondaryColor);
    this.initializeMinicolors('#theme_primary_text_color', self.onChangePrimaryTextColor);
    this.initializeMinicolors('#theme_secondary_text_color', self.onChangeSecondaryTextColor);
  }

  onClickPlatformTemplate() {
    let resolutions = $("#resolution-select").data("resolutions");
    let self = this;
    $(".platform").click(function (event) {
      event.preventDefault();

      // Remove active class from all tabs and add to the clicked tab
      $(".platform").removeClass("active");
      $(this).addClass("active");

      // Get the selected platform (android/ios)
      let selectedPlatform = $(this).text().trim().toLowerCase();

      // Update the select options
      let options = resolutions[selectedPlatform] || [];
      $("#resolution-select").html(options.map(res => `<option value="${res[1]}">${res[0]}</option>`).join(""));

      self.setPreviewThemeBgImage();
      $('.preview-background').removeClass('android ios');
      $('.preview-background').addClass($(this).html().toLowerCase());
    });
  }

  setPreviewThemeBgImage() {
    let image = $(`#${$('#resolution-select').val()}`);
    let defaultImage = image.data("default"); // Get the data-default attribute value
    let currentImage = image.attr("src"); // Get the current src attribute value
    let url = 'none';

    if (currentImage !== defaultImage) {
      url = `url('${currentImage}')`;
    }

    $('#theme-bg').css({'background-image': url});
  }

  onChangeResoutionSelect() {
    let self = this;
    $("#resolution-select").on('change', function(e) {
      self.setPreviewThemeBgImage();
    })
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

    this.setPreviewThemeBgImage();
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
