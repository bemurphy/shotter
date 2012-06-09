require 'bunny'

class Queue
  EXCHANGE_NAME = "shotter".freeze

  def self.push(uuid)
    b = Bunny.new(:logging => false)
    b.start
    exch = b.exchange(EXCHANGE_NAME)
    exch.publish(uuid)
    b.stop
  end

  def self.pop(options = {})
    b = Bunny.new(:logging => false)
    b.start
    q = b.queue("snapper")
    exch = b.exchange(EXCHANGE_NAME)
    q.bind(exch)

    options = {:consumer_tag => "worker", :timeout => 900}.merge(options)

    q.subscribe(options) do |msg|
      yield msg[:payload]
    end

    b.stop
  end
end

