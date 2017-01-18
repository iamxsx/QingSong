require 'test_helper'

class Admin::LessonsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_lessons_index_url
    assert_response :success
  end

end
