# frozen_string_literal: true

class CommentChannel < ApplicationCable::Channel
  def follow(data)
    stop_all_streams
    stream_from "CommentsChannel:#{data['ride_id']}"
  end

  def unsubscribed
    stop_all_streams
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
