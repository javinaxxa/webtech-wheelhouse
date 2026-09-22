class BikesController < ApplicationController
  def index
    @bikes = Bike.by_make_and_model.includes(:customer, :repairs)
  end

  def show
    @bike = Bike.includes(:customer).find(params[:id])
    @repairs = @bike.repairs.by_promised_day.includes(bike: :customer)
  end
end
