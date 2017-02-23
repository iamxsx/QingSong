require 'zip'

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

    parse_zip_file path
  end

  def output_path
    "public/course_sys/#{@company_id}/preview"
  end

  # 解压缩文件
  def parse_zip_file(path)
    Zip::File.open(path) do |zip_file|
      zip_file.each do |entry|
        if entry.name.split('.')[-1] == 'css'
          rewrite_css_file entry
        else
          entry.extract("#{@out_path}/#{entry.name}")
        end
      end
    end
    # delete the zip
    File.delete(path)
  end

  # 将css中的字符串进行替换
  def rewrite_css_file(entry)
    content = replace_css_urls entry
    f = File.new("#{@out_path}/#{entry.name}", 'w+')
    f.write content
    f.close
  end


  # url替换
  def replace_css_urls(entry)
    content = entry.get_input_stream.read
    pattern = /url\s*\(\s*((?!\s*http:\/\/)(?!\s*https:\/\/)(?!\s*\/\/).*\.[a-zA-Z0-9]{2,6})\s*"*\)/
    content.gsub!(pattern) do |match|
      "url('/course_sys/#{entry.name}/assets/css/#{match[4..-2]}')"
    end
  end


end
