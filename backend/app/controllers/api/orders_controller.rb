module Api
  class OrdersController < ApplicationController
    def index
      orders = Order.order(created_at: :desc)

      render json: orders
    end

    def create
      order = Order.create!(order_params)

      OrderProducer.publish(order)

      render json: order, status: :created

    rescue ActiveRecord::RecordInvalid => e
      render json: {
        error: e.record.errors.full_messages
      }, status: :unprocessable_entity
    rescue StandardError => e
      Rails.logger.error("Order creation failed: #{e.message}")

      render json: {
        error: "Unable to create order"
      }, status: :internal_server_error
    end

    private

    def order_params
      params.permit(
        :customer_name,
        :product_name,
        :quantity,
        :amount
      ).merge(status: "pending")
    end
  end
end

