import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["select"];

  connect() {
    console.log("connectting");
    this.select2mount();

    document.addEventListener(
      "turbolinks:before-cache",
      () => {
        this.select2unmount();
      },
      { once: true }
    );
  }

  select2mount() {
    const options =
      this.url.length > 0 ? this.singleLocationOptions : this.defaultOptions;

    $(this.selectTarget).select2(options);

    $(this.selectTarget).on("select2:select", function(e) {
      console.log("selected");
    });
  }

  select2unmount() {
    this.saveState();
    $(this.selectTarget).select2("destroy");
  }

  saveState() {
    let values = $(this.selectTarget).val();
    debugger;

    // make sure the HTML itself has those elements selected, since the HTML is what is saved in the turbolinks snapshot
    values.forEach(val => {
      $(this.selectTarget)
        .find(`option[value="${val}"]`)
        .attr("selected", "selected");
    });
  }

  get defaultOptions() {
    return {
      placeholder: this.placeholder,
      width: "100%"
    };
  }

  get singleLocationOptions() {
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

  get placeholder() {
    return $(this.selectTarget).data("placeholder");
  }

  get url() {
    return this.data.get("url") || "";
  }
}
