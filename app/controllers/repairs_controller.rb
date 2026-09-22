class RepairsController < ApplicationController
  def index
    @repairs = Repair.by_promised_day.includes(bike: :customer)
  end

  def show
    @repair = Repair.includes(:received_by, :assigned_mechanic, bike: :customer).find(params[:id])
    @lines = @repair.repair_line_items.in_order_charged.includes(:service_type)
  end
end
