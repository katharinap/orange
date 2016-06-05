class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(_resource)
    user_exercises_path(current_user)
  end

  def today
    Time.now.in_time_zone('Pacific Time (US & Canada)').to_date
  end

  protected

  def configure_permitted_parameters
    attrs = [:username, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: attrs
    devise_parameter_sanitizer.permit :account_update, keys: attrs
  end

  def current_page_permitted?
    return true if params[:user_id].nil?
    params[:user_id].to_i == current_user.id
  end
end
