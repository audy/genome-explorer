DumpProteinsToFileJob = Struct.new(:filename) do

  def perform
    out = File.open(self.filename, 'w')
    ActiveRecord::Base.logger.level = 1

    pbar = ProgressBar.new 'dumping', Feature.where(feature_type: 'CDS').count

    Scaffold.all.each do |scaffold|
      scaffold.features.where(feature_type: 'CDS').each do |feature|
        seq = feature.protein_sequence
        # skip proteins w/ weird starts or stops in the middle or dont end in a
        # stop.
        pbar.inc
        out.puts ">#{feature.id}\n#{feature.protein_sequence}" unless feature.weird?
      end
    end

    pbar.finish
    out.close
  end

end
