import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "scroll", 'input' ]

  connect() {
    this.scrollTarget.scrollTop = this.scrollTarget.scrollHeight
    if( /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent) ) {
      $(this.inputTarget).focus(() => this._handleInputFocus())
      $(this.inputTarget).blur(() => this._handleInputBlur())
    }
  }

  submit(event) {
    event.preventDefault();
    const values = $(event.target).serializeArray();
    App.comment.speak(values);
    $(event.target).trigger('reset');

    const commentCard = $('.card--comments')[0]
    commentCard.scrollIntoView()
  }

  _handleInputFocus(e) {
    this._mobileNav.hide()
    this._cardAction.css('bottom', 0)
  }
  _handleInputBlur(e) {
    this._mobileNav.show()
    this._cardAction.css('bottom', '5%')
  }
  get _mobileNav() {
    return $('.mobile-bottom-nav');
  }
  get _cardAction() {
    return $('.card--comments .card-action')
  }
}
