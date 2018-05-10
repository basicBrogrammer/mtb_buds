class CommentChannel < ApplicationCable::Channel
  def subscribed
    stream_from "comments-#{current_user.id}"
  end

  def unsubscribed
    stop_all_streams
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    comment_params = data['message'].each_with_object({}) do |el, hash|
      hash[el.values.first] = el.values.last
    end
    comment_params.delete('authenticity_token')
    comment_params.delete('utf8')
 
    Comment.create(comment_params)
  end
end
