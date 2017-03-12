module UsersHelper

  def generate_verify_code

  end

  #用于设置页面中的导航栏的样式 (页面标签,页面期待值)
  def set_active_class(page_tag, expective)
    if page_tag == expective
      return "item active"
    else
      return "item"
    end
  end

end
