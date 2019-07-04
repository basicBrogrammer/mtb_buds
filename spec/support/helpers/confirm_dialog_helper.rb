module Features
  module ConfirmDialogHelper
    def confirm_dialog
      page.driver.browser.switch_to.alert.accept
    end
  end
end
