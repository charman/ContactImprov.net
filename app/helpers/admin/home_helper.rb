module Admin::HomeHelper

  def admin_controller_breadcrumb_link
    link_to (params[:controller].gsub('admin/', '').titleize.gsub('_', ''), "/#{params[:controller]}") 
  end

end
