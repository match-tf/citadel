class ApplicationController < ActionController::Base
  include ApplicationPermissions

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  impersonates :user
  before_action :set_raven_context, :set_user_time_zone

  before_action do
    @notifications = current_user.notifications.order(created_at: :desc).load if user_signed_in?
  end

  after_action :track_action

  protected

  def require_login
    redirect_back(fallback_location: root_path) unless user_signed_in?
  end

  def track_action
    ahoy.track "#{request.method} #{request.fullpath}", request.filtered_parameters.to_s
  end
  
  private

  def set_raven_context
    Raven.user_context(id: session[:current_user_id]) 
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

  def set_user_time_zone
    Time.zone = current_user.time_zone if user_signed_in?
  end

end
