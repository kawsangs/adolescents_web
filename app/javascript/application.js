// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

import "@hotwired/turbo-rails"

import Rails from '@rails/ujs'

import "popper"
import "bootstrap"

import jquery from 'jquery'
window.$ = jquery

import pumiJs from "libs/pumiJs"
import timeago from "commons/timeago"
import tooltip from "commons/tooltip"
import alert from "commons/alert"
import selectPicker from "commons/select_picker"

import "controllers"

Rails.start();

document.addEventListener('turbo:load', () => {
  timeago.init();
  tooltip.init();
  alert.init();
  selectPicker.init();
  pumiJs.setup();
});
