class User < ApplicationRecord
  MINIMUM_PASSWORD_LENGTH = 10

  enum :role, {
    mechanic: "mechanic",
    counter: "counter",
    owner: "owner"
  }

  has_secure_password
  has_many :sessions, dependent: :destroy
  belongs_to :staff_member, optional: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true,
                            uniqueness: { case_sensitive: false,
                                          message: "is already used by another account" },
                            format: { with: URI::MailTo::EMAIL_REGEXP,
                                      message: "is not a valid email address" }

  validates :password, length: {
    minimum: MINIMUM_PASSWORD_LENGTH,
    message: "must be at least #{MINIMUM_PASSWORD_LENGTH} characters long"
  }, allow_nil: true

  validates :role, presence: true
  validates :staff_member_id, uniqueness: { message: "already has an account" }, allow_nil: true

  scope :by_email, -> { order(:email_address) }

  def display_name
    staff_member&.name || email_address
  end
end
