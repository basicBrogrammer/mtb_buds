import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["collapseTrigger", "body", "preloader"];

  connect() {
    this.needsToLoad = true;
    this._fetchHtml = this._fetchHtml.bind(this);
    $(this.collapseTriggerTarget).collapsible({ onOpenStart: this._fetchHtml });
  }

  _fetchHtml() {
    if (this.needsToLoad) {
      $(this.bodyTarget).addClass("hide");
      $(this.preloaderTarget).removeClass("hide");

      return fetch(this.remoteUrl, { credentials: "same-origin" })
        .then(response => response.text())
        .then(html => {
          console.log("loading...");
          this.needsToLoad = false;
          this.bodyTarget.innerHTML = html;
          $(this.bodyTarget).removeClass("hide");
          $(this.preloaderTarget).addClass("hide");
        });
    }
  }

  get remoteUrl() {
    return this.data.get("remote-url") || "";
  }
}
