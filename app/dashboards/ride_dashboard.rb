# frozen_string_literal: true

require 'administrate/base_dashboard'

class RideDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo,
    participations: Field::HasMany,
    participants: Field::HasMany.with_options(class_name: 'User'),
    comments: Field::HasMany,
    id: Field::Number,
    trail_id: Field::String,
    longitude: Field::Number.with_options(decimals: 2),
    latitude: Field::Number.with_options(decimals: 2),
    location: Field::String,
    day: Field::DateTime.with_options(format: '%b %-d %Y'),
    time: Field::Time.with_options,
    difficulty: Field::String,
    stars: Field::Number.with_options(decimals: 2),
    created_at: Field::DateTime.with_options(format: '%b %-d %Y'),
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    user
    participations
    comments
    day
    location
    created_at
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    user
    participations
    participants
    comments
    id
    trail_id
    longitude
    latitude
    location
    day
    time
    difficulty
    stars
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    user
    participations
    participants
    comments
    trail_id
    longitude
    latitude
    location
    day
    time
    difficulty
    stars
  ].freeze

  # Overwrite this method to customize how rides are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(ride)
  #   "Ride ##{ride.id}"
  # end
end
