module RepairsHelper
  STATUS_COLORS = {
    "dropped_off"       => "secondary",
    "awaiting_approval" => "warning",
    "in_progress"       => "primary",
    "ready_for_pickup"  => "info",
    "picked_up"         => "success",
    "declined"          => "danger"
  }.freeze

  CLOSED_STATUSES = %w[picked_up declined].freeze

  def status_badge(repair)
    color = STATUS_COLORS.fetch(repair.status, "secondary")
    tag.span repair.status.humanize, class: "badge text-bg-#{color}"
  end

  def repair_overdue?(repair)
    return false if CLOSED_STATUSES.include?(repair.status)

    repair.promised_on < Date.current
  end

  def repair_row_class(repair)
    "table-warning" if repair_overdue?(repair)
  end
end