import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this._initShowCollapse();
  }

  _initShowCollapse() {
    $(".sb-sidenav-menu-nested .nav-link.active").parents(".collapse").addClass('show')
  }

  toggle(event) {
    document.body.classList.toggle('sb-sidenav-toggled');

    localStorage.setItem('sb|sidebar-toggle', document.body.classList.contains('sb-sidenav-toggled'));
  }
}
