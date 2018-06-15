import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    $('#mobile-settings').sidenav()
  }

  open(e) {
    e.preventDefault();
    $('#mobile-settings').sidenav('open');
  }
}
