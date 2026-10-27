class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(registration_params)

    if @user.save
      WelcomeMailer.with(user: @user).welcome.deliver_later
      start_new_session_for @user
      redirect_to after_authentication_url, notice: "Welcome to Wheelhouse, #{@user.email_address}."
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  # The role and the member of staff are not here on purpose: a new account gets the
  # default role, and joining it to a member of staff is done from the seed or the console.
  def registration_params
    params.expect(user: [:email_address, :password, :password_confirmation])
  end
end
