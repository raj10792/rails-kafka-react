class OrderConsumer
  TOPIC = "orders"
  GROUP_ID = "order-processing-group"

  def self.start
    puts "======================================"
    puts "KAFKA CONSUMER STARTED"
    puts "Brokers: #{ENV.fetch('KAFKA_BROKERS', 'kafka:9092')}"
    puts "Topic: #{TOPIC}"
    puts "Group: #{GROUP_ID}"
    puts "======================================"

    STDOUT.flush

    kafka = Kafka.new(
      seed_brokers: ENV.fetch("KAFKA_BROKERS", "kafka:9092")
    )

    puts "Kafka client created"
    STDOUT.flush

    consumer = kafka.consumer(group_id: GROUP_ID)

    puts "Kafka consumer created"
    STDOUT.flush

    consumer.subscribe(TOPIC)

    puts "Subscribed to #{TOPIC}"
    puts "Waiting for messages..."
    STDOUT.flush

    consumer.each_message do |message|
      puts "======================================"
      puts "MESSAGE RECEIVED"
      puts "Topic: #{message.topic}"
      puts "Partition: #{message.partition}"
      puts "Offset: #{message.offset}"
      puts "Message: #{message.value}"
      puts "======================================"

      STDOUT.flush

      data = JSON.parse(message.value)

      process_order(data)
    end

  rescue => e
    puts "======================================"
    puts "KAFKA CONSUMER ERROR"
    puts "#{e.class}: #{e.message}"
    puts e.backtrace
    puts "======================================"

    STDOUT.flush

    raise
  ensure
    consumer&.stop
    kafka&.close
  end

  def self.process_order(data)
    order_id = data.dig("order", "id")

    puts "Processing order: #{order_id}"

    order = Order.find_by(id: order_id)

    unless order
      puts "Order #{order_id} not found"
      return
    end

    order.update!(status: "processed")

    puts "Order #{order_id} processed successfully"

    STDOUT.flush
  end
end