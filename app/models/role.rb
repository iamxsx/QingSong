class Role < ApplicationRecord
  # 一个角色可以有多个用户
  has_many :user

end
