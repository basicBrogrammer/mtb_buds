App.comment = App.cable.subscriptions.create("CommentChannel", {
  connected: function() {
    // Called when the subscription is ready for use on the server
  },

  disconnected: function() {
    // Called when the subscription has been terminated by the server
  },

  received: function(data) {
    // Called when there's incoming data on the websocket for this channel
    const commentBox = $("#comment-box-" + data['ride_id'])
    commentBox.append(data['message']);
    // TODO: handle scroll 
    const scrollDiv = $("[data-target='remote-load.scroll'")[0]
    scrollDiv.scrollTop = scrollDiv.scrollHeight
  },

  speak: function(comment) {
    return this.perform('speak', {
      message: comment
    });
  }
});

