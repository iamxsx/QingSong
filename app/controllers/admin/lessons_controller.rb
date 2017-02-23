class Admin::LessonsController < Admin::AdminApplicationController
  layout 'admin'
  before_action :set_lesson, only: [:show, :edit, :update, :destroy]

  def index
    @lessons = Lesson.all
  end

  def new
    @lesson = Lesson.new
  end

  # 当高管审核完成课程后，需要将 preview 下的文件复制到 ultimate 目录下
  def update_lesson
    lesson = Lesson.find params[:lesson][:lesson_id]
    if !lesson.nil?
      lesson_file_moveto_ultimate lesson
    end
  end

  #
  def create
    @lesson = Lesson.new(lesson_params)
    @lesson.lesson_file_name = params[:lesson][:lesson_file_url].original_filename.split('.')[0]

    if @lesson.save
      # 将上传的文件放进任务队列里处理
      LessonFileParseJob.perform_later @lesson
      redirect_to '/admin/lessons'
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_lesson
    @lesson = Lesson.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def lesson_params
    params.require(:lesson).permit(:lesson_name, :lesson_desc, :lesson_cover, :lesson_file_url, :company_id)
  end

end
