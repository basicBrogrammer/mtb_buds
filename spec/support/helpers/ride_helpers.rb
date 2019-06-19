# frozen_string_literal: true

module Features
  module RideHelpers
    def open_riders_collapse
      find('.collapsible-header', text: 'Riders').click
    end
  end
end
