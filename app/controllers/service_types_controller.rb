class ServiceTypesController < ApplicationController
  before_action :set_service_type, only: [:show, :edit, :update, :destroy]

  def index
    @service_types = ServiceType.by_name
  end

  def show
    @lines = @service_type.repair_line_items.in_order_charged.includes(repair: :bike)
  end

  def new
    @service_type = ServiceType.new
  end

  def edit
  end

  def create
    @service_type = ServiceType.new(service_type_params)

    if @service_type.save
      redirect_to @service_type, notice: "#{@service_type.name} was added to the price list."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @service_type.update(service_type_params)
      redirect_to @service_type, notice: "#{@service_type.name} was updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    if @service_type.destroy
      redirect_to service_types_path, status: :see_other,
                  notice: "#{@service_type.name} was removed from the price list."
    else
      redirect_to @service_type, status: :see_other,
                  alert: @service_type.errors.full_messages.to_sentence
    end
  end

  private

  def set_service_type
    @service_type = ServiceType.find(params[:id])
  end

  def service_type_params
    params.expect(service_type: [:name, :current_price])
  end
end
