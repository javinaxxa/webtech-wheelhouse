module Api
  module V1
    class RepairsController < BaseController
      before_action :authenticate!

      def index
        repairs = preloaded_repairs.by_promised_day
        repairs = filter_by_state(repairs) if params[:state].present?
        return if performed?

        render json: repairs.map { |repair| repair_document(repair) }, status: :ok
      end

      def show
        repair = preloaded_repairs.find(params[:id])

        render json: repair_document(repair), status: :ok
      end

      private

      def preloaded_repairs
        Repair.includes(bike: :customer, repair_line_items: :service_type)
      end

      def filter_by_state(repairs)
        state = params[:state].to_s

        unless Repair.statuses.key?(state)
          render_errors(
            ["#{state} is not a state. The states are: #{Repair.statuses.keys.join(', ')}."],
            :bad_request
          )
          return repairs
        end

        repairs.where(status: state)
      end

      def repair_document(repair)
        {
          id: repair.id,
          state: repair.status,
          dropped_off_at: repair.dropped_off_at&.iso8601,
          promised_on: repair.promised_on&.iso8601,
          handed_back_at: repair.picked_up_at&.iso8601,
          customer_approved: repair.customer_approved,
          overdue: repair.overdue?,
          total: format("%.0f", repair.total),
          bike: {
            make: repair.bike.make,
            model: repair.bike.model,
            serial_number: repair.bike.serial_number
          },
          customer: {
            name: repair.bike.customer.name
          },
          lines: repair.repair_line_items.map do |line|
            {
              service: line.service_type.name,
              price_charged: format("%.0f", line.price_charged)
            }
          end
        }
      end
    end
  end
end
