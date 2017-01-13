class User < ApplicationRecord

  # 在保存前将邮箱改为小写
  before_save { self.email = self.email.downcase }

  # 添加安全密码
  has_secure_password
  validates :password, length: {minimum: 4}

  # 验证邮箱的正则表达式
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :username, presence: true, length: {maximum: 40, minimum: 4}

  validates :email, presence: true, uniqueness: true, format: {with: VALID_EMAIL_REGEX}



end
