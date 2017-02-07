module TimeHelper

  # 获取如下格式的时间
  # => "2007-01-18 06:10:17"
  def current_time
    Time.current.getlocal('+08:00').to_formatted_s(:db)
  end

end
