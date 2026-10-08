class OrderProducer

  TOPIC = "orders"

  def self.publish(order)

    kafka = Kafka.new(
      seed_brokers: ENV.fetch(
        "KAFKA_BROKERS",
        "localhost:9092"
      )
    )

    message = {
      event: "order_created",

      order: {
        id: order.id,
        customer_name: order.customer_name,
        product_name: order.product_name,
        quantity: order.quantity,
        amount: order.amount.to_f
      },

      created_at: Time.current.iso8601
    }

    kafka.deliver_message(
      message.to_json,
      topic: TOPIC,
      key: order.id.to_s
    )

  ensure
    kafka&.close
  end

end