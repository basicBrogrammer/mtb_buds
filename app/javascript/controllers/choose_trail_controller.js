import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [
    "select",
    "url",
    "trail_id",
    "longitude",
    "latitude",
    "trails"
  ];

  connect() {
    this.select2mount();

    document.addEventListener(
      "turbolinks:before-cache",
      () => {
        this.select2unmount();
      },
      { once: true }
    );

    $(this.selectTarget).on("select2:select", e => {
      const location = e.target.value;
    });
  }

  select2mount() {
    $(this.selectTarget).select2(this._select2Options);
  }

  select2unmount() {
    this.saveState();
    $(this.selectTarget).select2("destroy");
  }

  saveState() {
    let values = $(this.selectTarget).val();

    // make sure the HTML itself has those elements selected, since the HTML
    // is what is saved in the turbolinks snapshot
    values.forEach(val => {
      $(this.selectTarget)
        .find(`option[value="${val}"]`)
        .attr("selected", "selected");
    });
  }

  get placeholder() {
    return $(this.selectTarget).data("placeholder");
  }

  get url() {
    return this.data.get("url") || "";
  }

  get _select2Options() {
    return {
      width: "100%",
      ajax: {
        url: this.url,
        dataType: "json",
        delay: 250,
        data: function(params) {
          return {
            q: params.term
          };
        },
        processResults: function(data, params) {
          return {
            results: data
          };
        },
        cache: true
      },
      minimumInputLength: 3,
      placeholder: this.placeholder
    };
  }
}
