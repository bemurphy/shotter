class Queue
  EXCHANGE_NAME = "shotter".freeze

  def self.push(data)
    b = Bunny.new(:logging => false)
    b.start
    exch = b.exchange(EXCHANGE_NAME)
    exch.publish(data)
    b.stop
  end

  def self.subscribe(options = {})
    b = Bunny.new(:logging => false)
    b.start
    q = b.queue("snapper")
    exch = b.exchange(EXCHANGE_NAME)
    q.bind(exch)

    options = {:consumer_tag => "worker", :timeout => 900}.merge(options)

    q.subscribe(options) do |msg|
      yield msg
    end

    b.stop
  end
end

