class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  before_action :set_locale
   
  # Set page language based by cookies
  def set_locale
    # Create/update/use cookie and detect language from it
    if params[:locale].nil? and cookies[:locale].nil?
      I18n.locale = 'en'
    elsif !params[:locale].nil?
      cookies[:locale] = params[:locale].to_s
      I18n.locale = params[:locale].to_s
    else
      I18n.locale = cookies[:locale]
    end
  end

  # Process all unmatched routes with this 404
  def not_found
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :password, :remember_me) }
  end
end