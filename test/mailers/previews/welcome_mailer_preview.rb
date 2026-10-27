class WelcomeMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/welcome_mailer/welcome
  def welcome
    WelcomeMailer.with(user: User.first || User.new(email_address: "someone@wheelhouse.cl")).welcome
  end
end
