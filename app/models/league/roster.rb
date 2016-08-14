class League
  class Roster < ApplicationRecord
    include ::RosterMixin

    belongs_to :team
    belongs_to :division
    delegate :league, to: :division, allow_nil: true
    has_many :transfers, -> { order(created_at: :desc) },
             inverse_of: :roster, class_name: 'Transfer', dependent: :destroy
    accepts_nested_attributes_for :transfers

    has_many :home_team_matches, class_name: 'Match', foreign_key: 'home_team_id',
                                 dependent: :destroy
    has_many :home_team_rounds, through: :home_team_matches, source: :rounds
    has_many :not_forfeited_home_team_matches, -> { not_forfeited }, class_name: 'Match',
                                                                     foreign_key: 'home_team_id'
    has_many :not_forfeited_home_team_rounds, through: :not_forfeited_home_team_matches,
                                              source: :rounds

    has_many :away_team_matches, class_name: 'Match', foreign_key: 'away_team_id',
                                 dependent: :destroy
    has_many :away_team_rounds, through: :away_team_matches, source: :rounds
    has_many :not_forfeited_away_team_matches, -> { not_forfeited }, class_name: 'Match',
                                                                     foreign_key: 'away_team_id'
    has_many :not_forfeited_away_team_rounds, through: :not_forfeited_away_team_matches,
                                              source: :rounds

    has_many :titles, class_name: 'User::Title'
    has_many :comments, class_name: 'Roster::Comment', inverse_of: :roster,
                        dependent: :destroy

    validates :team,        presence: true, uniqueness: { scope: :division_id }
    validates :division,    presence: true
    validates :name,        presence: true, uniqueness: { scope: :division_id },
                            length: { in: 1..64 }
    validates :description, presence: true, allow_blank: true
    validates :ranking,     numericality: { greater_than: 0 }, allow_nil: true
    validates :seeding,     numericality: { greater_than: 0 }, allow_nil: true
    validates :approved,    inclusion: { in: [true, false] }
    validates :disbanded,   inclusion: { in: [true, false] }
    validate :player_count_minimums
    validate :player_count_maximums

    after_create do
      League.increment_counter(:rosters_count, league.id)
    end

    after_destroy do
      League.decrement_counter(:rosters_count, league.id)
    end

    after_initialize :set_defaults, unless: :persisted?

    def matches
      home_team_matches.union(away_team_matches)
    end

    def won_rounds
      not_forfeited_home_team_rounds
        .home_team_wins
        .union(not_forfeited_away_team_rounds.away_team_wins)
    end

    def drawn_rounds
      not_forfeited_home_team_rounds
        .union(not_forfeited_away_team_rounds)
        .draws
    end

    def lost_rounds
      not_forfeited_home_team_rounds
        .away_team_wins
        .union(not_forfeited_away_team_rounds.home_team_wins)
    end

    def forfeit_won_matches
      away_team_matches
        .home_team_forfeited
        .union(home_team_matches.away_team_forfeited)
        .union(matches.technically_forfeited)
    end

    def forfeit_lost_matches
      home_team_matches
        .home_team_forfeited
        .union(away_team_matches.away_team_forfeited)
        .union(matches.mutually_forfeited)
    end

    def update_match_counters!
      update!(won_rounds_count:           won_rounds.count,
              drawn_rounds_count:         drawn_rounds.count,
              lost_rounds_count:          lost_rounds.count,
              forfeit_won_matches_count:  forfeit_won_matches.count,
              forfeit_lost_matches_count: forfeit_lost_matches.count)
      update!(points: calculate_points,
              total_scores: calculate_total_scores)
    end

    def approved_transfers
      transfers.where(approved: true)
    end

    def rosters_not_played
      division.approved_rosters
              .where.not(id: id)
              .where.not(id: home_team_matches.select(:away_team_id))
              .where.not(id: away_team_matches.select(:home_team_id))
    end

    def players_off_roster
      team.players.where.not(user: players.map(&:user_id))
    end

    def users_off_roster
      players_off_roster.map(&:user)
    end

    def player_transfers(*args)
      super.where(approved: true)
    end

    def disband
      return destroy if league.signuppable?

      transaction do
        forfeit_all!
        update!(disbanded: true)
      end
    end

    def sort_keys
      @sort_keys ||= calculate_sort_keys
    end

    private

    def calculate_sort_keys
      keys = [ranking || Float::INFINITY, -points]

      tiebreaker_keys = league.tiebreakers.map { |tiebreaker| -tiebreaker.get_comparison(self) }

      keys + tiebreaker_keys
    end

    def calculate_points
      local_counts = [won_rounds_count, drawn_rounds_count, lost_rounds_count,
                      forfeit_won_matches_count, forfeit_lost_matches_count]
      comp_counts = league.point_multipliers

      local_counts.zip(comp_counts).map { |x, y| x * y }.sum
    end

    def calculate_total_scores
      not_forfeited_home_team_rounds.sum(:home_team_score) +
        not_forfeited_away_team_rounds.sum(:away_team_score)
    end

    def forfeit_all!
      no_forfeit = Match.forfeit_bies[:no_forfeit]

      home_team_matches.where(forfeit_by: no_forfeit).find_each do |match|
        match.update!(forfeit_by: Match.forfeit_bies[:home_team_forfeit])
      end
      away_team_matches.where(forfeit_by: no_forfeit).find_each do |match|
        match.update!(forfeit_by: Match.forfeit_bies[:away_team_forfeit])
      end
    end

    def set_defaults
      self.approved = false unless approved.present?
    end

    def player_count_minimums
      return unless league.present?

      min_players = league.min_players
      if players.size < min_players
        errors.add(:player_ids, "must have at least #{min_players} players")
      end
    end

    def player_count_maximums
      return unless league.present?

      max_players = league.max_players
      if players.size > max_players && max_players > 0
        errors.add(:player_ids, "must have no more than #{max_players} players")
      end
    end
  end
end