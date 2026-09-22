class CustomersController < ApplicationController
  def index
    @customers = Customer.by_name.includes(:bikes)
  end

  def show
    @customer = Customer.find(params[:id])
    @bikes = @customer.bikes.by_make_and_model.includes(:customer, :repairs)
  end
end
