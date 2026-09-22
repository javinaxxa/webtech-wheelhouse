class BikesController < ApplicationController
  def index
    @bikes = Bike.by_make_and_model
  end

  def show
    @bike = Bike.find(params[:id])
    @repairs = @bike.repairs.by_promised_day
  end
end
