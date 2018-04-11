import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["items", "spinner"];
  initialize() {
    this.loading = true; // flag to wait for this.load() to finish before firing again
    this.page = 1;
    this.hasMore = true;
  }

  connect() {
    this.load();
    window.addEventListener("scroll", this.checkScrollHeight.bind(this), false);
  }

  disconnect() {
    window.removeEventListener("scroll", this.checkScrollHeight, false);
  }

  load() {
    this.loading = true;

    $(this.spinnerTarget).removeClass("hide");

    fetch(this.fullUrl, { credentials: "same-origin" })
      .then(response => response.text())
      .then(html => {
        $(this.spinnerTarget).addClass("hide");
        this.loading = false;
        $(this.itemsTarget).append(html);
        this.page++;

        const numberOfCars = html.match(/card-title/g);
        if (!numberOfCars || numberOfCars.length < 25) {
          this.hasMore = false;
        }
      });
  }

  checkScrollHeight() {
    // if scrolled 80% of document height
    if (
      this.hasMore &&
      window.innerHeight + window.scrollY >= document.body.offsetHeight * 0.8 &&
      !this.loading
    ) {
      this.load();
    }
  }

  get url() {
    return this.data.get("url");
  }

  get params() {
    const searchParams = JSON.parse(this.data.get("search_params"));
    return Object.assign({ page: this.page }, searchParams);
  }

  get fullUrl() {
    return `${this.url}?${$.param(this.params)}`;
  }

  get csrfToken() {
    return $('meta[name="csrf-token"]').attr("content");
  }
}
