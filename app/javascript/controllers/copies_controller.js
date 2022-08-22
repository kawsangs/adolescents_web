import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "value" ]

  copy(event) {
    event.preventDefault();
    this.valueTarget.select();
    document.execCommand("copy");

    this.showTooltip(event);
  }

  showTooltip(event) {
    let self = this;
    let tooltipElement = event.target;
    self.setTitle(tooltipElement, tooltipElement.dataset.label);

    setTimeout(function() {
      self.setTitle(tooltipElement);
    }, 1000);
  }

  setTitle(domElement, title) {
    let tooltip = bootstrap.Tooltip.getInstance(domElement);

    tooltip.tip.lastElementChild.innerHTML = title || tooltip._getTitle();
    tooltip.update();
  }
}
