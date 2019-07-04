# frozen_string_literal: true

json.array! @rides, partial: 'rides/ride', as: :ride
