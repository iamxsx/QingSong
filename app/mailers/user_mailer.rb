class UserMailer < ApplicationMailer
  default from: 'qingsong_dev@sina.com'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(email, token)
    @token = token
    mail to: email
  end

  # 发送重置密码的验证码邮件
  def reset_password(email, verify_code)
    @verify_code = verify_code
    mail to: email
  end

end
