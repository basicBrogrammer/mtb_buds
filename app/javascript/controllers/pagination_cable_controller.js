import { Controller } from 'stimulus';
import createChannel from 'client/cable';

export default class extends Controller {
  static targets = ['container', 'spinner'];

  initialize() {
    let controller = this;
    let channel = this.data.get('channel');
    this.channel = createChannel(channel, {
      connected() {
        controller.listen();
      },
      received(data) {
        controller.loaded(data['message']);
      }
    });
  }

  connect() {
    this.listen();
  }
  disconnect() {
    this.channel.perform('unsubscribed');
  }

  listen() {
    if (this.channel) {
      this.channel.perform('listen', this.params);
    }
  }

  loaded(html) {
    $(this.containerTarget).append(html);
    $(this.spinnerTarget).hide();
  }

  get params() {
    return JSON.parse(this.data.get('params'));
  }
}
