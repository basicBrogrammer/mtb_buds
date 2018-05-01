import Select2Controller from './select2_controller'

export default class extends Select2Controller {
  static targets = [
    "select",
    "url"
  ];

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
