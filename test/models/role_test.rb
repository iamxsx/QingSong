require 'test_helper'

class RoleTest < ActiveSupport::TestCase

  def setup
    @role = Role.new(:role_name => '超级管理员')
    @user = @role.users.build(:username =>'xsx',:password => '1234',
                              :password_confirmation => '1234',
                              :email => '100@qq.com',
                              :role_id => 1
    )
  end


  # test "the truth" do
  #   assert true
  # end
end
