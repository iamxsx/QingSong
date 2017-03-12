require 'zip'
require 'json'

class LessonFileParseJob < ApplicationJob
  queue_as :lesson_parse_queue


  def perform(*args)
    lesson = args[0]

    @lesson_id = lesson.id
    @lesson_file_url = lesson.lesson_file_url
    @company_id = lesson.company_id
    @lesson_file_name = lesson.lesson_file_name

    # 获得压缩文件的路径
    path = "public#{@lesson_file_url}"

    # 设定输出文件的路径
    @out_path = output_path

    course_infos = parse_zip_file path
    course_infos.each do |course_info|
      course = Course.new(
          course_name: course_info['course_name'],
          sort: course_info['sort'],
          filename: course_info['filename'],
          lesson_id: @lesson_id
      )
      course.save!
    end
  end

  def output_path
    "public/course_sys/#{@company_id}/preview"
  end

  # 解压缩文件
  def parse_zip_file(path)
    course_info = ''
    Zip::File.open(path) do |zip_file|
      zip_file.each do |entry|
        if entry.name.split('.')[-1] == 'css'
          rewrite_css_file entry
        elsif entry.name.split('/')[-1] == 'LIST.JSON'
          course_info = get_course_info(entry)
        else
          entry.extract("#{@out_path}/#{entry.name}")
        end
      end
    end
    # delete the zip
    File.delete(path)
    return course_info
  end

  def get_course_info(entry)
    content = entry.get_input_stream.read
    JSON.parse content
  end

  # 将css中的字符串进行替换
  def rewrite_css_file(entry)
    content = replace_css_urls entry
    f = File.new("#{@out_path}/#{entry.name}", 'w+')
    f.write content.force_encoding('UTF-8')
    f.close
  end


  # url替换
  def replace_css_urls(entry)
    content = entry.get_input_stream.read
    pattern = /url\s*\(\s*((?!\s*http:\/\/)(?!\s*https:\/\/)(?!\s*\/\/).*\.[a-zA-Z0-9]{2,6})\s*"*\)/
    content.gsub!(pattern) do |match|
      # "url('/course_sys/#{entry.name}/assets/css/#{match[4..-2]}')"
      "url('/public/course-sys/#{@company_id}/preview/#{@lesson_file_name}/assets/img/#{match[4..-2].gsub(' ', '')}')"
    end
  end


end
