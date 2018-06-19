import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "scroll" ]

  connect() {
    this.scrollTarget.scrollTop = this.scrollTarget.scrollHeight
  }

  submit(event) {
    event.preventDefault();
    const values = $(event.target).serializeArray();
    App.comment.speak(values);
    $(event.target).trigger('reset');

    const commentCard = $('.card--comments')[0]
    commentCard.scrollIntoView()
  }
}
