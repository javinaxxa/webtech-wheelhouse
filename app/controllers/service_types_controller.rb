class ServiceTypesController < ApplicationController
  def index
    @service_types = ServiceType.by_name
  end

  def show
    @service_type = ServiceType.find(params[:id])
    @lines = @service_type.repair_line_items.in_order_charged
  end
end
