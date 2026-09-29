class RepairsController < ApplicationController
  before_action :set_repair, only: [:show, :edit, :update, :destroy]

  BLANK_LINES = 3

  def index
    @repairs = Repair.by_promised_day.includes(bike: :customer)
  end

  def show
    @lines = @repair.repair_line_items.in_order_charged.includes(:service_type)
  end

  def new
    @repair = Repair.new(bike_id: params[:bike_id], dropped_off_at: Time.current)
    BLANK_LINES.times { @repair.repair_line_items.build }
  end

  def edit
    BLANK_LINES.times { @repair.repair_line_items.build }
  end

  def create
    @repair = Repair.new(repair_params)

    if @repair.save
      redirect_to @repair, notice: "Repair ##{@repair.id} for #{@repair.bike.serial_number} was booked in."
    else
      pad_blank_lines
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @repair.update(repair_params)
      redirect_to @repair, notice: "Repair ##{@repair.id} was updated."
    else
      pad_blank_lines
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    if @repair.destroy
      redirect_to repairs_path, status: :see_other,
                  notice: "Repair ##{@repair.id} was deleted."
    else
      redirect_to @repair, status: :see_other,
                  alert: @repair.errors.full_messages.to_sentence
    end
  end

  private

  def set_repair
    @repair = Repair.find(params[:id])
  end

  def pad_blank_lines
    (BLANK_LINES - @repair.repair_line_items.select(&:new_record?).size).times do
      @repair.repair_line_items.build
    end
  end

  def repair_params
    params.expect(repair: [:bike_id, :received_by_id, :assigned_mechanic_id, :status,
                           :promised_on, :dropped_off_at, :completed_at, :picked_up_at,
                           :customer_approved,
                           repair_line_items_attributes: [[:id, :service_type_id,
                                                          :price_charged, :discount_note,
                                                          :_destroy]]])
  end
end
