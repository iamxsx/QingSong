class Admin::NoticesController < ApplicationController

  layout 'admin'

  def index
    # 查看新增的课程申请
    @apply_lessons = ApplyLesson.all
    # 查看新入驻的公司申请
    @companies = Company.where(:activated => 0)
  end

end
