import "bootstrap"
import "bootstrap-select";
import $ from 'jquery'

// For disable warning for ambiguous bootstrap version
$.fn.selectpicker.Constructor.BootstrapVersion = '5.2.0'

export default (function() {
  return { init }

  function init() {
    inSelectPicker();
    onChangeSelectPicker();
    onLoadedSelectPicker();
  };

  function inSelectPicker() {
    $('.selectpicker').selectpicker();
  }

  function onChangeSelectPicker() {
    $('.selectpicker').on('changed.bs.select', function(e) {
      setTooltip(e);
    });
  }

  function onLoadedSelectPicker() {
    $('.selectpicker').on('loaded.bs.select', function(e) {
      setTooltip(e);
    });
  }

  function setTooltip(e) {
    let tooltipDom = $(e.target).parents('.tooltips');

    if (!!tooltipDom) {
      let title = buildTitle(tooltipDom);

      handleDisplayTooltip(title, tooltipDom);
    }
  }

  function buildTitle(tooltipDom) {
    let selectedOptions = tooltipDom.find('select :selected');
    let title = selectedOptions.map((i, o) => $(o).html()).toArray().join(', ')

    if (tooltipDom.data('separateLine')) {
      title = selectedOptions.map((i, o) => $(o).html()).toArray().map( (c) =>
        "<div class='mb-2 text-left'>" + c + "</div>"
      ).join('')
    }

    return title;
  }

  function handleDisplayTooltip(title, tooltipDom) {
    let tooltip = bootstrap.Tooltip.getInstance(tooltipDom);
    tooltip._config.originalTitle = title;

    if (!title) { return tooltip.hide(); }

    if (tooltip.tip) {
      tooltip.tip.lastElementChild.innerHTML = title;
      tooltip.update();
    }
  }
})();
