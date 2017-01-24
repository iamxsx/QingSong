class UserMailer < ApplicationMailer
  default from: 'qingsong_dev@sina.com'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(email,token)
    @token = token
    mail to: email
  end
end
