class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]

  def index
    @customers = Customer.by_name.includes(:bikes)
  end

  def show
    @bikes = @customer.bikes.by_make_and_model.includes(:customer, :repairs)
  end

  def new
    @customer = Customer.new
  end

  def edit
  end

  def create
    @customer = Customer.new(customer_params)

    if @customer.save
      redirect_to @customer, notice: "#{@customer.name} was added to the customer list."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @customer.update(customer_params)
      redirect_to @customer, notice: "#{@customer.name} was updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    if @customer.destroy
      redirect_to customers_path, status: :see_other,
                  notice: "#{@customer.name} was removed from the customer list."
    else
      redirect_to @customer, status: :see_other,
                  alert: @customer.errors.full_messages.to_sentence
    end
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.expect(customer: [:name, :phone])
  end
end
