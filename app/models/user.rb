class User < ApplicationRecord

  # 一个用户
  belongs_to :role
  belongs_to :company

  has_many :user_lessons
  has_many :lessons, through: :user_lessons

  has_many :user_courses

  # 在保存前将邮箱改为小写
  before_save { self.email = self.email.downcase }
  # 创建前先生成激活摘要
  before_create :create_activation_digest

  # 添加安全密码
  has_secure_password
  validates :password, length: {minimum: 4}

  # 验证邮箱的正则表达式
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :username, presence: true, length: {maximum: 40, minimum: 4}

  validates :email, presence: true, uniqueness: true, format: {with: VALID_EMAIL_REGEX}

  validates_uniqueness_of :email, message: '邮箱已注册'

  # 数据库里不存在，但是需要用到的属性
  attr_accessor :activation_token, :invite_code

  # 生成随机token
  def User.generate_random_token
    SecureRandom.urlsafe_base64
  end

  # 生成传入字符串的摘要
  def User.generate_digest(token)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(token, cost: cost)
  end

  # 为用户创建激活token和摘要
  def create_activation_digest
    self.activation_token = User.generate_random_token
    self.activation_digest = User.generate_digest(self.activation_token)
  end

  # 根据传入的属性认证用户
  def authenticated?(attr, token)
    return false if token.nil?
    digest = self.send("#{attr}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def User.generate_verify_code
    (0...4).map {
      ('A'..'Z').to_a[rand(26)]
    }.join
  end

end
