class RepairsController < ApplicationController
  def index
    @repairs = Repair.by_promised_day
  end

  def show
    @repair = Repair.find(params[:id])
    @lines = @repair.repair_line_items.in_order_charged
  end
end
