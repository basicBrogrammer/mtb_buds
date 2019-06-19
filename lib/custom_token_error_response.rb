module CustomTokenErrorResponse
  def body
    {
      error: name, 
      message: I18n.t("devise.failure.#{name}", authentication_keys: :email)
    }
  end
end