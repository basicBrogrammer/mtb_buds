import { Controller } from "stimulus"
import { initialResponseHandler, catchHandler } from "../packs/fetch_handling";

export default class extends Controller {
  static targets = [ "preloader", "body", 'scroll' ]

  connect() {
    this._fetchHtml();
  }

  _fetchHtml() {
    fetch(this.url, { credentials: "same-origin" })
      .then(response => {
        return initialResponseHandler(response);
      })
      .then(html => {
        //console.log("loading...");
        this.bodyTarget.innerHTML = html;
        $(this.bodyTarget).removeClass("hide");
        $(this.preloaderTarget).addClass("hide");
      }).then(() => {
        if (this.scrollTarget) {
          this.scrollTarget.scrollTop = this.scrollTarget.scrollHeight
        }
      }).catch(e => {
        $(this.preloaderTarget).addClass("hide");
        catchHandler(e, this.bodyTarget);
        console.log(e)
      });
  }

  get url() {
    return this.data.get("url") || "";
  }
}
