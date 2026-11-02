class RepairsController < ApplicationController
  before_action :set_repair, only: [:show, :edit, :update, :destroy]

  BLANK_LINES = 3

  PHOTO_PRELOAD = { intake_photos_attachments: { blob: :variant_records } }.freeze

  def index
    @repairs = policy_scope(Repair).by_promised_day
                                   .includes(:rich_text_diagnosis, :taken_in_by,
                                             PHOTO_PRELOAD, bike: :customer)
  end

  def show
    authorize @repair
    @lines = @repair.repair_line_items.in_order_charged.includes(:service_type)
  end

  def new
    @repair = Repair.new(bike_id: params[:bike_id], dropped_off_at: Time.current)
    authorize @repair
    BLANK_LINES.times { @repair.repair_line_items.build }
  end

  def edit
    authorize @repair
    BLANK_LINES.times { @repair.repair_line_items.build }
  end

  def create
    @repair = Repair.new(permitted_attributes(Repair.new))
    authorize @repair
    @repair.taken_in_by = Current.user

    if @repair.save
      redirect_to @repair, notice: "Repair ##{@repair.id} for #{@repair.bike.serial_number} was booked in."
    else
      pad_blank_lines
      render :new, status: :unprocessable_content
    end
  end

  def update
    authorize @repair

    if @repair.update(permitted_attributes(@repair))
      redirect_to @repair, notice: "Repair ##{@repair.id} was updated."
    else
      pad_blank_lines
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    authorize @repair

    if @repair.destroy
      redirect_to repairs_path, status: :see_other,
                  notice: "Repair ##{@repair.id} was deleted."
    else
      redirect_to @repair, status: :see_other,
                  alert: @repair.errors.full_messages.to_sentence
    end
  end

  private

  # A mechanic who asks for a repair that is not theirs gets a 404 here, before
  # the policy is even reached: the scope and the policy give the same answer.
  def set_repair
    @repair = policy_scope(Repair)
                .includes(:rich_text_diagnosis, :taken_in_by, PHOTO_PRELOAD)
                .find(params[:id])
  end

  def pad_blank_lines
    (BLANK_LINES - @repair.repair_line_items.select(&:new_record?).size).times do
      @repair.repair_line_items.build
    end
  end
end
