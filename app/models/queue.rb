require 'bunny'

class Queue
  EXCHANGE_NAME = "shotter".freeze
  QUEUE_NAME = "snapper".freeze

  def self.push(uuid)
    b, exch = setup
    exch.publish(uuid)
    b.stop
  end

  def self.pop(options = {})
    b, exch = setup
    q = b.queue(QUEUE_NAME)
    q.bind(exch)

    options = {:consumer_tag => "worker", :timeout => 900}.merge(options)

    q.subscribe(options) do |msg|
      yield msg[:payload]
    end

    b.stop
  end

  protected

  def self.setup
    bunny = Bunny.new(:logging => false)
    bunny.start
    exchange = bunny.exchange(EXCHANGE_NAME)

    [bunny, exchange]
  end
end

