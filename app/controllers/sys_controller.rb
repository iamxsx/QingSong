class SysController < ApplicationController

  def course_sys
    @course_sys_name = params[:sys_name]
    @company_id = params[:company_id]
    @json_filename = params[:json_filename]

    @course_sort = params[:course_sort]
    @type = params[:type]

    @lesson_sys = Lesson.find_by_lesson_name @course_sys_name
    @course_json_content = get_file_content @company_id, @course_sys_name, @json_filename
  end

  # 如果请求类型(type) 是 page ,那么从课程系统的 pages 文件夹下获取filename所指定的文件内容,
  # 如果是 part ,则从 parts 文件夹下获取filename所指定文件的内容
  def load_course
    type = params[:type]
    filename = params[:filename]
    company_id = params[:company_id]
    course_sys_name = params[:course_sys_name]
    html_content = read_course_file company_id, course_sys_name, filename, type
    render html: html_content.html_safe
  end



end
