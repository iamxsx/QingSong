require 'test_helper'

class InvitationCodesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @invitation_code = invitation_codes(:one)
  end

  test "should get index" do
    get invitation_codes_url
    assert_response :success
  end

  test "should get new" do
    get new_invitation_code_url
    assert_response :success
  end

  test "should create invitation_code" do
    assert_difference('InvitationCode.count') do
      post invitation_codes_url, params: { invitation_code: { code: @invitation_code.code, invited_at: @invitation_code.invited_at, used: @invitation_code.used } }
    end

    assert_redirected_to invitation_code_url(InvitationCode.last)
  end

  test "should show invitation_code" do
    get invitation_code_url(@invitation_code)
    assert_response :success
  end

  test "should get edit" do
    get edit_invitation_code_url(@invitation_code)
    assert_response :success
  end

  test "should update invitation_code" do
    patch invitation_code_url(@invitation_code), params: { invitation_code: { code: @invitation_code.code, invited_at: @invitation_code.invited_at, used: @invitation_code.used } }
    assert_redirected_to invitation_code_url(@invitation_code)
  end

  test "should destroy invitation_code" do
    assert_difference('InvitationCode.count', -1) do
      delete invitation_code_url(@invitation_code)
    end

    assert_redirected_to invitation_codes_url
  end
end
