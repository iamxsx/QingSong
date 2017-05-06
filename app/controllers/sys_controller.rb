class SysController < ApplicationController

  layout false

  # 加载课程系统
  def course_sys
    # 课程系统名
    @course_sys_name = params[:sys_name]
    # 公司id
    @company_id = params[:company_id]
    # 读取的json文件名称
    @json_filename = params[:json_filename]
    # 课程的序号
    @course_sort = params[:course_sort]
    # 课程的类型
    @type = params[:type]
    # 课程的id
    @course_id = params[:course_id]
    # 课程的学习状态
    @status = params[:status]

    if @status == 'new'
      @load_progress = false
    else
      @load_progress = true
    end

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

  # According to the url to load the file
  # Url like: public/course-sys/2/preview/JinSanQi/assets/img/login/logo.png
  def load_file
    file_url = params[:file_url]
    type = params[:type]
    filename = file_url.split('/')[-1]
    if type == 'css'
      file_type = 'text/css'
      send_file "public/course_sys/#{file_url}.#{type}", filename: "#{filename}", type: "#{file_type}"
    else
      send_file "public/course_sys/#{file_url}.#{type}", filename: "#{filename}"
    end
  end

  def save_unfinished_page
    user_course = UserCourse.find_by(
        {
            :course_id => params[:course_file_id],
            :user_id => current_user.id
        }
    )

    is_finished = false;

    if params[:progress] == '100'
      is_finished = true
    end

    if user_course.update(
        {
            :html_file => params[:html],
            :course_id => params[:course_file_id],
            :step => params[:step],
            :action => params[:action],
            :progress => params[:progress],
            :user_id => current_user.id,
            :is_finished => is_finished
        }
    )
      render :json => {status: 'success'}
    else
      render :json => {status: 'failed'}
    end
  end

  def load_unfinished_page
    user_course = UserCourse.find_by(
        {
            :course_id => params[:course_file_id],
            :user_id => current_user.id
        }
    )

    render :json => {
        :html => user_course.html_file,
        :progress => user_course.progress,
        :action => user_course.action,
        :step => user_course.step
    }
  end

  # Send the exam score
  def send_score
    course_id = params[:course_file_id]
    score = params[:score]

    user_course = UserCourse.find_by(
        {
            :course_id => course_id,
            :user_id => current_user.id
        }
    )

    if user_course.update(:score => score)
      render :json => {status: 'success'}
    else
      render :json => {status: 'failed'}
    end
  end

  def apply_new_course_system
    applyLesson = ApplyLesson.new(
        {
            :course_sys_name_cn => params[:course_sys_name_cn],
            :course_sys_desc => params[:course_sys_desc],
            :course_sys_cover => params[:course_sys_cover]
        }
    )

    if applyLesson.save
      redirect_to '/users/com-course'
    end
  end

  # 获得用户列表，课程列表及课程的分配情况
  def get_lesson_users
    lesson_id = params[:course_sys_id]
    lesson = Lesson.find lesson_id
    # 获取当前登录用户所在公司的所有员工
    users = current_user.company.users.select('id, username as name, email')
    # 获取课程系统的所有课节
    courses = lesson.courses.select('id, id as course_file_id, course_name')

    # 查询课程的分配情况
    courses.each do |course|
      # 获取每一个课程被分配给的用户的id
      course.distribute = course.user_courses.select('user_id').map { |e| e.user_id }
    end

    render :json => {
        :emp_list => users,
        :course_list => courses
    }
  end

  # 将课程的课节分配给用户
  def send_distribute
    # 获得课程系统id
    course_sys_id = params[:course_sys_id]
    # 获得差异包
    diff_pack = params[:diff_pack]
    keys = diff_pack.keys

    keys.each do |key|
      # 获得要操作的课节id
      course_id = key[2..-1]
      # 获得要增加课节的用户id数组
      add = diff_pack[key]['add']
      # 获得要删除课节用户id的数组
      delete = diff_pack[key]['delete']

      if !delete.nil?
        # 解除用户和课节的关系
        delete_user_courses course_id, delete
      end

      if !add.nil?
        add.each do |user_id|
          # 对每个用户分配课程
          distribute_lesson_and_courses course_sys_id, course_id, user_id
        end
      end
    end
  end

  def public_preview_system
    lesson_id = params[:course_sys_id]
    action = params[:do]

    if action == 'publish'
      lesson = Lesson.find lesson_id
      lesson.update_attribute :preview, true
    end

  end
end