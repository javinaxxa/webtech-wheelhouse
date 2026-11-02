class PagesController < ApplicationController
  # Authentication and the static pages have no model and no policy; they are
  # listed in docs/decisions.md with the reason they are open.
  skip_after_action :verify_authorized, :verify_policy_scoped

  def home
  end

  def visit
  end

  def about
  end
end