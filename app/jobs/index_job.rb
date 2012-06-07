class IndexJob
  @queue = :index

  def self.perform(msg)
    puts msg
  end
end