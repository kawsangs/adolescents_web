// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

import "@hotwired/turbo-rails"

import Rails from '@rails/ujs'

import "popper"
import "bootstrap"

import jquery from 'jquery'
window.$ = jquery

import pumi from "pumi"
import "controllers"

import timeago from "timeago"
import tooltip from "tooltip"
import alert from "alert"
import selectPicker from "select_picker"

Rails.start();

document.addEventListener('turbo:load', () => {
  timeago.init();
  tooltip.init();
  alert.init();
  selectPicker.init();
  pumi.setup();
});
