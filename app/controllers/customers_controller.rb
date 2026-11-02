class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]

  def index
    authorize Customer
    @customers = policy_scope(Customer).by_name.includes(:bikes)
  end

  def show
    authorize @customer
    @bikes = policy_scope(Bike).where(customer: @customer)
                               .by_make_and_model.includes(:customer, :repairs)
  end

  def new
    @customer = Customer.new
    authorize @customer
  end

  def edit
    authorize @customer
  end

  def create
    @customer = Customer.new(permitted_attributes(Customer.new))
    authorize @customer

    if @customer.save
      redirect_to @customer, notice: "#{@customer.name} was added to the customer list."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    authorize @customer

    if @customer.update(permitted_attributes(@customer))
      redirect_to @customer, notice: "#{@customer.name} was updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    authorize @customer

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
end
