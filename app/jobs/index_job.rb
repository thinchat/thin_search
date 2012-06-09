require 'json'

class IndexJob
  @queue = :index

  def self.perform(msg)
    data = JSON.parse(msg)
    puts data.inspect
    Message.create(msg)
  end
end