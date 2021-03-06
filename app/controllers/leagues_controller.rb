class LeaguesController < ApplicationController
  layout "widget", only: [:widget]
  include LeaguePermissions

  before_action except: [:index, :new, :create, :medals, :widget] do
    @league = League.includes(:tiebreakers).find(params[:id])
  end

  before_action only: [:medals, :widget] do
    @league = League.includes(:tiebreakers).find(params[:league_id])
  end

  before_action :authenticate_user!, only: [:new, :create]
  before_action :require_user_league_permission, only: [:edit, :update, :modify, :message, :medals, :destroy]
  before_action :require_league_not_hidden_or_permission, only: [:show, :widget]
  before_action :require_hidden, only: [:destroy]

  def index
    @leagues = League.search(params[:q])
                     .order(status: :asc, created_at: :desc)
                     .includes(format: :game)
    if user_signed_in?
      if current_user.permitted_leagues.empty?
        @leagues = @leagues.visible unless user_can_edit_leagues? || user_can_view_leagues?
      else
        @leagues = (@leagues.visible + current_user.permitted_leagues).uniq unless user_can_edit_leagues? || user_can_view_leagues?
      end
    else
      @leagues = @leagues.visible
    end
    @leagues = @leagues.group_by { |league| league.format.game }
    @games = @leagues.keys
  end

  def new
    @league = League.new
    @league.divisions.new
    @weekly_scheduler = @league.build_weekly_scheduler
  end

  def create
    @league = League.new(league_params)

    if @league.save
      @user = current_user
      @user.grant(:edit, @league)
      redirect_to league_path(@league)
    else
      edit
      render :new
    end
  end

  def show
    @rosters = @league.rosters.includes(:division)
    @ordered_rosters = @league.ordered_rosters_by_division
    @divisions = @ordered_rosters.map(&:first)
    @roster = @league.roster_for(current_user) if user_signed_in?
    @personal_matches = @roster.matches.pending.ordered.reverse_order.includes(:home_team, :away_team) if @roster
    @top_div_matches = @divisions.first.matches.pending.ordered
                                 .includes(:home_team, :away_team).last(5)
    @matches = @league.matches.ordered.includes(:rounds, :home_team, :away_team)
                      .group_by(&:division)
  end

  def medals
    @rosters = @league.rosters.includes(:division)
    @ordered_rosters = @league.ordered_rosters_by_division
    @divisions = @ordered_rosters.map(&:first)
    @matches = @league.matches.ordered.includes(:rounds, :home_team, :away_team)
                      .group_by(&:division)
  end

  def widget
    # TODO: rewrite for a better look
    params[:sweek] ||= @league.divisions.find(params[:div]).matches.minimum(:round_number)
    params[:eweek] ||= @league.divisions.find(params[:div]).matches.maximum(:round_number)
    @rosters = @league.rosters.includes(:division)
    @div_rosters = @league.ordered_rosters_by_one_division(params[:div])
    @matches = @league.matches.ordered.includes(:rounds, :home_team, :away_team)
                      .where(:round_number => (params[:sweek].to_i..params[:eweek].to_i))
                      .group_by(&:division)
  end

  def edit
    @weekly_scheduler = @league.weekly_scheduler || League::Schedulers::Weekly.new
  end

  def update
    if @league.update(league_params)
      redirect_to league_path(@league)
    else
      edit
      render :edit
    end
  end

  def modify
    if @league.update(status: params.require(:status))
      redirect_to league_path(@league)
    else
      render :edit
    end
  end

  def destroy
    if @league.destroy
      redirect_to leagues_path
    else
      render :edit
    end
  end

  before_action only: [:message] do
    message = params.require(:message)
    url = params.require(:url)
    captains = params.require(:captains)
    league_id = @league.id
  end

  def message
    message = params['message']
    url = params['url']
    captains = params['captains']
    league_id = @league.id
    i = 0
    if captains == '1'

      Team.find_each do |team|
        if team.rosters.joins(:division).where(league_divisions: { league_id: league_id }).exists?
          User.which_can(:edit, team).each do |user|
            Users::NotificationService.call(user, message, url)
            i += 1
          end
        end
      end

      flash[:notice] = 'The message was sent to  ' + i.to_s + ' captains'
      redirect_to league_path(@league)

    else

      @league.rosters.find_each do |roster|
        roster.players.find_each do |gamer|
          user = User.find(gamer.user_id)
          Users::NotificationService.call(user, message, url)
          i += 1
        end
      end 

      flash[:notice] = 'The message was sent to  ' + i.to_s + ' participants'
      redirect_to league_path(@league)

    end
  end

  private

  LEAGUE_PARAMS = [
    :name, :description, :rules, :banner, :display, :format_id, :category,
    :signuppable, :roster_locked, :matches_submittable, :transfers_require_approval, :allow_disbanding,
    :forfeit_all_matches_when_roster_disbands,
    :min_players, :max_players,
    :schedule_locked, :schedule,
    :points_per_round_win, :points_per_round_draw, :points_per_round_loss,
    :points_per_match_win, :points_per_match_draw, :points_per_match_loss,
    :points_per_forfeit_win, :points_per_forfeit_draw, :points_per_forfeit_loss,
    weekly_scheduler_attributes: [:id, :start_of_week, :minimum_selected, days_indecies: []],
    tiebreakers_attributes: [:id, :kind, :_destroy],
    divisions_attributes: [:id, :name, :_destroy],
    pooled_maps_attributes: [:id, :map_id, :_destroy]
  ].freeze

  # WIDGET_PARAMS = [
    # :div, :sweek, :eweek
  # ].freeze

  WIDGET_PARAMS = [
    :div
  ].freeze

  def league_params
    params.require(:league).permit(LEAGUE_PARAMS)
  end

  def widget_params
    params.require(:widget).permit(WIDGET_PARAMS)
  end

  def require_hidden
    redirect_to league_path(@league) unless @league.hidden?
  end

  def require_user_leagues_permission
    redirect_to leagues_path unless user_can_edit_leagues?
  end

  def require_user_league_permission
    redirect_to league_path(@league) unless user_can_edit_league?
  end

  def require_league_not_hidden_or_permission
    redirect_to leagues_path unless !@league.hidden? || user_can_edit_league? || user_can_edit_leagues?
  end
end
