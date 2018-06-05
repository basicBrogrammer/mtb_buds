module ApplicationHelper
  def nav_active?(nav_path)
    if request.path == rides_path && nav_path == root_path
      nav_path = rides_path
    end
    request.path == nav_path ? 'active' : ''
  end

  def mobile?
    browser.device.mobile?
  end
end
