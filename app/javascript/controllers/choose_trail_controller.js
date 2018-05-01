import Select2LocationController from './select2_location_controller'

export default class extends Select2LocationController {
  static targets = [
    "select",
    "url",
    "trailId",
    "preloader",
    "trails"
  ];

  selectTrail(e) {
    this.trailIdTarget.value = e.target.dataset.trailId;
  }

  _onSelect(location) {
    $(this.trailsTarget).addClass("hide");
    $(this.preloaderTarget).removeClass("hide");
    return fetch(this.trailsUrl(location), { credentials: "same-origin" })
      .then(response => response.text())
      .then(html => {
        this.trailsTarget.innerHTML = html;
        $(this.trailsTarget).removeClass("hide");
        $(this.preloaderTarget).addClass("hide");
      });
  }

  trailsUrl(location) {
    return `/trails?layout=false&location=${location}`;
  }
}
