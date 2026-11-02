class ServiceTypesController < ApplicationController
  allow_unauthenticated_access only: [:index, :show]

  # The price list is open, but if somebody is signed in the navigation bar
  # and the buttons should know it.
  before_action :resume_session, only: [:index, :show]
  before_action :set_service_type, only: [:show, :edit, :update, :destroy]

  def index
    @service_types = policy_scope(ServiceType).by_name
  end

  def show
    authorize @service_type
    @lines = @service_type.repair_line_items.in_order_charged.includes(repair: :bike)
  end

  def new
    @service_type = ServiceType.new
    authorize @service_type
  end

  def edit
    authorize @service_type
  end

  def create
    @service_type = ServiceType.new(permitted_attributes(ServiceType.new))
    authorize @service_type

    if @service_type.save
      redirect_to @service_type, notice: "#{@service_type.name} was added to the price list."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    authorize @service_type

    if @service_type.update(permitted_attributes(@service_type))
      redirect_to @service_type, notice: "#{@service_type.name} was updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    authorize @service_type

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
end
