module Api
  module V1
    class BaseController < ActionController::API
      include ActionController::HttpAuthentication::Token::ControllerMethods

      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      rescue_from ActionController::ParameterMissing, with: :bad_request

      private

      def authenticate!
        authenticate_or_request_with_http_token do |token, _options|
          expected = Rails.application.credentials.dig(:api, :token).to_s
          token.present? &&
            expected.present? &&
            ActiveSupport::SecurityUtils.secure_compare(token, expected)
        end
      end

      def request_http_token_authentication(_realm = nil, _message = nil)
        render_errors(["This request needs a bearer token in the Authorization header."],
                      :unauthorized)
      end

      def not_found(_exception)
        render_errors(["There is no record with that id."], :not_found)
      end

      def bad_request(exception)
        render_errors(["The request body is missing #{exception.param}."], :bad_request)
      end

      def render_errors(messages, status)
        render json: { errors: Array(messages) }, status: status
      end
    end
  end
end
