# frozen_string_literal: true

module Features
  module MaterializeHelpers
    def select_date(selector, date:)
      find(selector).click

      within '.datepicker-calendar-container' do
        find('.select-month .select-dropdown').click
      end

      within '.dropdown-content' do
        find('li', text: date.strftime('%B')).click
      end

      find("button[data-pika-day='#{date.day}']").click
      find('.datepicker-done').click
    end
  end
end
