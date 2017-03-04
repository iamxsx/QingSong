module SysHelper

  def get_file_content(company_id, course_sys_name, json_filename)
    file_url = "public/course_sys/#{company_id}/preview/#{course_sys_name}/courses/#{json_filename}.json"
    File.open(file_url).read
  end

  def read_course_config(course_sys_name, company_id)
    file_url = "public/course_sys/#{company_id}/preview/#{course_sys_name}/config/config.json"
    content = File.open(file_url).read
    JSON.parse content
  end

  def read_course_file(company_id, course_sys_name, filename, type)
    file_url = "public/course_sys/#{company_id}/preview/#{course_sys_name}/"
    if type == 'page'
      file_url += "pages/#{filename}"
    else
      file_url += "parts/#{filename}"
    end
    File.open(file_url).read
  end

end
