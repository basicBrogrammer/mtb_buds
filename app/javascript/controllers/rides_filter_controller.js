import Select2LocationController from './select2_location_controller'

export default class extends Select2LocationController {
  static targets = [
    "select",
    "url",
    'form'
  ];

  _onSelect() {
    this.formTarget.submit();
  }
}
