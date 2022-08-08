import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {

  }

  toggle(event) {
    document.body.classList.toggle('sb-sidenav-toggled');

    localStorage.setItem('sb|sidebar-toggle', document.body.classList.contains('sb-sidenav-toggled'));
  }
}
