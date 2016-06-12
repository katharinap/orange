module NavHelper
  def nav_item_classes(path)
    base_class = 'nav-item'
    base_class << ' active' if current_page?(path)
    base_class
  end

  def dropdown_nav_link_classes(path)
    base_class = 'dropdown-item'
    base_class << ' active' if current_page?(path)
    base_class
  end
end
