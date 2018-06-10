import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ['url'];

  submit(e) {
    e.preventDefault();
    const data = $(e.target).serializeArray();
    $.ajax({
      url: this.url,
      method: 'PATCH',
      data
    }).done((response) => { 
      debugger
    })
  }

  get url() {
    return this.data.get('url');
  }
}
