require 'fileutils'

module Admin::LessonsHelper

  def upload_file(lesson)
    uploaded_io = params[:lesson][:lesson_file_url]
    lesson_name = lesson.lesson_name
    company_id = lesson.company_id
    file_path = Rails.root.join('public', 'courses_sys', "#{company_id}", "#{lesson_name}", uploaded_io.original_filename)
    File.open(file_path, 'wb') do |file|
      file.write(uploaded_io.read)
    end
  end


  # 将预览版的文件发布到最终版
  def lesson_file_moveto_ultimate(lesson)
    # /course_sys/company_id/preview/demosys
    @file_name = lesson.lesson_file_name
    @company_id = lesson.company_id
    FileUtils.mv(src_path, dest_path)
  end

  def src_path
    "public/course_sys/#{@company_id}/preview/#{@file_name}"
  end

  def dest_path
    "public/course_sys/#{@company_id}/ultimate/#{@file_name}"
  end


end
