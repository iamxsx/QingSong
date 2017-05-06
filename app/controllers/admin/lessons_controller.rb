class Admin::LessonsController < Admin::AdminApplicationController
  layout 'admin'
  before_action :set_lesson, only: [:show, :edit, :update, :destroy]

  def index
    @lessons = Lesson.all
  end

  def new
    @lesson = Lesson.new
  end

  def show
  end

  def edit
  end

  def destroy
    @lesson.destroy
    respond_to do |format|
      format.html { redirect_to admin_lessons_path, notice: 'Course System was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # 当高管审核完成课程后，需要将 preview 下的文件复制到 ultimate 目录下
  def update_lesson
    lesson = Lesson.find params[:lesson][:lesson_id]
    if !lesson.nil?
      lesson_file_moveto_ultimate lesson
    end
  end

  # 创建新课程系统
  def create
    @lesson = Lesson.new(lesson_params)
    @lesson.lesson_file_name = params[:lesson][:lesson_file_url].original_filename.split('.')[0]

    if @lesson.save
      # 将上传的文件放进任务队列里处理
      LessonFileParseJob.perform_later @lesson
      redirect_to '/admin/lessons'
    end
  end

  def update
    if @lesson.update(lesson_update_params)
      redirect_to admin_lesson_path
    else
      render edit_admin_user_path
    end
  end

  private
    def set_lesson
      @lesson = Lesson.find(params[:id])
    end

    def lesson_params
      params.require(:lesson).permit(:lesson_name, :lesson_desc, :lesson_cover, :lesson_file_url, :company_id)
    end

    def lesson_update_params
      params.require(:lesson).permit(:lesson_name, :lesson_desc, :lesson_cover, :state, :version, :company_id)
    end

end
