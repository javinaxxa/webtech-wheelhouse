class BikesController < ApplicationController
  before_action :set_bike, only: [:show, :edit, :update, :destroy]

  def index
    @bikes = Bike.by_make_and_model.includes(:customer, :repairs)
  end

  def show
    @repairs = @bike.repairs.by_promised_day.includes(bike: :customer)
  end

  def new
    @bike = Bike.new(customer_id: params[:customer_id])
  end

  def edit
  end

  def create
    @bike = Bike.new(bike_params)

    if @bike.save
      redirect_to @bike, notice: "Bike #{@bike.serial_number} was added for #{@bike.customer.name}."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @bike.update(bike_params)
      redirect_to @bike, notice: "Bike #{@bike.serial_number} was updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    if @bike.destroy
      redirect_to bikes_path, status: :see_other,
                  notice: "Bike #{@bike.serial_number} was removed."
    else
      redirect_to @bike, status: :see_other,
                  alert: @bike.errors.full_messages.to_sentence
    end
  end

  private

  def set_bike
    @bike = Bike.find(params[:id])
  end

  def bike_params
    params.expect(bike: [:customer_id, :make, :model, :color, :serial_number])
  end
end
