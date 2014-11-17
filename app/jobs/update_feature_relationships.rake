class UpdateFeatureRelationships
  class << self
  def perform
    ProteinRelationship.transaction do

      # clean up old relations
      ProteinRelationship.delete_all


      File.open('neighbors.txt') do |handle|
        pbar = ProgressBar.new 'updating', File.size(handle.path)
        build_relations(handle).lazy.each_slice(1_000) do |chunk|
          pbar.set handle.pos
          ProteinRelationship.import(chunk)
        end
        pbar.finish
      end

    end # transaction
  end

  private

  def build_relations(handle, &block)
    Enumerator.new do |enum|
      handle.each do |line|
        query_id, hits = parse_graph_line(line)
        hits.each do |hit_id|
          enum.yield ProteinRelationship.new(feature_id: query_id, related_feature_id: hit_id)
        end
      end
    end
  end

  def parse_graph_line(line)
    dat = JSON.parse(line)
    query_id = dat['query']
    hits = dat['hits']
    [query_id, hits]
  end

  end
end

desc 'update protein relationships'
task :update_graph => :environment do
  UpdateFeatureRelationships.perform
end
