# frozen_string_literal: true

class UserSerializer
  include FastJsonapi::ObjectSerializer
  # set_type :movie  # optional
  # set_id :owner_id # optional
  attributes :id, :name, :email, :password
end
