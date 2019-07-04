# frozen_string_literal: true

module Features
  module Select2Helpers
    def select2(choice, from:)
      find("#{from} .select2-container").click
      find('.select2-container--open .select2-results__option', text: choice).click
    end

    def select2_search(q, choice:, from:)
      find("#{from} .select2-container").click
      find('.select2-container--open .select2-search__field').send_keys(q)
      find('.select2-container--open .select2-results__option', text: choice).click
    end
  end
end
