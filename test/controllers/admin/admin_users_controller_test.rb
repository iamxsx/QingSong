require 'test_helper'

class Admin::AdminUsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_admin_user = admin_admin_users(:one)
  end

  test "should get index" do
    get admin_admin_users_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_admin_user_url
    assert_response :success
  end

  test "should create admin_admin_user" do
    assert_difference('Admin::AdminUser.count') do
      post admin_admin_users_url, params: { admin_admin_user: { email: @admin_admin_user.email, password_digest: @admin_admin_user.password_digest } }
    end

    assert_redirected_to admin_admin_user_url(Admin::AdminUser.last)
  end

  test "should show admin_admin_user" do
    get admin_admin_user_url(@admin_admin_user)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_admin_user_url(@admin_admin_user)
    assert_response :success
  end

  test "should update admin_admin_user" do
    patch admin_admin_user_url(@admin_admin_user), params: { admin_admin_user: { email: @admin_admin_user.email, password_digest: @admin_admin_user.password_digest } }
    assert_redirected_to admin_admin_user_url(@admin_admin_user)
  end

  test "should destroy admin_admin_user" do
    assert_difference('Admin::AdminUser.count', -1) do
      delete admin_admin_user_url(@admin_admin_user)
    end

    assert_redirected_to admin_admin_users_url
  end
end
