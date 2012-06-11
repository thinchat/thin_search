class IndexSphinxJob
  @queue = :index

  def self.perform
    Rake::Task['ts:index'].invoke
  end
end