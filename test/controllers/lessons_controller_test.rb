require 'test_helper'

class LessonsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lesson = lessons(:one)
  end

  test "should get index" do
    get lessons_url
    assert_response :success
  end

  test "should get new" do
    get new_lesson_url
    assert_response :success
  end

  test "should create lesson" do
    assert_difference('Lesson.count') do
      post lessons_url, params: { lesson: { company_id: @lesson.company_id, lesson_cover: @lesson.lesson_cover, lesson_css_url: @lesson.lesson_css_url, lesson_desc: @lesson.lesson_desc, lesson_html_url: @lesson.lesson_html_url, lesson_js_url: @lesson.lesson_js_url, lesson_json_url: @lesson.lesson_json_url, lesson_name: @lesson.lesson_name } }
    end

    assert_redirected_to lesson_url(Lesson.last)
  end

  test "should show lesson" do
    get lesson_url(@lesson)
    assert_response :success
  end

  test "should get edit" do
    get edit_lesson_url(@lesson)
    assert_response :success
  end

  test "should update lesson" do
    patch lesson_url(@lesson), params: { lesson: { company_id: @lesson.company_id, lesson_cover: @lesson.lesson_cover, lesson_css_url: @lesson.lesson_css_url, lesson_desc: @lesson.lesson_desc, lesson_html_url: @lesson.lesson_html_url, lesson_js_url: @lesson.lesson_js_url, lesson_json_url: @lesson.lesson_json_url, lesson_name: @lesson.lesson_name } }
    assert_redirected_to lesson_url(@lesson)
  end

  test "should destroy lesson" do
    assert_difference('Lesson.count', -1) do
      delete lesson_url(@lesson)
    end

    assert_redirected_to lessons_url
  end
end
