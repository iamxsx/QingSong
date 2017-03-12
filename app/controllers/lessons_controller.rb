class LessonsController < ApplicationController
  before_action :set_lesson, only: [:show, :edit, :update, :destroy]
  layout 'lesson'

  # assign the course to the user
  def assign_course_to_user
    user_id = params[:user_id]
    lesson_id = params[:lesson_id]
    user = User.find user_id
    lesson = Lesson.find lesson_id
    user.lessons.add
  end




  private
  # Use callbacks to share common setup or constraints between actions.
  def set_lesson
    @lesson = Lesson.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def lesson_params
    params.require(:lesson).permit(:lesson_name, :lesson_desc, :lesson_cover, :lesson_json_url, :lesson_html_url, :lesson_js_url, :lesson_css_url, :company_id)
  end
end
