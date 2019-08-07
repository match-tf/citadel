module API
  module V1
    class APIController < ActionController::API

      before_action :track_action

      rescue_from Exception do |error|
        handle_error(error) if error
      end

      protected

      def handle_error(error)
        if error.is_a? ActiveRecord::RecordNotFound
          render_not_found
        elsif error.is_a? ActionController::RoutingError
          render_not_found message: 'Unknown route'
        else
          throw error if Rails.env.test?

          json = { message: 'Internal error' }
          json[:traceback] = error.backtrace if Rails.env.development?

          render_error :internal_server_error, json
        end
      end

      def render_error(status_code, json)
        json[:status] ||= Rack::Utils.status_code(status_code)

        render status: status_code, json: json
      end

      def render_not_found(options = {})
        options[:message] ||= 'Record not found'

        render_error :not_found, options
      end

      def track_action
        ahoy.track "#{request.method} #{request.fullpath}", request.filtered_parameters.to_s
      end
    end
  end
end
