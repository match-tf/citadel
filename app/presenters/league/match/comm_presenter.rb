class League
  class Match
    class CommPresenter < BasePresenter
      presents :comm

      def user_roster
        @user_roster ||=
          if comm.match.home_team.on_roster?(comm.created_by)
            comm.match.home_team
          elsif comm.match.away_team.on_roster?(comm.created_by)
            comm.match.away_team
          end
      end

      def user_team
        user_roster&.team
      end

      def league
        comm.league
      end

      def created_at
        comm.created_at.strftime('%c')
      end

      def deleted_at
        comm.deleted_at.strftime('%c')
      end

      def created_by
        @created_by ||= present(comm.created_by)
      end

      def deleted_by
        @deleted_by ||= present(comm.deleted_by)
      end

      def content
        # rubocop:disable Rails/OutputSafety
        comm.content_render_cache.html_safe
        # rubocop:enable Rails/OutputSafety
      end

      def panel_class
        if comm.created_by.admin?
          'panel-warning'
        else
          'panel-default'
        end
      end
    end
  end
end
