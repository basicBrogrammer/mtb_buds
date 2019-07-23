import { Controller } from 'stimulus';
import createChannel from 'client/cable';

export default class extends Controller {
  static targets = ['scroll', 'input', 'container'];

  initialize() {
    let commentsController = this;
    this.commentsChannel = createChannel('CommentChannel', {
      connected() {
        commentsController.listen();
      },
      received(data) {
        $(commentsController.containerTarget).append(data['message']);
        let { scrollTarget } = commentsController;
        scrollTarget.scrollTop = scrollTarget.scrollHeight;
      },
      speak(comment) {
        return this.perform('speak', { message: comment });
      }
    });
  }

  connect() {
    this.listen();
    this.scrollTarget.scrollTop = this.scrollTarget.scrollHeight;
    if (/Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent)) {
      $(this.inputTarget).focus(() => this._handleInputFocus());
      $(this.inputTarget).blur(() => this._handleInputBlur());
    }
  }

  disconnect() {
    this.commentsChannel.perform('unsubscribed');
    this.commentsChannel.consumer.subscriptions.forget(this.commentsChannel);
  }
  listen() {
    if (this.commentsChannel) {
      this.commentsChannel.perform('follow', { ride_id: this.rideId });
    }
  }

  submit(event) {
    event.preventDefault();
    const values = $(event.target).serializeArray();
    this.commentsChannel.speak(values);
    $(event.target).trigger('reset');

    const commentCard = $('.card--comments')[0];
    commentCard.scrollIntoView();
  }

  _handleInputFocus(e) {
    this._mobileNav.hide();
    this._cardAction.css('bottom', 0);
  }
  _handleInputBlur(e) {
    this._mobileNav.show();
    this._cardAction.css('bottom', '5%');
  }
  get _mobileNav() {
    return $('.mobile-bottom-nav');
  }
  get _cardAction() {
    return $('.card--comments .card-action');
  }
  get rideId() {
    return this.data.get('rideId');
  }
}
