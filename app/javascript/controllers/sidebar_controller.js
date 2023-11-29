import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this._initShowCollapse();
  }

  _initShowCollapse() {
    let element = $(".sb-sidenav-menu-nested .nav-link.active")

    if (!!element) {
      element.parents(".collapse").addClass('show')

      $('.sb-sidenav-menu').animate({
        scrollTop: element.offset().top
      }, 500);
    }
  }

  toggle(event) {
    document.body.classList.toggle('sb-sidenav-toggled');

    localStorage.setItem('sb|sidebar-toggle', document.body.classList.contains('sb-sidenav-toggled'));
  }
}
