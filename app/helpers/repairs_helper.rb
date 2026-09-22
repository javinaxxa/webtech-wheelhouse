module RepairsHelper
  def status_badge(repair)
    tag.span repair.status.humanize, class: "badge text-bg-#{status_color(repair)}"
  end

  def repair_row_class(repair)
    "table-warning" if repair.overdue?
  end

  private

  def status_color(repair)
    if    repair.picked_up?         then "success"
    elsif repair.declined?          then "danger"
    elsif repair.ready_for_pickup?  then "info"
    elsif repair.in_progress?       then "primary"
    elsif repair.awaiting_approval? then "warning"
    else                                 "secondary"
    end
  end
end
