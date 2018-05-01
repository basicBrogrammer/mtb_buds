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
    $(this.selectTarget).select2(this._select2Options);

    $(this.selectTarget).on("select2:select", e => {
      this._onSelect(e.target.value);
    });
  }

  select2unmount() {
    this.saveState();
    $(this.selectTarget).select2("destroy");
  }

  saveState() {
    let values = $(this.selectTarget).val();

    // make sure the HTML itself has those elements selected, 
    // since the HTML is what is saved in the turbolinks snapshot
    values.forEach(val => {
      $(this.selectTarget)
        .find(`option[value="${val}"]`)
        .attr("selected", "selected");
    });
  }

  _onSelect() {
    console.log('noop');
  }

  get _select2Options() {
    return {
      placeholder: this.placeholder,
      width: "100%"
    };
  }

  get placeholder() {
    return $(this.selectTarget).data("placeholder");
  }
}
