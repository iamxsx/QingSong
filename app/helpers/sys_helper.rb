module SysHelper

  # 读取课节json文件的内容
  def get_file_content(company_id, course_sys_name, json_filename)
    file_url = "public/course_sys/#{company_id}/preview/#{course_sys_name}/courses/#{json_filename}.json"
    File.open(file_url).read
  end

  # 读取课节配置文件，返回json对象
  def read_course_config(course_sys_name, company_id)
    file_url = "public/course_sys/#{company_id}/preview/#{course_sys_name}/config/config.json"
    content = File.open(file_url).read
    JSON.parse content
  end

  # 返回课节资源文件
  def read_course_file(company_id, course_sys_name, filename, type)
    file_url = "public/course_sys/#{company_id}/preview/#{course_sys_name}/"
    if type == 'page'
      file_url += "pages/#{filename}"
    else
      file_url += "parts/#{filename}"
    end
    File.open(file_url).read
  end

  # 判断课程系统是否已经分配给用户
  def is_course_sys_distribute_to_user(course_sys_id, user_id)
    UserLesson.find_by({:user_id => user_id, :lesson_id => course_sys_id}).nil?
  end

  # 分配相应的课程给相应的用户
  def distribute_lesson_and_courses(course_sys_id, course_id, user_id)
    # 当课程系统尚未被分配给用户时，先将课程系统分配给用户
    if is_course_sys_distribute_to_user(course_sys_id, user_id)
      userLesson = UserLesson.new({:lesson_id => course_sys_id, :user_id => user_id})
      userLesson.save
    end

    userCourse = UserCourse.new({:course_id => course_id, :user_id => user_id})
    userCourse.save
  end

  # 删除用户被分配的课程
  def delete_user_courses(course_id, delete_user_ids)
    UserCourse.where(['course_id = ? AND user_id IN (?)', course_id, delete_user_ids]).destroy_all
  end

end