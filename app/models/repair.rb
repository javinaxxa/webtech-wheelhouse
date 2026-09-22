class Repair < ApplicationRecord
  enum :status, {
    dropped_off: "dropped_off",
    awaiting_approval: "awaiting_approval",
    in_progress: "in_progress",
    ready_for_pickup: "ready_for_pickup",
    picked_up: "picked_up",
    declined: "declined"
  }

  belongs_to :bike
  belongs_to :received_by, class_name: "StaffMember"
  belongs_to :assigned_mechanic, class_name: "StaffMember", optional: true
  has_many :repair_line_items, dependent: :destroy
  has_many :service_types, through: :repair_line_items, dependent: :destroy

  validates :status, :promised_on, :dropped_off_at, presence: true
  validate :dates_are_not_before_drop_off
  validate :hand_back_and_answer_match_state

  private

  def dates_are_not_before_drop_off
    return if dropped_off_at.blank?

    day_in = dropped_off_at.to_date

    if picked_up_at.present? && picked_up_at.to_date < day_in
      errors.add(:picked_up_at, "can't be before the day the bike came in")
    end

    if promised_on.present? && promised_on < day_in
      errors.add(:promised_on, "can't be before the day the bike came in")
    end
  end

  def hand_back_and_answer_match_state
    if !handed_back_state? && picked_up_at.present?
      errors.add(:picked_up_at, "must stay empty until the bike is handed back")
    end

    if past_the_quote? && customer_approved.nil?
      errors.add(:customer_approved, "must be recorded once the repair is past the quote")
    end
  end

  def handed_back_state?
    picked_up? || declined?
  end

  def past_the_quote?
    in_progress? || ready_for_pickup? || picked_up? || declined?
  end
end
