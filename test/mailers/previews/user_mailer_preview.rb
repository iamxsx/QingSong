# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  def account_activation
    token = 'sdfdshuofsdf'
    mail = '1009045160@qq.com'
    UserMailer.account_activation(mail,token)
  end

end
