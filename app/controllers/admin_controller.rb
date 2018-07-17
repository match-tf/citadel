class AdminController < ApplicationController
  before_action :require_any_admin_permissions

  def index
  end

  before_action only: [:host_grant] do
    @user = User.all.find(params.require(:user_id))
  end  
 
  def host
  end  

  def host_grant
    @user.grant(:view, :leagues)
    @user.grant(:create, :leagues)
	@user.notifications.create(user_id: @user.id, message: "You have been granted the tournament host permissions! Click this notification to create your first tournament.", link: "/tournaments/new", created_at: Time.now, updated_at: Time.now)
	@user.badge_name = "Tournament host"
	@user.badge_color = 3
    @user.save
    flash[:notice] = 'Host permissions granted!'
	redirect_to(admin_host_path)
  end
  
  def statistics
    @timeframe = (params[:t] || 30.minutes).to_i.seconds
    events_in_timeframe = Ahoy::Event.where(time: @timeframe.ago..Time.current)
    @events_per_second = events_in_timeframe.count / @timeframe.to_f
    @users_count = User.count
    @api_keys_count = APIKey.count
    @teams_count = Team.count
    @matches_count = League::Match.count
    @match_comms_count = League::Match::Comm.count
    @match_comm_edits_count = League::Match::CommEdit.count - @match_comms_count
  end

  private

  def require_any_admin_permissions
    redirect_to root_path unless user_signed_in? && current_user.admin?
  end
end
