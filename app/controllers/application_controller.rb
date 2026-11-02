class ApplicationController < ActionController::Base
  include Authentication
  include Pundit::Authorization

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  # An action that forgets to ask its policy, and an index that is not built from
  # a scope, fail here instead of answering. A new controller is covered without a
  # line written in it.
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  rescue_from Pundit::NotAuthorizedError, with: :refuse

  private

  # Pundit hands this account to every policy. No policy reads the session itself.
  def pundit_user
    Current.user
  end

  def refuse
    render "errors/forbidden", status: :forbidden
  end
end
