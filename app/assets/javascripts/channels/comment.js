App.comment = App.cable.subscriptions.create("CommentChannel", {
  connected: function() {
    // Called when the subscription is ready for use on the server
  },

  disconnected: function() {
    // Called when the subscription has been terminated by the server
  },

  received: function(data) {
    console.log(data['message'])
    // Called when there's incoming data on the websocket for this channel
  },

  speak: function(comment) {
    console.log(comment)
    return this.perform('speak', {
      message: comment
    });
  }
});

