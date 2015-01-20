# as the name suggests, this should only _update_ feature relationships, not
# build a new feature-relationships graph from scratch. However, building the
# graph from scratch is a special case of updating it when no genomes have been
# added before so the same job should be used for initially constructing the
# graph.

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
