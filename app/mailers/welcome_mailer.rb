class WelcomeMailer < ApplicationMailer
  def welcome
    @user = params[:user]
    @sign_in_url = new_session_url

    mail to: @user.email_address,
         subject: "Welcome to Wheelhouse"
  end
end
