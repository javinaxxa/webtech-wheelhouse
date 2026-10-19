module Api
  module V1
    class ServicesController < BaseController
      before_action :authenticate!, only: [:create]

      def index
        services = ServiceType.by_name.left_joins(:repair_line_items)
                              .group(:id)
                              .select("service_types.*, COUNT(repair_line_items.id) AS charged_count")

        render json: services.map { |service| service_document(service) }, status: :ok
      end

      def show
        service = ServiceType.find(params[:id])

        render json: service_document(service), status: :ok
      end

      def create
        service = ServiceType.new(service_params)

        if service.save
          render json: service_document(service),
                 status: :created,
                 location: api_v1_service_url(service)
        else
          render_errors(service.errors.full_messages, :unprocessable_content)
        end
      end

      private

      def service_document(service)
        {
          id: service.id,
          name: service.name,
          price: format("%.0f", service.current_price),
          charged_on_repairs: charged_count_for(service)
        }
      end

      def charged_count_for(service)
        if service.respond_to?(:charged_count)
          service.charged_count
        else
          service.repair_line_items.size
        end
      end

      def service_params
        params.expect(service: [:name, :current_price])
      end
    end
  end
end
