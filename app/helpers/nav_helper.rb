module NavHelper
  def nav_item_classes(path)
    base_class = 'nav-item'
    base_class << ' active' if current_page?(path)
    base_class
  end
end
