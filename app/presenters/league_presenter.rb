class LeaguePresenter < BasePresenter
  presents :league

  def to_s
    league.name
  end

  def link
    link_to league.name, league_path(league)
  end

  def help(info)
    data = { toggle: :tooltip, placement: :left,
             html: 'true', 'original-title' => info }
  end

  def description
    # rubocop:disable Rails/OutputSafety
    league.description_render_cache.html_safe
    # rubocop:enable Rails/OutputSafety
  end

  def rules
    # rubocop:disable Rails/OutputSafety
    league.rules_render_cache.html_safe
    # rubocop:enable Rails/OutputSafety
  end

  def list_group_item_class
    if league.hidden?
      'list-group-item list-group-item-warning'
    elsif league.running?
      'list-group-item list-group-item-info'
    else
      'list-group-item list-group-item-success'
    end
  end
end
